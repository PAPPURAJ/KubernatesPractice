package com.pappuraj.kubernatespractice;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.http.ResponseEntity;


@RestController
public class Controller {

    @Value("${me.message}")
    private String message = "Init";
    @GetMapping
    public String getString(){
        return "Hello World from Spring Boot from "+message+"!";
    }

    @GetMapping("/health")
    public ResponseEntity<String> healthCheck() {
        return ResponseEntity.ok("UP");
    }
}
