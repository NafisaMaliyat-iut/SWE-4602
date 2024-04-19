package com.example.inventoryserviceapplication.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Objects;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Product {
    private String id;
    private String name;
    private int qty;

    public String isAvailable(String id){
        if(this.id.equals(id) && this.qty>0){
            return "Product available";
        }
         else {
             return "Product not available";
        }
    }
}
