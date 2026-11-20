# 🏥 Hospital Emergency Room Analysis

---

## 📌 Project Overview

This project presents a comprehensive analysis of **9,216 Emergency Room visits** across 2023 and 2024, utilizing **SQL Server** for data processing and metric calculation and **Microsoft Excel** for dashboarding and reporting. It evaluates patient demographics, admission proportions, departmental referrals, day-and-time arrival patterns, waiting times, and patient satisfaction scores to support data-driven resource allocation and operational improvement.

---

## 🎯 Business Problem

The hospital's Emergency Room handles patients with varying medical needs throughout the day. However, understanding patient arrival patterns, admission trends, departmental demand, and waiting time is essential for maintaining efficient emergency services.

Hospital management requires a data-driven approach to evaluate patient flow, identify peak hours and high-demand departments, monitor admission patterns, and assess patient satisfaction.

The objective of this project is to analyze Emergency Room operations by examining patient flow, admission trends, departmental demand, waiting times, and patient satisfaction. The findings will help hospital management identify inefficiencies, optimize resource allocation, and improve overall service quality and operational efficiency.

---

## ❓ Key Business Questions

1. What is the Overall ER performance?
2. What is the Gender-wise distribution of patients?
3. Which Departments receive the highest number of patient referrals?
4. Which Age groups account for the highest number of patient visits?
5. What is the proportion of Admitted and non-admitted patients?
6. What percentage of patients are attended to within 30 minutes versus those experiencing delays?
7. Which days of the week experience the highest patient visits?
8. During which hours does the Emergency Room experience the highest patient inflow?
9. How are patient volumes distributed across different days and time combination?

---

## 📂 Dataset Overview

The dataset used in this project contains patient-level information related to Emergency Room (ER) visits. It covers the following key aspects:

- **Patient Demographics:** Information related to patient age, gender, and race.
- **Admission Details:** Records of patient visits and hospital admission status.
- **Departmental Referrals:** Information about departments handling referred patients.
- **Waiting Time:** Time taken for patients to receive their initial medical attention.
- **Patient Satisfaction:** Feedback reflecting patients' experience with emergency services.

---

## ⚙️ Project Workflow

### 🗄️ SQL Project Workflow

- **Database & Table Creation:** Create database and tables in SQL Server.
- **Data Import:** Import data from a CSV file into SQL Server.
- **Data Transformation:** Create derived columns and analytical fields.
- **KPI Calculation:** Calculate key ER performance metrics.
- **Business Analysis:** Analyze patient demographics, admissions, referrals, waiting times, and arrival patterns.
- **Trend Analysis:** Analyze patient data across yearly and monthly periods.

### 📊 Excel Project Workflow

1. **Power Query:** Transformed data & Created a Calendar Table.
2. **Data Modeling (Power Pivot):** Created calculated columns using DAX.
3. **Pivot Tables & Charts:** Create Pivot Tables to summarize and analyze patient data, and use Pivot Charts to visualize key findings and operational trends.
4. **Dashboard Development & Filters:** Develop an interactive Excel dashboard to present key performance indicators (KPIs), combine Pivot Charts and visual elements to communicate important insights and incorporate interactive Slicers for dynamic data filtering.

---

## 📈 Dashboard Overview

---

## 🛠️ Tools & Technologies Used

- SQL Server
- Microsoft Excel
- Power Query
- Power Pivot
- DAX
- Pivot Tables & Pivot Charts
- Excel Dashboard & Slicers

---

## 🔍 Key Findings & Business Insights

**Analysis Period:** 2023–2024

### 1. 📊 Overall ER Performance

| Performance Metrics | 2023 | 2024 |
|---|---:|---:|
| Total Patients | 4,464 | 4,752 |
| Average Waiting Time | 35.33 min | 35.19 min |
| Average Satisfaction Score | 5.56 | 5.48 |

**Key Findings**

- The Emergency Room recorded **4,752 patient visits in 2024**, compared to 4,464 in 2023, reflecting a **6.45% increase** in patient volume.
- Average waiting time remained relatively stable at approximately 35 minutes across both years.
- Average patient satisfaction declined slightly from 5.56 in 2023 to 5.48 in 2024.

---

### 2. 👥 Patient Demographics & Distribution

#### 2.1 Gender-wise Distribution of Patients

| Gender | 2023 Patients | 2023 % | 2024 Patients | 2024 % |
|---|---:|---:|---:|---:|
| Female | 2,159 | 48% | 2,328 | 49% |
| Male | 2,305 | 52% | 2,424 | 51% |

