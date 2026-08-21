package com.wms.model;

public class DumpingZone {
    private int zoneId;
    private String type;
    private double capacity;
    private String area;

    public DumpingZone() {}
    public DumpingZone(String type, double capacity, String area) {
        this.type = type;
        this.capacity = capacity;
        this.area = area;
    }

    public int getZoneId() { return zoneId; }
    public void setZoneId(int zoneId) { this.zoneId = zoneId; }
    public String getType() { return type; }
    public void setType(String type) { this.type = type; }
    public double getCapacity() { return capacity; }
    public void setCapacity(double capacity) { this.capacity = capacity; }
    public String getArea() { return area; }
    public void setArea(String area) { this.area = area; }
}