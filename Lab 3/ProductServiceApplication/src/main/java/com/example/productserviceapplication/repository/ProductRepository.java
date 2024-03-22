package com.example.productserviceapplication.repository;

import com.example.productserviceapplication.entity.Product;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ProductRepository extends MongoRepository<Product, String> {
    Product findProductById(String productId);
}
