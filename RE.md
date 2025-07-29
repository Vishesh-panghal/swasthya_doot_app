![Power BI](https://img.shields.io/badge/Tool-PowerBI-yellow)
![License](https://img.shields.io/badge/License-MIT-green)
![Status](https://img.shields.io/badge/Status-Completed-brightgreen)

# 🏅 Olympic Intelligence Dashboard – 120 Years of Sports Analytics with Power BI

> **Project Type:** Personal BI Portfolio | Dataset: Kaggle Olympic History (1896–2016)  
> **Role:** BI Developer & Data Modeler | Tools: Power BI, DAX, Power Query, Excel

---

## 📌 Project Overview

This project visualizes **120 years of Olympic Games history**, spanning **200+ nations**, **35,000+ athletes**, and **40+ sports**, using an interactive Power BI dashboard. The goal was to analyze medal distribution, gender representation, and event participation trends over time using two primary datasets:

> 📂 [View Dataset on Kaggle](https://www.kaggle.com/datasets/heesoo37/120-years-of-olympic-history-athletes-and-results)

- `olympics_auth.csv` – Athlete-level event and medal records  
- `olympics_regions.csv` – NOC-to-country mapping data  

By integrating these datasets through a clean, scalable data model, the dashboard provides insights into global sports performance, gender disparity, and historical Olympic dynamics from **1896 to 2016**.

---

## 🧹 Data Cleaning & Preprocessing

> 🔄 Structured the dataset into a relational model to support multidimensional analysis.

- Cleaned and normalized athlete and region data for modeling.
- Resolved **incomplete NOC mappings** by joining region data with fallback logic.
- Filtered **non-medal entries** to focus performance metrics on medal-winning participants.
- Performed **data typing, transformation, and column reduction** using Power Query.
- Linked datasets via **country codes (NOC)** to form a star schema with 2 base tables.

---

## 🛠️ Data Analysis & Metric Modeling

- Created **20+ DAX measures** for:
  - Medal totals (Gold, Silver, Bronze)
  - Gender-based medal splits
  - Top 10 athletes by medal count
  - Sport-level participation analysis
  - Time-series medal trends per nation
- Applied **time intelligence functions** for decade-wise performance tracking.
- Used **rank functions** and filters to create dynamic top-N lists by sport or country.

---

## 📈 Interactive Power BI Dashboard

> 🧠 Built a clean, one-page analytics experience for slicing Olympic performance data.

- 9+ visuals including trend lines, stacked bars, KPIs, pie charts, and slicers.
- Interactivity through **filters by year, nation, and sport**.
- KPIs summarizing **total medals**, **event frequency**, and **gender breakdowns**.
- Drill-through capability to explore **top athletes**, **sport-wise history**, and **nation-based performance**.

---

## 🧮 Tech Stack

| Tool          | Role                                |
|---------------|-------------------------------------|
| **Power BI**      | Interactive visualizations & storytelling |
| **Power Query**   | ETL, data shaping & schema modeling |
| **DAX**           | Measure creation & analytical logic |
| **Excel**         | Initial dataset exploration & QA |

---

## 📂 Project Files

- `OlympicDashboard.pbix` – Interactive Power BI dashboard  
- `olympics_auth.csv` – Raw athlete event and medal data  
- `olympics_regions.csv` – Nation code to region mappings  
- `dashboard_screenshot.png` – Project preview (optional)  

---

## 🧭 Key Insights & Highlights

- **India has won 173 medals in Hockey**, its most successful Olympic sport.
- **Men’s events have significantly outnumbered women’s**, but the gap has narrowed post-2000.
- **Top medal-winning athletes** often participate in swimming and gymnastics.
- The **Cold War period** shows medal spikes from USSR and USA.
- Olympic events were paused during **WWI and WWII**, visible in medal trends.

---

## 💡 Takeaways

- Built a maintainable BI model using **best practices in semantic layer design**.
- Learned to optimize dashboard performance through **query folding** and **filter logic**.
- Strengthened DAX proficiency through **custom ranking, filters, and time functions**.
- Reinforced how **storytelling with data** can reveal cultural, political, and performance shifts over time.

---

## 📜 License

This project is licensed under the MIT License. You are free to use, modify, and distribute this project with proper attribution.