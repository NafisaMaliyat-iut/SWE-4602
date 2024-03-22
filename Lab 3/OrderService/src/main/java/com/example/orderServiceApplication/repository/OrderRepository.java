package com.example.orderServiceApplication.repository;

import com.example.orderServiceApplication.entity.Order;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface OrderRepository extends MongoRepository<Order, String> {
    Order findOrderById(String orderId);
}