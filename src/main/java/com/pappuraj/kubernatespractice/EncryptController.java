package com.pappuraj.kubernatespractice;

import org.jasypt.encryption.StringEncryptor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/encrypt")
public class EncryptController {

    @Autowired
    private StringEncryptor encryptor;

    // Example: GET /encrypt/your_text_here
    @GetMapping("/{text}")
    public String encryptText(@PathVariable String text) {
        String encrypted = encryptor.encrypt(text);
        return "ENC(" + encrypted + ")";
    }
}