#### 2.2 Age Group Distribution

| Age Group | 2023 Patients | 2024 Patients |
|---|---:|---:|
| 0–09 | 590 | 586 |
| 10–19 | 552 | 608 |
| 20–29 | 592 | 615 |
| 30–39 | 549 | 642 |
| 40–49 | 548 | 589 |
| 50–59 | 550 | 597 |
| 60–69 | 577 | 573 |
| 70–79 | 506 | 542 |

**Key Findings**

- Male patients accounted for a slightly higher proportion of ER visits in both years, representing 52% in 2023 and 51% in 2024.
- The highest patient volume shifted from the 20–29 age group in 2023 (592 patients) to the 30–39 age group in 2024 (642 patients).

---

### 3. 🏥 Departmental Demand & Referral Patterns

| Department | 2023 Patients | 2024 Patients |
|---|---:|---:|
| General Practice | 784 | 994 |
| Orthopedics | 779 | 748 |
| None(No Referral) | 703 | 932 |
| ENT | 636 | 688 |
| Physiotherapy | 412 | 428 |
| Cardiology | 349 | 299 |
| Renal | 295 | 288 |
| Neurology | 264 | 286 |
| Gastroenterology | 242 | 88 |

**Key Findings**

- General Practice received the highest number of departmental referrals in both years, increasing from 784 patients in 2023 to 994 in 2024.
- Orthopedics remained another high-demand department, recording 779 referrals in 2023 and 748 in 2024.
- Patients treated directly within the Emergency Room without referral to another department(None) increased from 703 in 2023 to 932 in 2024.

---

### 4. 🏨 Admission Patterns

| Admission Status | 2023 Patients | 2023 % | 2024 Patients | 2024 % |
|---|---:|---:|---:|---:|
| Admitted (Active) | 2,190 | 49.06% | 2,422 | 50.97% |
| Not Admitted (Not Active) | 2,274 | 50.94% | 2,330 | 49.03% |

**Key Findings**

- The proportion of admitted patients increased from 49.06% in 2023 to 50.97% in 2024.
- Conversely, the non-admission proportion declined from 50.94% to 49.03%.
- The distribution remained relatively balanced, with approximately half of ER patients being admitted.

---

### 5. ⏱️ Patient Waiting Time & Service Efficiency

| Attendance Status | 2023 | 2024 |
|---|---:|---:|
| On Time (Within 30 Minutes) | 41% | 41% |
| Delay (More Than 30 Minutes) | 59% | 59% |

**Key Findings**

- Approximately 59% of patients experienced waiting times exceeding 30 minutes in both years.
- Only 41% of patients were attended to within the 30-minute target.
- Despite the increase in patient visits, the proportion of delayed patients remained unchanged.

---

### 6. 📅 Day-wise & Hourly Patient Inflow

#### 6.1 Yearly Patient Distribution by Weekday

| Day | 2023 Patients | 2024 Patients |
|---|---:|---:|
| Monday | 655 | 644 |
| Tuesday | 623 | 685 |
| Wednesday | 698 | 771 |
| Thursday | 590 | 684 |
| Friday | 685 | 667 |
| Saturday | 617 | 658 |
| Sunday | 596 | 643 |

#### 6.2 Yearly Patient Distribution by Time Slot

| Time Slot | 2023 Patients | 2024 Patients |
|---|---:|---:|
| 00:00–02:00 | 377 | 401 |
| 02:00–04:00 | 390 | 371 |
| 04:00–06:00 | 377 | 400 |
| 06:00–08:00 | 366 | 424 |
| 08:00–10:00 | 389 | 385 |
| 10:00–12:00 | 374 | 378 |
| 12:00–14:00 | 368 | 408 |
| 14:00–16:00 | 380 | 382 |
| 16:00–18:00 | 343 | 382 |
| 18:00–20:00 | 361 | 394 |
| 20:00–22:00 | 349 | 399 |
| 22:00–24:00 | 390 | 418 |

**Key Findings**

- Wednesday recorded the highest patient volume in both years, increasing from 698 patients in 2023 to 771 in 2024.
- The busiest two-hour interval changed between years: 02:00–04:00 and 22:00–24:00 recorded the joint highest volumes in 2023, while 06:00–08:00 recorded the highest volume in 2024.
- The 22:00–24:00 interval also experienced considerable demand in 2024, with 418 patient visits.

---
