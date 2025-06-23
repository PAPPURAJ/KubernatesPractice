package com.pappuraj.kubernatespractice;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

@Component
public class ConfigCheck implements CommandLineRunner {

    @Value("${app.message:NOT FOUND}")
    private String message;

    @Override
    public void run(String... args) {
        System.out.println("app.message from external config: " + message);
    }
}
