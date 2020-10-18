package com.sjw.imageUp.controller;

import com.sjw.imageUp.util.FileUtils;
import com.sjw.imageUp.util.MatlabUtils;
import matlabcontrol.MatlabInvocationException;
import matlabcontrol.MatlabProxy;
import matlabcontrol.extensions.MatlabTypeConverter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.core.io.ResourceLoader;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.ServletContext;
import java.io.IOException;
import java.util.Arrays;
import java.util.Date;
import java.util.Map;

@Controller
public class TestController {

    private ResourceLoader resourceLoader;

//    ApplicationHome h = new ApplicationHome(getClass());
//    String dirPath = h.getSource().getParentFile().toString();

    @Autowired
    public TestController(ResourceLoader resourceLoader) {
        this.resourceLoader = resourceLoader;
    }

    @Value("${web.upload-path}")
    public String path;

    private Resource returnpath;
    /**
     * 跳转到文件上传页面
     * @return
     */
    @RequestMapping("test")
    public String toUpload(){


        return "test";
    }

    /**
     *
     * @param file 要上传的文件
     * @return
     */
    @RequestMapping("fileUpload")
    public String upload(@RequestParam("fileName") MultipartFile file, Map<String, Object> map){

        // 要上传的目标文件存放路径
        String localPath = path;
        // 上传成功或者失败的提示
        String msg = "";

        if (FileUtils.upload(file, localPath, file.getOriginalFilename())){
            // 上传成功，给出页面提示
            msg = "上传成功！";
        }else {
            msg = "上传失败！";

        }
        if(msg=="上传成功！"){
            System.out.println("upload方法内"+localPath+"/"+file.getOriginalFilename());
        }
        // 显示图片
        map.put("msg", msg);
        map.put("fileName", file.getOriginalFilename());

        return "forward:/test";
    }

    /**
     * 显示单张图片
     * @return
     */
    @RequestMapping("show")
    public ResponseEntity showPhotos(String fileName){

        try {
            // 由于是读取本机的文件，file是一定要加上的， dirPath是D:\IdeaProjects\FileUploadDemo-master\target
            System.out.println("show方法内"+path+"/"+fileName);
            returnpath = resourceLoader.getResource("file:" + path +"/"+ fileName);
            System.out.println(returnpath);
            return ResponseEntity.ok(resourceLoader.getResource("file:" + path +"/"+ fileName));

        } catch (Exception e) {
            return ResponseEntity.notFound().build();
        }

    }
    @Autowired
    private ServletContext servletContext;



    //实验成功，可以正常使用MatlabUtils类的各个方法。
    @ResponseBody
    @RequestMapping("testMatlab")
    public double test() throws MatlabInvocationException, IOException {

        double[] abn = {1,2,3};
        String rawImage="D:\\IdealProject\\ImageUp-ipfs-eth\\src\\main\\resources\\static\\matlabDWT\\lena512.bmp";
        String watermarkImage="D:\\IdealProject\\ImageUp-ipfs-eth\\src\\main\\resources\\static\\matlabDWT\\waterm16.jpg";
        String zeroPathName="D:\\IdealProject\\ImageUp-ipfs-eth\\src\\main\\resources\\static\\zeroImage\\zeroWatermark01.jpg";


        MatlabUtils.matlabUtils.generate(rawImage,watermarkImage,zeroPathName,abn);

        return MatlabUtils.matlabUtils.verify(rawImage,watermarkImage,zeroPathName,abn);
    }






}



