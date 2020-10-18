package com.sjw.imageUp.controller;

import cn.easyproject.easycommons.imageutils.EasyImageWaterMarkUtils;
import com.sjw.imageUp.ImageUpApplication;
import com.sjw.imageUp.model.Greeter;
import com.sjw.imageUp.util.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.core.io.ResourceLoader;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.web3j.crypto.CipherException;
import org.web3j.crypto.Credentials;
import org.web3j.protocol.core.methods.response.TransactionReceipt;
import sun.misc.BASE64Encoder;

import javax.imageio.ImageIO;
import javax.servlet.ServletContext;
import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.math.BigInteger;
import java.util.Optional;

@Controller
public class ipfsUpDown {


    private ResourceLoader resourceLoader;
    private static Logger log = LoggerFactory.getLogger(ImageUpApplication.class);
//    ApplicationHome h = new ApplicationHome(getClass());
//    String dirPath = h.getSource().getParentFile().toString();
    private static Web3Utils web3 = new Web3Utils();


    @Autowired
    public ipfsUpDown(ResourceLoader resourceLoader) throws IOException, CipherException {
        this.resourceLoader = resourceLoader;
    }

    @Value("${web.upload-path}")
    public String path;


    public static String walletPath = "D:/文件册";

    private Resource returnpath;
    //load wallet
    public static Credentials credentials;

    static {
        try {
            credentials = web3.loadWallet("123456",walletPath+"/keyStore1.json");
        } catch (IOException e) {
            e.printStackTrace();
        } catch (CipherException e) {
            e.printStackTrace();
        }
    }


    /**
     * 跳转到文件上传页面
     *
     * @return
     */
    @RequestMapping("ipfs")
    public String toUpload() {
        System.out.println("上传ipfs的 界面...");
        System.out.println(path);

        return "ipfs";
    }

    /**
     * @param file 要上传的文件
     * @return
     */
    //该方法上传一个图片，存入ipfs，再将ipfs地址存入合约，再返回该次交易的hash
    @RequestMapping("ipfsUpload")
    @ResponseBody
    public String upload(@RequestParam("filename") MultipartFile file) throws Exception {

        // 要上传的目标文件存放路径
        String localPath = path;
        // 上传成功或者失败的提示
        String msg = "";


        String filePathName = path + "/" + file.getOriginalFilename();

        if (FileUtils.upload(file, path, file.getOriginalFilename()))
            // 上传成功，给出页面提示
            msg = "上传成功！";
        else {
            msg = "上传失败！";

        }
        if (msg == "上传成功！") {
            System.out.println("upload方法内" + localPath + "/" + file.getOriginalFilename());
        }
        //添加水印
        //easy水印，github上随便找的
        //EasyImageWaterMarkUtils.textWatermark(filePathName,"sjw");

        //调用matlab的DWT水印
//        MatlabUtils matlab = new MatlabUtils();
//        double[] abn = {1,2,3};


        String ImageAddress = ipfsUtils.upload(filePathName);
        log.info("ipfs Address :"+ImageAddress);
        //put ipfs-addr to eth Rinkeby test net

        //connect to web3

        web3.getWeb3ClientVersion();

        //load default contract greeter
        Greeter contract = web3.loadContract(credentials);
        log.info("load success,the contract address :"+contract.getContractAddress());
        String txHash = web3.changeValue(contract,ImageAddress);
        log.info("txHash :"+txHash);
        Optional<TransactionReceipt> receipt = web3.getTransactionReceiptByTxH(txHash);
        log.info("receipt: "+receipt.get().toString());
        //取出信息并拼接为字符串，包括txh、blockNumber、

//        String status = receipt.get().getStatus();
//        BigInteger gasUsed = receipt.get().getGasUsed();
//        BigInteger blockNumber = receipt.get().getBlockNumber();
//        String blockHash = receipt.get().getBlockHash();
//        String responseReceipt = "{'transactionHash':'"+txHash+"','status':'"+status+"','gasUsed':'"+gasUsed+"'}";

        //把receipt对象转为json格式字符串返回
        return Json_ajaxUtils.getJSON(receipt.get());
    }

    /**
     * 显示单张图片
     *
     * @return
     */
    //传入交易hash，获取图，与其他信息
    @RequestMapping("ipfsShow")
    @ResponseBody
    public String showPhotos(@RequestParam("transactionHash") String hash) throws Exception {
        //从交易hash获取ipfs地址

        //web3.getWeb3ClientVersion();
        log.info("transaction information from getTransactionHash function :"+web3.getTransactionReceiptByTxH(hash));
        //load default contract greeter
        Greeter contract = web3.loadContract(credentials);
        String ipfsAddr = contract.greet().send();

        log.info("ipfsAddr is : "+ipfsAddr);

        //imagePathName是完整路径加文件名
        System.out.println("path:"+path);
        File image = ipfsUtils.download(path,ipfsAddr);

        if (image != null) {
            ByteArrayOutputStream baos = new ByteArrayOutputStream();//io流
            BufferedImage bi = ImageIO.read(image);
            image.delete();
            ImageIO.write(bi, "png", baos);//写入流中
            byte[] bytes = baos.toByteArray();//转换成字节
            BASE64Encoder encoder = new BASE64Encoder();
            String png_base64 =  encoder.encodeBuffer(bytes);//转换成base64串
            png_base64 = png_base64.replaceAll("\n", "").replaceAll("\r", "");//删除 \r\n

            System.out.println("png_base64："+png_base64);

            return png_base64;

        }
        return hash;
    }
    @RequestMapping("testWeb3")
    public void testConnect() throws Exception {
        Web3Utils web3 = new Web3Utils();
        web3.getWeb3ClientVersion();
        Credentials credentials = web3.loadWallet("123456",walletPath+"/keyStore1.json");
        //web3.TransactionTest(credentials);
        Greeter contract = web3.deployContract(credentials,"first test");
        web3.changeValue(contract,"my new value");
    }


}
