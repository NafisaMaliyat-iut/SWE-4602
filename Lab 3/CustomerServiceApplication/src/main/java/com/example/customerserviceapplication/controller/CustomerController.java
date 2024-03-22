package com.example.customerserviceapplication.controller;


import com.example.customerserviceapplication.entity.Customer;
import com.example.customerserviceapplication.service.CustomerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/customers")
public class CustomerController {
    @Autowired
    private CustomerService customerService;
    @PostMapping("/")
    public Customer saveProduct(@RequestBody Customer customer){
        return customerService.saveCustomer(customer);
    }
    @GetMapping("/{id}")
    public Customer findProductById(@PathVariable("id") String customerId){
        return customerService.findCustomerById(customerId);
    }
}