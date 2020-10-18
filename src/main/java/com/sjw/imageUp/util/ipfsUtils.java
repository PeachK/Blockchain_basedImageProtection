package com.sjw.imageUp.util;

import io.ipfs.api.IPFS;
import io.ipfs.api.IpldNode;
import io.ipfs.api.MerkleNode;
import io.ipfs.api.NamedStreamable;
import io.ipfs.multihash.Multihash;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;

public class ipfsUtils {

    static IPFS ipfs = new IPFS("/ip4/127.0.0.1/tcp/5001");//ipfs的服务器地址和端口
   
    //static IPFS ipfs = new IPFS("https://ipfs.infura.io:5001");


    public static String upload(String filePathName) throws IOException {
        //filePathName指的是文件的上传路径+文件名，如D:/1.png  
        File image=new File(filePathName);
        NamedStreamable.FileWrapper file = new NamedStreamable.FileWrapper(image);
        MerkleNode addResult = ipfs.add(file).get(0);
        image.delete();
        return addResult.hash.toString();
    }

    //String filePathName,
    //
    public static File download(String filePath,String hash) throws IOException {

        Multihash filePointer = Multihash.fromBase58(hash);
        byte[] data = ipfs.cat(filePointer);
        System.out.println("data:"+data);
        if(data != null) {
            String filePathName = filePath + "/ipfsDownload/" + UUIDUtils.getUUID() + ".png";
            System.out.println("filePathName:"+filePathName);
            File file = new File(filePathName);
            if (file.exists()) {
                file.delete();
            }
            FileOutputStream fos = new FileOutputStream(file);
            fos.write(data, 0, data.length);
            fos.flush();
            fos.close();
            return file;
        }else{
            return null;
        }

    }

}
