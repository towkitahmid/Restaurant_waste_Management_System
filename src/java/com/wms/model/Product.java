package com.wms.model;

public class Product {
    private int productId;
    private int factoryId;
    private String name;
    private String type;
    private int quantity;
    private double price;

    public Product() {}
    public Product(int factoryId, String name, String type, int quantity, double price) {
        this.factoryId = factoryId;
        this.name = name;
        this.type = type;
        this.quantity = quantity;
        this.price = price;
    }

    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }
    public int getFactoryId() { return factoryId; }
    public void setFactoryId(int factoryId) { this.factoryId = factoryId; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getType() { return type; }
    public void setType(String type) { this.type = type; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }
}