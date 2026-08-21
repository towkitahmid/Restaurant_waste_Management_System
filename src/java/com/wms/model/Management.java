package com.wms.model;

public class Management {
    private int managerId;
    private String name;

    public Management(int managerId, String name) {
        this.managerId = managerId;
        this.name = name;
    }

    public int getManagerId() { return managerId; }
    public void setManagerId(int managerId) { this.managerId = managerId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
}