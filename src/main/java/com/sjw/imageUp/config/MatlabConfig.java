package com.sjw.imageUp.config;

import com.sjw.imageUp.listener.MatlabListener;
import org.springframework.boot.web.servlet.ServletListenerRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.EventListener;

@Configuration
public class MatlabConfig {
    @Bean
    public ServletListenerRegistrationBean myListener(){
        ServletListenerRegistrationBean<EventListener> servletListenerRegistrationBean = new ServletListenerRegistrationBean<>();
        servletListenerRegistrationBean.setListener(new MatlabListener());
        return servletListenerRegistrationBean;
    }

}
