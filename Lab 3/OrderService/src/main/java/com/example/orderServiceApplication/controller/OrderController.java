package com.example.orderServiceApplication.controller;

import com.example.orderServiceApplication.entity.Order;
import com.example.orderServiceApplication.service.OrderService;
import com.example.orderServiceApplication.valueObject.ResponseValueObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/orders")
public class OrderController {
    @Autowired
    private OrderService orderService;
    @PostMapping("/")
    public Order saveOrder(@RequestBody Order order){
        return orderService.saveOrder(order);
    }
    @GetMapping("/{id}")
    @ResponseBody
    public ResponseValueObject findOrderById(@PathVariable("id") String orderId){
        return orderService.getOrder(orderId);
    }
}
