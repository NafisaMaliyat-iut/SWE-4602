package com.example.inventoryserviceapplication.controller;

import com.example.inventoryserviceapplication.Constants;
import com.example.inventoryserviceapplication.entity.OrderStatus;
import com.example.inventoryserviceapplication.entity.Product;
import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.stereotype.Component;

@Component
public class InventoryController {
    private final Product product = new Product("1","product",3);
    @RabbitListener(queues = Constants.QUEUE )
    public void consumeMessageFromQueue(OrderStatus orderStatus) {
        System.out.println("Message Received from queue: " +orderStatus );
        String productId = orderStatus.getOrder().getProductId();
        System.out.println(product.isAvailable(productId));
    }
}
