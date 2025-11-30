# Ad-hoc-Consumer-Goods-Insights – SQL Data Analysis Project

### 📌 Overview

This project explores real-world *business questions* for **AtliQ Hardwares**, a leading fictional hardware manufacturer operating across multiple countries.
As a **Data Analyst**, the goal was to extract insights from the company's database using **SQL**, followed by visualization in **Power BI**, and presentation of findings.

---

### 🏢 Business Context & Problem Statement

AtliQ Hardwares wants to improve decision-making with accurate data insights across product performance, sales patterns, pricing, and customer growth.

The company provided a **relational database** (`gdb023 | atliq_hardware_db`) containing:

| Table                           | Description                          |
| ------------------------------- | ------------------------------------ |
| **dim_customer**                | Customer master information          |
| **dim_product**                 | Product master information           |
| **fact_sales_monthly**          | Monthly sales & units sold           |
| **fact_gross_price**            | Gross selling price for each product |
| **fact_manufacturing_cost**     | Cost incurred in manufacturing       |
| **fact_pre_invoice_deductions** | Adjustments applied before invoice   |

Using this data, multiple ad-hoc requests were solved using **SQL queries** to support data-driven decision-making.

---

### 📂 Project Structure

```
📁 Ad-Hoc-Consumer-Goods-Insights
│── 📄 README.md
│── 📄 ad-hoc-requests.sql        → SQL answers for all requests
│── 📊 AtliQ_SQL_Insights.pptx    → Presentation summarizing findings
```

---

### 🔍 Key Insights Delivered

✔ Top revenue-generating channels and their contribution share
✔ Quarter-wise trend comparison of gross sales & volumes
✔ Most profitable product segments 
✔ Forecast-ready metrics for pricing & cost optimization
✔ Country-wise customer distribution & sales influence

These insights can be useful for **marketing strategy, sales planning, pricing decisions, and global expansion tracking**.

---

### 🛠 Tech Stack

| Tool                      | Purpose                            |
| ------------------------- | ---------------------------------- |
| **MySQL / SQL Workbench** | Data querying & analysis           |
| **Power BI**              | Dashboard creation & visualization |
| **Microsoft PowerPoint**  | Project summary presentation       |
| **GitHub**                | Version control & documentation    |

---

### 📜 Files Included

| File                      | Description                                       |
| ------------------------- | ------------------------------------------------- |
| `ad-hoc-requests.sql`     | Complete SQL solutions for all business questions |
| `PowerBI_Dashboard.pbix`  | Visual insights dashboard                         |
| `AtliQ_SQL_Insights.pptx` | Final presentation for stakeholders               |
| `README.md`               | Documentation for repository                      |

---

### 📌 How to Run This Project

1. Clone the repository:

   ```bash
   git clone https://github.com/<harinagasree>/Ad-Hoc-Consumer-Goods-Insights.git
   ```
2. Import the database into MySQL / Workbench
3. Run the SQL script `ad-hoc-requests.sql`
4. Open `PowerBI_Dashboard.pbix` to explore visual insights
5. View the presentation for insight explanation

---

### ⭐ Conclusion

With SQL-driven business insights and visualization dashboards, this project demonstrates strong problem-solving and analytical capability in real-world business scenarios.

---
