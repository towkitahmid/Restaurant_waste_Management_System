package com.wms.model;

public class Factory {
    private int factoryId;
    private String name;
    private String type;
    private double productionCapacity;

    public Factory() {}
    public Factory(String name, String type, double productionCapacity) {
        this.name = name;
        this.type = type;
        this.productionCapacity = productionCapacity;
    }

    public int getFactoryId() { return factoryId; }
    public void setFactoryId(int factoryId) { this.factoryId = factoryId; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getType() { return type; }
    public void setType(String type) { this.type = type; }
    public double getProductionCapacity() { return productionCapacity; }
    public void setProductionCapacity(double productionCapacity) { this.productionCapacity = productionCapacity; }
}