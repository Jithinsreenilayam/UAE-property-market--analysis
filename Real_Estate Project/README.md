# 🏙️ UAE Property Market Analysis
### End-to-End Data Analytics Project | MySQL · Power BI · DAX

![SQL](https://img.shields.io/badge/MySQL-8.0-blue?logo=mysql&logoColor=white)
![Power BI](https://img.shields.io/badge/Power%20BI-Desktop-F2C811?logo=powerbi&logoColor=black)
![DAX](https://img.shields.io/badge/DAX-Measures-orange)
![Dataset](https://img.shields.io/badge/Dataset-492%20Listings-lightgrey)
![Emirates](https://img.shields.io/badge/Coverage-5%20Emirates-green)
![Status](https://img.shields.io/badge/Status-Complete-success)

---

## Project Overview

This project delivers a **full-stack property market intelligence solution** for the UAE real estate sector — from raw data ingestion through SQL transformation to a multi-page Power BI dashboard built for business decision-making.

The dataset covers **492 residential property listings** across 5 UAE emirates (Dubai, Abu Dhabi, Sharjah, Ras Al Khaimah, Ajman), spanning **June 2022 to March 2024**. The analysis focuses on pricing dynamics, RERA regulatory compliance, and area-level investment intelligence — all topics directly relevant to developers, investors, brokers, and regulators operating in the UAE market.

> **Why this matters for UAE organisations:** With the UAE real estate sector growing at record pace — Dubai alone recorded AED 528 billion in property transactions in 2023 — data-driven decisions are no longer optional. This project demonstrates exactly the kind of analytical pipeline that property firms, PropTech platforms, and investment consultancies in the UAE rely on.

---

## Repository Structure

```
uae-property-analysis/
│
├── README.md                          ← You are here
│
├── sql/
│   └── uae_property_analysis.sql      ← Full MySQL pipeline in 4 section (Inspection → cleaning → views
│
├── assets/
│   ├── dashboard_page2_preview.png    ← Page 2 screenshot (RERA & Compliance)
│   └── dashboard_page3_preview.png    ← Page 3 screenshot (Area Intelligence)
│
├── docs/
│   ├── dashboard_guide.md             ← Dashboard guidance for each page
│   ├── data_dictionary.md	       ← Describe every field in the dataset
│   ├── page2_rera_compliance.md       ← All DAX measures for Page 2
│   └── page3_area_intelligence.md     ← All DAX measures for Page 3
    └── business_insights.md	       ← Key findings from the analysis
│
└── uae_properties.csv                 ← Source dataset (492 listings)
```

---

## Project Pipeline 

```
Raw CSV  →  MySQL Ingestion  →  Data Cleaning  →  Analytical View  →  Power BI  →  Dashboards
```

| Stage | Tool | Output |
|---|---|---|
| Raw data ingestion | MySQL 8.0 | `uae_properties` table |
| Type casting & transformation | MySQL | `uae_properties_transform` |
| Data cleaning & feature engineering | MySQL | `uae_properties_clean` |
| Analytical aggregations | MySQL Views |  view (city, area, bedroom, etc.) |
| Calculated columns & measures | DAX / Power BI | `rera_status`, compliance rate, price premium, area rank |
| Interactive dashboards | Power BI Desktop | 3-page report (Overview · RERA · Area Intelligence) |

---

## ❓ Business Questions This Project Answers

This project was structured around real questions that UAE real estate organisations ask:

**Pricing & Market Structure**
- What is the average property price across UAE emirates, and how does it vary by city?
- How does bedroom count affect pricing, and where does price per bedroom offer the best value?
- Which areas command the highest price premium, and what drives that premium?

**Regulatory Compliance (RERA)**
- Which emirates are compliant with RERA registration requirements?
- Does RERA registration correlate with higher property prices — and by how much?
- Which property types (studios vs 3BR) show higher RERA compliance rates?

**Area Intelligence & Investment**
- Which neighbourhoods offer the best value per bedroom for buyers?
- Which areas combine high listing volume with premium pricing (high-conviction investment zones)?
- Where should developers focus new launches for maximum market traction?

---

## Key Findings & Insights

### RERA Compliance Is a Powerful Price Signal

| Status | Avg Price (AED) | Listings |
|---|---|---|
| RERA Registered | 2,567,119 | 323 (65.7%) |
| Non-RERA | 1,400,794 | 169 (34.3%) |
| **Premium** | **+83%** | — |

- **Dubai mandates 100% RERA compliance** across all 307 listings — making it the benchmark for regulatory maturity in the region.
- **Abu Dhabi has only 4.1% RERA compliance** across 122 listings — representing a significant compliance gap and potential price upside for early movers who register.
- **RAK and Ajman have 0% RERA registration** — indicating that regulatory adoption in emerging emirates is a key opportunity for developers to differentiate.
- For **3-bedroom units specifically**, RERA-registered properties command a **121% premium** (AED 3.48M vs AED 1.58M) — the strongest signal across all property types.

### Dubai Dominates Premium, Abu Dhabi Leads Volume Value

| Emirate | Listings | Avg Price (AED) | Avg Price/Bedroom |
|---|---|---|---|
| Dubai | 307 | 2,587,409 | 1,190,000 |
| Ras Al Khaimah | 14 | 2,812,817 | 1,110,000 |
| Abu Dhabi | 122 | 1,411,759 | 502,000 |
| Sharjah | 43 | 1,348,680 | 592,000 |
| Ajman | 6 | 328,667 | 116,000 |

- **Dubai's avg price per bedroom (AED 1.19M) is 10× higher than Ajman** — the largest bedroom-efficiency gap in UAE.
- **RAK (Ras Al Khaimah) punches above its weight** — averaging AED 2.81M despite only 14 listings, driven by Al Marjan Island's tourism-linked premium developments.

### Top 10 Premium Areas (Min. 5 listings)

| Rank | Area | City | Avg Price (AED) | Listings |
|---|---|---|---|---|
| 1 | Palm Jumeirah | Dubai | 9,132,567 | 6 |
| 2 | Dubai Harbour | Dubai | 6,522,178 | 5 |
| 3 | Jumeirah Beach Residence | Dubai | 6,133,333 | 6 |
| 4 | Downtown Dubai | Dubai | 5,635,597 | 17 |
| 5 | Dubai Marina | Dubai | 4,599,864 | 10 |
| 6 | Dubai Creek Harbour | Dubai | 4,307,440 | 5 |
| 7 | Mohammed Bin Rashid City | Dubai | 4,082,118 | 6 |
| 8 | Business Bay | Dubai | 3,996,517 | 24 |
| 9 | Dubai Hills Estate | Dubai | 3,585,378 | 5 |
| 10 | Al Marjan Island | RAK | 3,005,944 | 10 |

> All top 10 premium areas are in Dubai. Al Marjan Island (RAK) is the only non-Dubai entry — a strong signal of RAK's rising investment profile.

### Best Value Areas (Price per Bedroom)

| Area | City | Avg Price/Bedroom |
|---|---|---|
| Emirates City | Ajman | AED 116,000 |
| Al Reef | Abu Dhabi | AED 344,000 |
| Al Shamkha | Abu Dhabi | AED 392,000 |
| Al Ghadeer | Abu Dhabi | AED 412,000 |
| Muwaileh | Sharjah | AED 479,000 |
| Jumeirah Village Circle | Dubai | AED 605,000 |

> Abu Dhabi dominates the value corridor. JVC is the only Dubai area in the top value rankings — making it the entry point for budget-conscious Dubai buyers.

###   Bedroom Segmentation
| Category | Listings | Avg Price (AED) | RERA Rate |
|---|---|---|---|
| Studio (0 BR) | 141 | 783,540 | 79.4% |
| 3 BR | 351 | 2,722,036 | 60.1% |

> Studios have a higher RERA compliance rate (79.4%) than 3BR units (60.1%), suggesting off-plan developer registrations dominate the studio segment. The 3BR average price (AED 2.72M) is 3.5× the studio average — the clearest single driver of portfolio value.



---

## Strategic Recommendations

These recommendations are framed for the UAE real estate industry:

**For Developers**
- Prioritise RERA registration in Abu Dhabi and RAK before launch — the 83% price premium is a direct financial incentive that outweighs the compliance cost.
- Target Al Shamkha and Al Reem Island (Abu Dhabi) for pipeline expansion — both areas combine high volume (43 and 34 listings respectively) with mid-range pricing, signalling genuine buyer demand.
- Business Bay and Downtown Dubai remain the highest-volume premium zones in Dubai — ideal for brokers targeting AED 4M+ transaction volume.

**For Investors**
- Al Marjan Island (RAK) offers the most compelling non-Dubai growth thesis: AED 3.0M average with only 10 listings, backed by RAK's tourism megaproject pipeline (Wynn Al Marjan Island casino resort etc.).
- JVC (Dubai) is the sweet spot for yield-focused investors — high volume, RERA compliant, at a fraction of Downtown Dubai's price per bedroom.
- Avoid unregistered listings in Abu Dhabi for investment — the non-RERA discount is a risk premium, not a bargain.

**For Regulators**
- Dubai's 100% RERA mandate is the benchmark. Extending a similar framework to RAK and Ajman would unlock premium pricing for local developers and attract foreign institutional capital.
- Abu Dhabi's 4.1% RERA rate, despite 122 listings, represents a structural compliance gap — a phased mandate aligned with ADRO's existing regulatory infrastructure is recommended.

---

## Technical Details

### MySQL Pipeline

The SQL script (`sql/uae_property_analysis.sql`) executes in 4 sequential stages:

1. **Raw Ingestion** — `uae_properties` table created from CSV import
2. **Type Transformation** — `uae_properties_transform`: casts prices, dates, RERA numbers; strips invalid values
3. **Feature Engineering** — `uae_properties_clean`: extracts city/area from address string, creates bedroom categories, price tiers, price per bedroom, formatted date fields
4. **Analytical Views** — Listing detail view pre-aggregated for Power BI consumption

**View created:**

| View | Purpose |

| `vw_listings_detail` | Full clean table for drill-through |

### Power BI DAX Measures

Key measures are documented in the `dax/` folder. Highlights:

```dax
-- RERA status classification (Calculated Column)
rera_status = IF(ISBLANK([rera]) || [rera] = 0, "Non-RERA", "RERA Registered")

-- RERA Price Premium
RERA Price Premium % = DIVIDE([RERA Avg Price] - [Non-RERA Avg Price], [Non-RERA Avg Price])

-- Area Rank (for Top 10 table)
Area Rank by Avg Price = RANKX(
    FILTER(ALL(uae_properties_clean[area]),
           CALCULATE(COUNTROWS(uae_properties_clean)) >= 3),
    CALCULATE(AVERAGE(uae_properties_clean[price])),, DESC, DENSE)

-- Avg Price Per Bedroom (handles studios correctly)
Avg Price Per Bedroom = AVERAGEX(
    FILTER(uae_properties_clean, uae_properties_clean[bedrooms] > 0),
    uae_properties_clean[price] / uae_properties_clean[bedrooms])
```

See [`docs/page2_rera_compliance.md`](docs/page2_rera_compliance.md) and [`docs/page3_area_intelligence.md`](docs/page3_area_intelligence.md) for the full measure library.

---

## 📁 Dataset

**File:** `uae_properties.csv`  
**Source:** UAE property listings aggregator  
**Period:** June 2022 – March 2024  
**Size:** 492 rows × 10 columns 
**Format** | CSV / XLSX |
**Geographies** | Dubai, Abu Dhabi, Sharjah, Ras Al Khaimah, Ajman |
**Property Type** | Residential apartments (buy listings only) |
**Raw Fields** | 10 (id, title, displayAddress, bathrooms, bedrooms, addedOn, type, rera, propertyType, price) |
**Engineered Fields** | 12 additional fields created during cleaning | 

| Column | Type | Description |
|---|---|---|
| `id` | INT | Unique listing ID |
| `title` | TEXT | Listing title |
| `displayAddress` | TEXT | Full address string (parsed for city/area) |
| `bathrooms` | INT | Number of bathrooms |
| `bedrooms` | INT | Number of bedrooms (0 = Studio) |
| `addedOn` | DATETIME | Listing date (ISO 8601 format) |
| `type` | TEXT | Sale or Rent |
| `rera` | BIGINT | RERA registration number (NULL = unregistered) |
| `propertyType` | TEXT | Apartment, Villa, etc. |
| `price` | BIGINT | Listed price in AED |

---

## 🖼️ Dashboard Preview

### Page 2 — RERA & Compliance Intelligence
> Regulatory compliance analysis — how RERA registration shapes pricing, investor trust, and supply quality across UAE

*[See `assets/dashboard_page2_preview.png`]*

### Page 3 — Area Intelligence & Investment Lens
> Neighbourhood-level price discovery, value scoring, and market segmentation

*[See `assets/dashboard_page3_preview.png`]*

---

## ▶️ How to Reproduce

**Prerequisites:** MySQL 8.0+, Power BI Desktop (free)

**Step 1 — Import the data**
```sql
-- Create database
CREATE DATABASE uae_property_db;
USE uae_property_db;

-- Import uae_properties.csv via MySQL Workbench Table Data Import Wizard
-- or using LOAD DATA INFILE
```

**Step 2 — Run the SQL pipeline**
```bash
# Run the full script in MySQL Workbench or via CLI
mysql -u root -p uae_property_db < sql/uae_property_analysis.sql
```

**Step 3 — Connect Power BI**
- Open Power BI Desktop
- Get Data → MySQL Database
- Server: `localhost`, Database: `uae_property_db`
- Import all 8 views + `uae_properties_clean`

**Step 4 — Add DAX measures**
- Copy measures from `dax/page2_rera_compliance.md` and `dax/page3_area_intelligence.md`
- Add calculated column `rera_status` first (all other RERA measures depend on it)

---

## 🧑‍💻 About This Project

This project was built to demonstrate a complete data analytics workflow applied to a real-world UAE business problem — from structured SQL data engineering through to business-ready Power BI dashboards.

The UAE real estate market was chosen deliberately: it is one of the most data-rich, internationally visible, and analytically complex property markets in the world, with strong demand for data professionals who understand local regulatory frameworks (RERA), emirate-level market segmentation, and investment dynamics.

**Tools & Skills Demonstrated:**
- `MySQL 8.0` — DDL, DML, CTEs, window functions, string parsing, date handling
- `Power BI Desktop` — data modelling, DAX calculated columns, DAX measures, visual design
- `DAX` — CALCULATE, RANKX, TOPN, AVERAGEX, DIVIDE, SWITCH, FILTER patterns
- Data cleaning & feature engineering from raw real-world data
- Business storytelling through structured dashboard design

## 🧠 Skills Demonstrated

| Category | Skills |
|---|---|
| **SQL** | DDL (CREATE TABLE, ALTER, INDEX), DML (INSERT SELECT), window functions, CASE WHEN, REGEXP, STR_TO_DATE, SUBSTRING_INDEX, CREATE VIEW |
| **Data Cleaning** | Null handling, type casting, regex validation, address string parsing, date normalisation |
| **Feature Engineering** | Derived categorical fields, price bucketing, city/area extraction, time fields |
| **Power BI** | Data modelling, DAX measures, conditional formatting, cross-filtering, custom themes, small multiples, scatter charts, drill-through tooltips |
| **Analytics** | Price segmentation, compliance analysis, time-series trend analysis, value scoring, supply-demand interpretation |
| **Business Acumen** | UAE real estate market context, RERA regulatory framework, investor vs developer vs broker perspective |

---

## 📬 Contact

**JITHIN SREENILAYAM**
| Data Analyst | UAE Market Focus

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-0077B5?style=flat&logo=linkedin)](https://www.linkedin.com/in/jithin-sreenilayam/)
[![Portfolio](https://img.shields.io/badge/Portfolio-Visit-C9A84C?style=flat)](https://your-portfolio.com)


---

## 📜 License

This project is released for educational and portfolio purposes.  
Dataset sourced from publicly available Kaggle Database.

---

*Built with MySQL 8.0 + Power BI Desktop · UAE Property Market 2022–2024*
