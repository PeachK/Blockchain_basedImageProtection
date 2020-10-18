package com.sjw.imageUp.util;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;

import java.text.SimpleDateFormat;

public class Json_ajaxUtils {
    public static String getJSON(Object object) throws JsonProcessingException {
        return new ObjectMapper().writeValueAsString(object);
    }

    public static String getJsonTime(Object object){
        return getJsonTime(object,"yyyy-MM-dd HH:mm:ss");
    }

    public static String getJsonTime(Object object,String dateFormat){
        ObjectMapper mapper=new ObjectMapper();
        mapper.configure(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS,false);
        SimpleDateFormat sdf=new SimpleDateFormat(dateFormat);                          mapper.setDateFormat(sdf);

        try{
            return mapper.writeValueAsString(object);
        }catch(JsonProcessingException e){
            e.printStackTrace();
        }
        return null;
    }
}
