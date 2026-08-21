package com.wms.model;

public class Vendor {
    private int vendorId;
    private String name;
    private String category;
    private String licenseNo;

    public Vendor() {}
    public Vendor(String name, String category, String licenseNo) {
        this.name = name;
        this.category = category;
        this.licenseNo = licenseNo;
    }

    public int getVendorId() { return vendorId; }
    public void setVendorId(int vendorId) { this.vendorId = vendorId; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }
    public String getLicenseNo() { return licenseNo; }
    public void setLicenseNo(String licenseNo) { this.licenseNo = licenseNo; }
}