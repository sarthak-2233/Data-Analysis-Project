<div align="center">

# 📊 AtliQ Hardware Dashboard

### End-to-end Financial, Customer, Product & Supply Chain Analytics in Power BI

![Power BI](https://img.shields.io/badge/Power%20BI-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)
![DAX](https://img.shields.io/badge/DAX-Measures-0078D4?style=for-the-badge)
![SQL](https://img.shields.io/badge/SQL-Data%20Source-336791?style=for-the-badge&logo=postgresql&logoColor=white)
![Status](https://img.shields.io/badge/Status-Complete-success?style=for-the-badge)

*One source of truth for Finance, Sales, Marketing and Supply Chain, from gross sales down to net profit.*

</div>

---

## 📑 Table of Contents

1. [Project Overview](#-project-overview)
2. [Business Problem](#-business-problem)
3. [Dashboard Walkthrough](#-dashboard-walkthrough)
4. [Headline KPIs](#-headline-kpis-fy2022-est)
5. [Key Insights](#-key-insights)
6. [Recommendations](#-recommendations)
7. [Technical Approach](#-technical-approach)
8. [Repository Structure](#-repository-structure)
9. [Getting Started](#-getting-started)
10. [Glossary](#-glossary)
11. [Author](#-author)

---

## 🎯 Project Overview

**AtliQ Hardware** is a consumer-electronics company selling PCs (notebooks, desktops), peripherals, accessories, networking and storage products across **APAC, EU, NA and LATAM** through **Retailer, Direct and Distributor** channels.

This project is a **multi-page, interactive Power BI report** that gives leadership a complete view of business performance:

| Persona | Question answered | Dashboard page |
|---|---|---|
| **CFO / Finance** | Are we profitable, and where does margin leak? | Finance View (P&L) |
| **Sales Head** | Which customers and markets drive revenue and margin? | Sales / Customer View |
| **Marketing / Product** | Which products and divisions perform best? | Marketing / Product View |
| **Supply Chain** | How accurate is our forecast? Where is stock-out or excess-inventory risk? | Supply Chain View |
| **CEO / Exec team** | What is the one-page health check of the business? | Executive View |

Every page supports **cross-filtering** by Region/Market, Customer, Segment/Category/Product, **Fiscal Year (2019–2022 Est)**, **Quarter**, **YTD/YTG**, and a **vs Last Year / vs Target** comparison toggle.

---

## 🧩 Business Problem

Despite strong top-line growth, AtliQ's FY2022 estimate shows a **net loss**. Leadership needed to answer:

- Why is a company with a healthy **38% gross margin** posting a **-14% net profit**?
- Which regions, customers and products are driving the loss, and which are healthy?
- Is the demand forecast good enough to avoid stock-outs and excess inventory?
- Where is AtliQ gaining or losing market share against competitors?

This dashboard turns raw transactional, cost, forecast and market-share data into answers to those questions.

---

## 🖼️ Dashboard Walkthrough

> 📁 Place your screenshots in `/images` using the file names below so they render on GitHub.

### 1️⃣ Finance View: Profit & Loss Statement
![Finance View](images/01_finance_view.png)

- KPI cards for **Net Sales, Gross Margin %, Net Profit %** with benchmark (BM) comparisons
- Full **P&L statement** from Gross Sales to Net Profit, with absolute and % change vs benchmark
- **Net Sales trend** (Sep 21 – Aug 22) versus benchmark
- Top/Bottom **Regions** and **Segments** by net sales

### 2️⃣ Sales View: Customer & Product Performance
![Customer View](images/02_customer_view.png)

- **Customer league table** by Net Sales, Gross Margin $ and GM %
- **Performance Matrix** (scatter: Net Sales vs GM %) to spot high-volume/low-margin accounts
- **Unit Economics** donuts showing how gross sales flow to net sales, then to COGS and gross margin

### 3️⃣ Marketing / Product View: Profitability by Product & Market
![Product View](images/03_product_view.png)

- Product and Region/Market/Customer tables with **GM % and Net Profit %** side by side
- Division-level performance matrix (**N&S, P&A, PC**)
- **Waterfall** from Gross Margin → Operational Expense → Net Profit

### 4️⃣ Supply Chain View: Forecast Accuracy & Risk
![Supply Chain View](images/04_supply_chain_view.png)

- **Forecast Accuracy %, Net Error, Absolute Error** vs last year
- Accuracy/Net-error trend over the fiscal year
- Customer- and product-level **risk flags**: `EI` (Excess Inventory) and `OOS` (Out of Stock)

### 5️⃣ Executive View: One-Page Business Health
![Executive View](images/05_executive_view.png)

- Revenue split by **Division** and **Channel**
- **Sub-zone insight table**: revenue contribution, GM %, net profit %, market share, forecast error and risk
- **Yearly trend** of Revenue, GM %, Net Profit % and Market Share %
- **PC market-share trend** against competitors, plus Top 5 customers and products

---

## 📈 Headline KPIs (FY2022 Est)

| KPI | Value | vs Benchmark (LY) |
|---|---|---|
| **Net Sales** | **$3.74 bn** | $823.85 M (▲ 353.5%) |
| **Gross Margin %** | **38.08 %** | 36.49 % (▲ 4.37 pp) |
| **Net Profit %** | **-13.98 %** | 6.63 % (▼ ~20.6 pp) |
| **Net Profit** | **-$522.4 M** | -$54.7 M |
| **Forecast Accuracy** | **81.17 %** | 80.21 % (▲ 1.2 pp) |
| **Net Forecast Error** | **-3,472.7 K units** | -751.7 K |
| **Absolute Forecast Error** | **6,899.0 K units** | 9,780.7 K (▼ 29.5 %) |
| **PC Market Share** | **5.9 %** | See market-share trend (Executive View) |

---

## 💡 Key Insights

### 🔴 1. The profit problem is an OpEx problem, not a margin problem
- Gross margin is a healthy **$1,422.9 M (38.08 %)**, but operating expense is **$1,945.3 M, about 52 % of net sales**.
- OpEx exceeds gross margin by ~**$522 M**, which is exactly the net loss.
- Gross margin is **above** benchmark (+4.37 pp), but OpEx grew about **5.5x** against the benchmark ($355 M → $1,945 M), far faster than the 4.5x growth in net sales.

> **Net Profit % ≈ GM % (38.08) − OpEx % of Net Sales (52.07) = −13.98 %**

### 🟠 2. Nearly half of gross sales is given away in deductions
- Of **$7.37 bn gross sales**, only **50.7 % ($3.74 bn)** is retained as net sales.
- **Pre-invoice deductions: 23.4 %** and **post-invoice deductions (discounts, rebates, etc.): 25.9 %**, about **49 % combined**.
- Post-invoice deductions alone total **$1.91 bn**, which makes them a major lever for margin recovery.

### 🟡 3. Cost structure
- **Manufacturing cost** is the dominant COGS driver ($2.20 bn of $2.31 bn, ~95 %).
- **Freight (~$100 M)** and **other costs (~$15 M)** are comparatively small.
- COGS is **61.9 %** of net sales, which leaves the 38 % gross margin.

### 🟢 4. Gross margin is remarkably uniform across products, but very different across customers and regions
| Dimension | Observation |
|---|---|
| **Products** | All six segments sit in a tight **38.0 – 38.5 %** GM band, so product mix is not the margin lever |
| **Customers** | GM % ranges from **~30 % (Leader, Sage)** to **~46 % (AtliQ Exclusive, Neptune, Walmart ~45.7 %)** |
| **Regions** | **NA leads at ~45 % GM**, while **EU (34.5 %), LATAM (35.0 %) and APAC (35.9 %)** lag by 9–10 pp |

### 🔵 5. Revenue concentration and channel mix
- **Retailer channel = 71.5 %** of revenue, **Direct = 17.8 %**, **Distributor = 10.7 %**.
- **PC division = ~61 %** of revenue and **Peripherals & Accessories ≈ 36 %**, so Networking & Storage is a very small slice.
- **Notebooks ($1.58 bn)** are the largest segment, followed by **Peripherals ($898 M)** and **Desktops ($711 M)**.
- **Amazon is the largest customer (~$497 M, ~13 % of revenue)**, followed by **AtliQ Exclusive ($361 M)** and **AtliQ e Store ($304 M)**. The top-5 customers account for ~38 % of revenue.

### 🌍 6. Regional performance
| Region | Net Sales | GM % | Net Profit % | Takeaway |
|---|---|---|---|---|
| **APAC** | $1,923.8 M | 35.9 % | -14.6 % | Largest market, largest absolute loss (-$281 M) |
| **NA** | $1,022.1 M | 45.0 % | -14.2 % | Best margin, but OpEx still wipes out profit |
| **EU** | $775.5 M | 34.5 % | -12.3 % | Lowest GM %, smallest relative loss among large regions |
| **LATAM** | $14.8 M | 35.0 % | -3.0 % | Tiny base, nearly break-even |

- **India** (sub-zone) is the standout concern: **~$945 M revenue (25 % of total)** but **-23 % net profit** and **-24.4 % forecast error (OOS risk)**.

### 📦 7. Forecasting: improving accuracy, but a systematic under-forecast
- Forecast accuracy improved to **81.17 %** (+1.2 pp), and absolute error fell **~29 %**.
- But **net error is -3.47 M units (~-9.5 %)**, a persistent **under-forecast**, flagging **Out-of-Stock (OOS)** risk overall.
- **Peripherals (68 % accuracy)** and **Storage (71.5 %)** are the weakest, with net errors of **-3.2 M** and **-0.63 M** units respectively.
- **Accessories and Desktop** are the opposite: positive net error, so **Excess Inventory (EI)** risk.
- **Networking** has the best accuracy (**93 %**) but still leans OOS.
- Some customers sit below **45 % accuracy** (e.g., Saturn, Billa, Notebillig), which is an opportunity for collaborative planning.

### 🏁 8. Market share is under pressure
- AtliQ's PC market share is **~5.9 % in FY2022 Est**, and the market-share trend chart tracks it against competitors (**bp, dale, innovo, pacer**) from 2018 onward, with share shifting noticeably in the latest year.
- Sub-zones such as **SE (16.4 %)** and **India (13.3 %)** show strong relative share, which indicates that growth is regional rather than global.

### 📅 9. Seasonality
- Net sales peak in **Nov–Dec 2021 (~$500 M/month)** and then step down to a flat **~$250 M/month** for Jan–Aug 2022, a clear **holiday-season spike** and a soft post-peak plateau.

---

## ✅ Recommendations

| # | Action | Expected Impact |
|---|---|---|
| 1 | **OpEx rationalisation**: set an OpEx-to-Net-Sales target (e.g., ≤ 38 %) and audit the fastest-growing cost lines | Closes the ~$522 M gap; biggest profit lever |
| 2 | **Deduction governance**: review pre/post-invoice discount policy, especially for low-GM customers (Leader, Sage) | Each 1 pp of gross sales recovered ≈ $74 M |
| 3 | **Customer profitability tiering**: renegotiate or reprice accounts below ~32 % GM; grow Exclusive/Direct channels with 42–46 % GM | Lifts blended GM % |
| 4 | **Fix India economics**: investigate -23 % net margin and -24 % forecast error | Protects the 2nd-largest sub-zone |
| 5 | **Rebalance inventory planning**: lift forecasts for Peripherals/Storage, cut for Accessories/Desktop | Fewer stock-outs and less working capital tied up |
| 6 | **Collaborative forecasting** with low-accuracy customers (< 50 %) | Higher service levels |
| 7 | **Defend PC market share** through channel and pricing strategy in markets with weak share | Stabilises share against competitors |

---

## 🛠️ Technical Approach

| Layer | Details |
|---|---|
| **Visualization** | Power BI Desktop, multi-page report with custom navigation, bookmarks and tooltips |
| **Data Modeling** | Star schema: fact tables (sales, forecast, costs, market share) + dimension tables (customer, product, market, date) |
| **Calculations** | DAX measures: Net Sales, GM %, Net Profit %, YTD/YTG, vs LY/BM, Forecast Accuracy, Net/ABS Error, Risk flag |
| **ETL** | Power Query for cleansing, type handling and fiscal-calendar logic |
| **UX** | Slicers (Region, Customer, Product), FY/Quarter selectors, vs LY / vs Target toggle, drill-down hierarchies |

### Selected Measure Logic

```DAX
Gross Margin % = DIVIDE ( [Gross Margin $], [Net Sales] )

Net Profit % = DIVIDE ( [Net Profit $], [Net Sales] )

Net Error = [Forecast Quantity] - [Sold Quantity]

ABS Error = SUMX ( VALUES ( dim_product[product_code] ), ABS ( [Net Error] ) )

Forecast Accuracy % = 1 - DIVIDE ( [ABS Error], [Forecast Quantity] )

Risk Flag = IF ( [Net Error] > 0, "EI", "OOS" )   -- Excess Inventory vs Out-of-Stock
```

> ℹ️ *Measures above illustrate the logic; adjust names to match your model.*

---

## 📂 Repository Structure

```
atliq-hardware-dashboard/
├── 📄 README.md
├── 📁 dashboard/
│   └── AtliQ_Hardware_Dashboard.pbix
├── 📁 data/
│   ├── raw/
│   └── processed/
├── 📁 images/
│   ├── 01_finance_view.png
│   ├── 02_customer_view.png
│   ├── 03_product_view.png
│   ├── 04_supply_chain_view.png
│   └── 05_executive_view.png
└── 📁 docs/
    └── data_dictionary.md
```

---

## 🚀 Getting Started

1. **Clone the repo**
   ```bash
   git clone https://github.com/<your-username>/atliq-hardware-dashboard.git
   ```
2. **Install** [Power BI Desktop](https://powerbi.microsoft.com/desktop/) (free, Windows).
3. **Open** `dashboard/AtliQ_Hardware_Dashboard.pbix`.
4. **Refresh data**: update the data source paths/credentials under *Transform data → Data source settings*.
5. **Explore**: use the left navigation bar to switch pages and the top filters to slice by region, customer, product, year and quarter.

---

## 📖 Glossary

| Term | Meaning |
|---|---|
| **BM** | Benchmark (last year's comparable value) |
| **LY** | Last Year |
| **YTD / YTG** | Year-to-Date / Year-to-Go |
| **NS** | Net Sales |
| **GM** | Gross Margin = Net Sales − COGS |
| **COGS** | Cost of Goods Sold (manufacturing + freight + other) |
| **RC %** | Revenue Contribution % |
| **EI** | Excess Inventory (over-forecast) |
| **OOS** | Out of Stock (under-forecast) |
| **MS %** | Market Share % |
| **Pre-invoice deductions** | Discounts applied before invoicing |
| **Post-invoice deductions** | Rebates, discounts and other deductions after invoicing |

---

⭐ **If you found this project useful, please give it a star!** ⭐

*Built with Power BI*

</div>
