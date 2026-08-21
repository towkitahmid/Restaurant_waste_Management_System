package com.wms.model;

public class Employee {
    private int empId;
    private String firstName;
    private String lastName;
    private String role;
    private String gender;
    private double salary;
    private int managerId;

    public Employee() {}
    public Employee(String firstName, String lastName, String role, String gender, double salary, int managerId) {
        this.firstName = firstName;
        this.lastName = lastName;
        this.role = role;
        this.gender = gender;
        this.salary = salary;
        this.managerId = managerId;
    }

    // Getters and Setters (omitted for brevity, but required in IDE)
    public int getEmpId() { return empId; }
    public void setEmpId(int empId) { this.empId = empId; }
    public String getFirstName() { return firstName; }
    public void setFirstName(String firstName) { this.firstName = firstName; }
    public String getLastName() { return lastName; }
    public void setLastName(String lastName) { this.lastName = lastName; }
    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }
    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }
    public double getSalary() { return salary; }
    public void setSalary(double salary) { this.salary = salary; }
    public int getManagerId() { return managerId; }
    public void setManagerId(int managerId) { this.managerId = managerId; }
}