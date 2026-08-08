Restaurant Waste Management System (WMS)

A comprehensive, end-to-end Java Enterprise web application designed to track, manage, and optimize the lifecycle of restaurant waste. This system models real-world supply chain logistics, following waste from its generation at restaurants to its final transformation into recycled products.

Overview

The Restaurant Waste Management System bridges the gap between waste generators (restaurants) and recycling facilities. It provides dedicated portals for Restaurant Owners to report their daily waste and an Admin Panel for logistics managers to coordinate trucks, monitor dumping zone capacities, assign vendors for segregation, and track factory production.

Key Features

For Restaurant Owners
- Secure Portal: Individual login and registration system.
- Waste Reporting: Owners can log their daily generated waste in kilograms.
- Progress Dashboard: Shows total produced, collected, and remaining waste.
- Analytics: Charts showing waste composition.

For System Administrators
- Global Dashboard: Overview of system metrics, collections, trucks, and charts.
- Collection Logistics: Assign trucks to collect waste and send to dumping zones.
- Zone Management: Monitor dumping zone capacity and load.
- Segregation & Vendors: Assign vendors for waste types.
- Factory & Production: Track recycled products.
- User Management: Manage employees and drivers.

Technology Stack

Frontend: HTML5, Tailwind CSS, Google Charts, JSP  
Backend: Java EE (Servlets), JDBC  
Database: MySQL  
Server: Apache Tomcat  
Architecture: MVC (Model-View-Controller)

Database Lifecycle Flow

1. Restaurant generates waste  
2. Collection_Log moves waste via Truck to Dumping_Zone  
3. Segregation_Log moves waste to Vendor  
4. Product table stores recycled output from Factory  

Installation & Setup Guide

Prerequisites
- JDK 8 or higher  
- Apache Tomcat  
- MySQL  
- IDE (NetBeans / Eclipse / IntelliJ)

Step 1: Database Setup
Open MySQL and run:
source wms_db_full_backup.sql