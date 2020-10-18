package com.sjw.imageUp.util;

import matlabcontrol.MatlabInvocationException;
import matlabcontrol.MatlabProxy;
import matlabcontrol.extensions.MatlabNumericArray;
import matlabcontrol.extensions.MatlabTypeConverter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;
import javax.servlet.ServletContext;
import java.io.*;
import java.util.Arrays;
@Component
public class MatlabUtils {
    @Autowired
    private ServletContext servletContext;

    public static MatlabUtils matlabUtils;



    @PostConstruct
    public void init() {
        matlabUtils = this;

    }



//    generate方法中的零水印地址是要存入的绝对路径和文件名
//    路径为resource文件夹下的zeroImage文件夹
//    文件名使用uuid生成,和特征图文件名保持关联


    public void generate(String rawPathName,String watermarkPathName,String zeroPathName,double[] abn) throws MatlabInvocationException {

        //只有controller类内才能创建代理,或是使用Component注解
            MatlabProxy proxy = (MatlabProxy) matlabUtils.servletContext.getAttribute("proxy");
            Object raw = rawPathName;
            Object water = watermarkPathName;
            Object zero = zeroPathName;

    //          function generate(rawImage,watermarkImage,a,b,n,zeroPathName)
            proxy.returningFeval("generate", 0, raw, water, (Object)abn[0], (Object)abn[1], (Object)abn[2], zero);




    }
//    function result=verify(rawImage,watermarkImage,zeroWatermark,a,b,n)
    public double verify(String rawPathName,String watermarkPathName,String zeroPathName,double[] abn) throws MatlabInvocationException, IOException {
            MatlabProxy proxy = (MatlabProxy) matlabUtils.servletContext.getAttribute("proxy");
            Object raw = rawPathName;
            Object water = watermarkPathName;
            Object zero = zeroPathName;

            Object[] re = proxy.returningFeval("verify", 1,raw,water,zero,abn[0],abn[1],abn[2]);
//            String file = "D:\\IdealProject\\MatlabTest\\matlabDWT\\result.dat";
//            bre = new BufferedReader(new FileReader(file));//此时获取到的bre就是整个文件百的缓存流
//
//            while ((str = bre.readLine())!= null) {
//                result=Double.parseDouble(str);
//
//            }
              System.out.println("re[0].length:"+((double[])re[0]).length);
              System.out.println("double[0]:"+((double[])re[0])[0]);
            return ((double[])re[0])[0];
    }
}

