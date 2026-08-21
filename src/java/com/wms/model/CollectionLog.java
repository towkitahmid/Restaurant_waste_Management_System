package com.wms.model;
import java.sql.Date;

public class CollectionLog {
    private int logId;
    private int restaurantId;
    private Date collectionDate;
    private String wasteType;
    private double wasteWeight;
    private int truckId;
    private int zoneId; // NEW FIELD

    public CollectionLog() {}
    
    // Updated Constructor
    public CollectionLog(int restaurantId, Date collectionDate, String wasteType, double wasteWeight, int truckId, int zoneId) {
        this.restaurantId = restaurantId;
        this.collectionDate = collectionDate;
        this.wasteType = wasteType;
        this.wasteWeight = wasteWeight;
        this.truckId = truckId;
        this.zoneId = zoneId;
    }

    // Getters and Setters
    public int getLogId() { return logId; }
    public void setLogId(int logId) { this.logId = logId; }
    
    public int getRestaurantId() { return restaurantId; }
    public void setRestaurantId(int restaurantId) { this.restaurantId = restaurantId; }
    
    public Date getCollectionDate() { return collectionDate; }
    public void setCollectionDate(Date collectionDate) { this.collectionDate = collectionDate; }
    
    public String getWasteType() { return wasteType; }
    public void setWasteType(String wasteType) { this.wasteType = wasteType; }
    
    public double getWasteWeight() { return wasteWeight; }
    public void setWasteWeight(double wasteWeight) { this.wasteWeight = wasteWeight; }
    
    public int getTruckId() { return truckId; }
    public void setTruckId(int truckId) { this.truckId = truckId; }

    // New Getter/Setter for Zone
    public int getZoneId() { return zoneId; }
    public void setZoneId(int zoneId) { this.zoneId = zoneId; }
}