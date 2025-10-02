# 🛒 E-Commerce Database Project  

## 📌 Overview  
This project is a **PostgreSQL database** designed for an e-commerce system.  
It includes **database design, schema creation, indexing, optimization, functions, procedures, triggers, and sample queries** that simulate real-world use cases.  

---

## 🔧 Prerequisites  
- Install [PostgreSQL](https://www.postgresql.org/download/) (v14 or higher recommended).  
- Ensure `psql` command line tool is working.  

---

## 📦 Requirements  
- PostgreSQL server running locally (default port 5432).  
- Database user: `postgres` (or update commands if using another user).  

---

## ✨ Features  

- 🏗️ Full database schema (tables, constraints, relationships).  
- 📊 Sample queries for analytics and reporting.  
- ⚡ Indexing & query optimization.  
- 🔄 Stored functions & procedures for advanced logic.  
- 🔔 Triggers for automatic updates and validations.  
- 🐍 Python script to auto-generate random test data.  

---

## 🚀 How to Run  

Run these commands in **bash/command line** 

```bash
psql -U postgres -h localhost
CREATE DATABASE ecommerce
\c ecommerce 
\i run_all.sql
```
---

## 🐍 Data Generation

This project includes a Python script (data_generation_script.ipnyb) that automatically generates random data for testing.
It helps you quickly populate the database with customers, products, orders, and payments.

---

## 📊 Schema & ERD

You can find diagrams in the repository:

## 📊 Schema & ERD  

### Database Schema  
![Database Schema](Schema&ERD/Database_Schema.png)  

### Entity Relationship Diagram  
![ERD](Schema&ERD/ERD.png)  
---

## 🤝 Contributing

Feel free to fork this repo, open issues, or submit pull requests with improvements.

---





