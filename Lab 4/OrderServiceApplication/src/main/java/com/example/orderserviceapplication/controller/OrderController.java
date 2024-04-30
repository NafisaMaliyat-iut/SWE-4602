package com.example.orderserviceapplication.controller;

import com.example.orderserviceapplication.Constants;
import com.example.orderserviceapplication.entity.Order;
import com.example.orderserviceapplication.entity.OrderStatus;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.lang.reflect.Array;
import java.util.Random;
import java.util.UUID;

@RestController
@RequestMapping("/order")
public class OrderController {
    @Autowired
    private RabbitTemplate rabbitTemplate;


    @PostMapping("/{restaurantName}")
    public String bookOrder(@RequestBody Order order, @PathVariable String restaurantName ) {
        order.setOrderId(UUID.randomUUID().toString());
        order.setProductId("1");
        System.out.println(order);
        OrderStatus orderStatus = new OrderStatus(order, "PROCESS", "Order Successfully Placed to "+ restaurantName);
        System.out.println(orderStatus);
        rabbitTemplate.convertAndSend(Constants.EXCHANGE,Constants.ROUTING_KEY, orderStatus);
        return "success!!";
    }
}
