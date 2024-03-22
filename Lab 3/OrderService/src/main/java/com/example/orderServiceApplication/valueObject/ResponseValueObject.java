package com.example.orderServiceApplication.valueObject;

import com.example.orderServiceApplication.entity.Order;
import lombok.Getter;

@Getter
public class ResponseValueObject{
    private Customer customer;
    private Product product;
    private Employee employee;
    private Order order;

    public void setCustomer(Customer customer) {
        this.customer=customer;
    }

    public void setProduct(Product product) {
        this.product=product;
    }

    public void setEmployee(Employee employee) {
        this.employee=employee;
    }

    public void setOrder(Order order) {
        this.order=order;
    }


}
