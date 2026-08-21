package com.wms.model;

public class Truck {
    private int truckId;
    private String type;
    private String driverInfo; // Used to hold Driver ID/Name for display

    public Truck() {}
    public Truck(int truckId, String type, String driverInfo) {
        this.truckId = truckId;
        this.type = type;
        this.driverInfo = driverInfo;
    }

    // --- Getters and Setters ---
    
    public int getTruckId() { return truckId; }
    public void setTruckId(int truckId) { this.truckId = truckId; }
    
    public String getType() { return type; }
    public void setType(String type) { this.type = type; }
    
    // FIX: This method was missing, causing the 500 error
    public String getDriverInfo() { return driverInfo; }
    public void setDriverInfo(String driverInfo) { this.driverInfo = driverInfo; }
}