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
## 🚀 How to Run  

Run these commands in **bash/command line** (not inside SQL Shell):  

```bash
psql -U postgres -h localhost
CREATE DATABASE ecommerce
\c ecommerce 
\i run_all.sql

---








