# Aviation Safety Event Monitoring – Data Engineering & Analytics Pipeline

## Overview
This project is an end-to-end aviation safety analytics system designed to simulate real-world Safety Management System (SMS) workflows used in aerospace organizations.  
It includes data engineering, ETL, schema design, and dashboarding for actionable safety insights.

The solution processes raw safety event logs, builds a star schema in SQL Server, performs ETL transformations, and visualizes trends and risks through a Power BI dashboard.

---

## Features
### ✔ Data Engineering
- Combined multiple CSV sources using **Python, Pandas, NumPy** in Google Colab.
- Cleaned, normalized, and validated aviation event fields.
- Exported final dataset for loading into SQL Server.

### ✔ Data Warehouse Modeling
- Designed a complete **Star Schema**:
  - **FactSafetyEvent**
  - **DimDate**
  - **DimAircraft**
  - **DimSubsystem**
  - **DimEventSource**
  - **DimRootCause**
  - **DimPhaseOfFlight**

- Ensured conformed dimensions, surrogate keys, and optimized indexing.

### ✔ ETL in SQL Server (SSMS)
- Created fully automated ETL scripts:
  - Dimension loading (SCD Type 1)
  - Fact table population
  - Data validation and deduplication
- Built analytical SQL Views:
  - **vw_EventTrend**
  - **vw_RootCause**
  - **vw_PhaseRisk**

### ✔ Analytics & Visualization
A production-style **Power BI dashboard** containing:
- Event trend analytics
- Aircraft/Subsystem-wise event distribution
- Root-cause breakdown
- Critical vs non-critical risk metrics
- Phase-of-flight safety heatmap
- Time-series event patterns
- Slicers for Date, Aircraft, Severity, Subsystem, Root Cause

Dashboard uses DAX measures for:
- Total Events
- Critical Events
- Monthly Event Trend
- Subsystem Impact
- Root Cause Contribution
- Severity Index

---

## Architecture Diagram

The system follows a production-style data engineering + BI analytics pipeline:

                      ┌──────────────────────────────────────────┐
                      │              RAW DATA SOURCE             │
                      │        Aviation Safety Event CSVs        │
                      └──────────────────────────────────────────┘
                                         │
                                         ▼
                      ┌──────────────────────────────────────────┐
                      │            PYTHON PROCESSING             │
                      │  Google Colab Notebook (Pandas, NumPy)   │
                      │  - Merge multiple sources                │
                      │  - Data cleaning & normalization         │
                      │  - Feature formatting (dates, categories)|
                      |  - Derived columns                       |
                      │  - Export cleaned CSV                    │
                      └──────────────────────────────────────────┘
                                         │
                                         ▼
                  ┌────────────────────────────────────────────────────┐
                  │                 SQL SERVER (SSMS)                  │
                  │             DATA WAREHOUSE LAYER                   │
                  ├────────────────────────────────────────────────────┤
                  │ 1. SCHEMA DESIGN                                   │
                  │    • Star Schema                                   │
                  │    • FactSafetyEvent & all Dimensions              │
                  │    • Surrogate Keys, PK/FK constraints             │
                  │                                                    │
                  │ 2. ETL PIPELINE                                    │
                  │    • Bulk Insert Cleaned Data                      │
                  │    • Load DimDate                                  │
                  │    • Load Aircraft, Subsystem, RootCause etc.      │
                  │    • Load FactSafetyEvent                          │
                  │                                                    │
                  │ 3. TRANSFORMATION & ANALYTICAL VIEWS               │
                  │    • vw_EventTrend                                 │
                  │    • vw_PhaseRisk                                  │
                  │    • vw_RootCause                                  │
                  └────────────────────────────────────────────────────┘
                                         │
                                         ▼
             ┌──────────────────────────────────────────────────────────────┐
             │                     POWER BI DATA MODEL                      │
             │   Direct SQL Server Connection (Star Schema Imported)        │
             ├──────────────────────────────────────────────────────────────┤
             │  MODELING                                                    │
             │  • Relationships: Fact ↔ Dimensions                          │
             │  • DAX Measures: TotalEvents, CriticalEvents, Trend, etc.    │
             │  • Calculated Tables (if any)                                │
             └──────────────────────────────────────────────────────────────┘
                                         │
                                         ▼
         ┌────────────────────────────────────────────────────────────────────────┐
         │                               POWER BI REPORT                          │
         ├────────────────────────────────────────────────────────────────────────┤
         │ • Event Trend Timeline (Year/Month/Day)                                │
         │ • Root Cause Analysis Summary                                          │
         │ • Critical Events Heatmap                                              │
         │ • Subsystem Breakdown                                                  │
         │ • Aircraft & Phase of Flight Insights                                  │
         │ • KPI Cards (Total Events, Critical Events, Severity Score)            │
         │ • Slicers: Date, Subsystem, RootCause, Aircraft, Severity              │
         └────────────────────────────────────────────────────────────────────────┘



---

## Tools & Technologies
- **SQL Server (SSMS)** – Schema design, ETL, DAX-ready views  
- **Power BI** – Dashboard development  
- **Python, Pandas, NumPy** – Data cleaning & transformation  
- **DAX** – KPI and measure creation  
- **Google Colab** – Notebook environment  

---

## Use Cases
- Aviation safety monitoring  
- Training for SMS/FOQA-style data analysis  
- KPI building for aerospace operations  
- BI portfolio project for data/ML roles  

---

## How to Run
1. Load SQL scripts into SQL Server.
2. Execute dimension and fact ETL in order.
3. Refresh Power BI with the SQL Server connection.
4. Dashboard automatically loads all metrics and visuals.

---

## Keywords
**SQL • Power BI • Data Engineering • Star Schema • ETL • DAX • Python • Aviation Analytics • Safety Data Monitoring • Data Warehouse Design**

---




