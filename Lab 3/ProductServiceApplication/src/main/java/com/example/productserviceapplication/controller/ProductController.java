package com.example.productserviceapplication.controller;

import com.example.productserviceapplication.entity.Product;
import com.example.productserviceapplication.service.ProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/products")
public class ProductController {
    @Autowired
    private ProductService productService;
    @PostMapping("/")
    public Product saveProduct(@RequestBody Product product){
        return productService.saveProduct(product);
    }
    @GetMapping("/{id}")
    public Product findProductById(@PathVariable("id") String productId){
        return productService.findProductById(productId);
    }
}