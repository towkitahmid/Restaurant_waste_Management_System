package com.wms.model;

public class Restaurant {
    private int restaurantId;
    private String name;
    private String location;
    private String contactNo;
    private double dailyWasteQuantity;

    public Restaurant() {}
    public Restaurant(String name, String location, String contactNo, double dailyWasteQuantity) {
        this.name = name;
        this.location = location;
        this.contactNo = contactNo;
        this.dailyWasteQuantity = dailyWasteQuantity;
    }

    // Getters and Setters (omitted for brevity, but required in IDE)
    public int getRestaurantId() { return restaurantId; }
    public void setRestaurantId(int restaurantId) { this.restaurantId = restaurantId; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }
    public String getContactNo() { return contactNo; }
    public void setContactNo(String contactNo) { this.contactNo = contactNo; }
    public double getDailyWasteQuantity() { return dailyWasteQuantity; }
    public void setDailyWasteQuantity(double dailyWasteQuantity) { this.dailyWasteQuantity = dailyWasteQuantity; }
}