package com.example.orderServiceApplication.service;


import com.example.orderServiceApplication.entity.Order;
import com.example.orderServiceApplication.repository.OrderRepository;
import com.example.orderServiceApplication.valueObject.Customer;
import com.example.orderServiceApplication.valueObject.Employee;
import com.example.orderServiceApplication.valueObject.Product;
import com.example.orderServiceApplication.valueObject.ResponseValueObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.Date;

@Service
public class OrderService {
    @Autowired
    private OrderRepository orderRepository;
    @Autowired
    private RestTemplate restTemplate;
    public Order saveOrder(Order order) {
        order.setDate(new Date());
        return orderRepository.save(order);
    }
//    public Order findOrderById(String orderId) {
//        return orderRepository.findOrderById(orderId);
//    }

    public ResponseValueObject getOrder(String orderId) {
        ResponseValueObject responseValueObject = new ResponseValueObject();
        Order order = orderRepository.findOrderById(orderId);
        Product product = restTemplate.getForObject("http://PRODUCT-SERVICE/products/" + order.getProductId(), Product.class);
        Customer customer = restTemplate.getForObject("http://CUSTOMER-SERVICE/customers/" + order.getCustomerId(), Customer.class);
        Employee employee = restTemplate.getForObject("http://Employee-SERVICE/employees/" + order.getEmployeeId(), Employee.class);
        responseValueObject.setCustomer(customer);
        responseValueObject.setProduct(product);
        responseValueObject.setEmployee(employee);
        responseValueObject.setOrder(order);
        return responseValueObject;
    }
}