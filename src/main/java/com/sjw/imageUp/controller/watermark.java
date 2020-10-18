package com.sjw.imageUp.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.core.io.ResourceLoader;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.io.File;

@Controller
public class watermark {
    private ResourceLoader resourceLoader;

    TestController image;

    @Value("${web.upload-path}")
    public String path;



    private Resource returnpath;
    @Autowired
    public watermark(ResourceLoader resourceLoader) {
        this.resourceLoader = resourceLoader;
    }

    @RequestMapping("process")
    public String process(@RequestParam("fileName") String fileName){
        System.out.println("process方法接收到的fileName"+fileName);
        File file = new File(path+"/"+fileName);
        String realPath = path + "/processed/proc"+fileName;

        if(file.exists()) {
            File newfile=new File(file.getParent()+"/processed/proc"+fileName);//创建新名字的抽象文件
            if(file.renameTo(newfile)) {
                System.out.println("重命名成功！");

            }
            else {
                System.out.println("重命名失败！新文件名已存在");

            }
        }
        else {
            System.out.println("重命名文件不存在！");

        }

        System.out.println("process方法在执行");
        return "fileUpload";


    }

    @RequestMapping("showWater")
    public ResponseEntity showPhotos(String fileName){

        try {
            // 由于是读取本机的文件，file是一定要加上的， path是在application配置文件中的路径
            System.out.println("showWater方法内"+path+"/processed/proc"+fileName);

            return ResponseEntity.ok(resourceLoader.getResource("file:" + path +"/processed/proc"+ fileName));

        } catch (Exception e) {
            return ResponseEntity.notFound().build();
        }

    }

}
