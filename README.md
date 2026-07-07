# Asset-Management

A comprehensive, enterprise-grade relational database schema built in **PostgreSQL**. This system acts as a complete backend backbone for an Asset Management Company (AMC), managing everything from basic master structures (companies, industries, and personnel) to investor portfolios, mutual fund schemes, market feeds, algorithmic strategies, and technical/fundamental analytical data.

---

## 📌 Project Overview

This database is designed to model the intricate lifecycle of investments, quantitative analysis, and corporate management within the financial services sector. It supports:
* **Corporate Hierarchy:** Management of AMCs, departmental functions, employees, managers, and department heads.
* **Investment Instruments:** Granular structural tracking from Sectors $\rightarrow$ Industries $\rightarrow$ Companies $\rightarrow$ Assets.
* **Portfolio & Fund Management:** Tracking retail/institutional investors, their dynamic cash balances, fund schemes (AUM, NAV, Risk Levels), transactions, and real-time holdings.
* **Market Intelligence & Analytics:** Storing historical market data matrices, mapping algorithmic/quantitative trading rules, and documenting complex automated signals (`BUY`, `SELL`, `HOLD`) derived from technical metrics (RSI, Fair Value Gaps, moving averages) and foundational corporate health values (P/E, P/B, Debt-to-Equity ratios).

---

##  Database Architecture & Modules

The schema is logically divided into three major layers to ensure strict separation of concerns, high integrity, and scalable performance:

### 1. Master & Reference Data
Handles the infrastructure of the market environment and organization.
* `amc`, `department`, `employee`, `employee_scheme`
* `sector`, `industry`, `company`, `asset`
* `investor`

### 2. Portfolio & Investment Engine
Manages financial entities, live balances, transaction logging, and current capital positions.
* `portfolio`: Tracks investor capital allocation and liquid cash.
* `fund_scheme`: Represents individual funds (e.g., Mutual Funds, ETFs) managed by specific fund managers.
* `transactions`: Single audit log ensuring strict transaction segregation (Assets vs. Mutual Fund Schemes).
* `scheme_holding`, `investment_position`, `scheme_position`: Multi-tenant ledger balances using composite primary keys to represent instantaneous cross-sectional holdings.

### 3. Market & Analysis Module
Houses the Quantitative engineering components.
* `market_data`: Stores daily OHLCV (Open, High, Low, Close, Volume) metrics.
* `fundamental_data`: Stores quarterly corporate finance ratios ($P/E, P/B, EPS$).
* `analysis` & `technical_data`: Documents manual or system-generated trading ideas utilizing specific metrics (e.g., RSI, Supports, Resistance).
* `algorithm`: Connects mathematical execution logics directly with their dependent fundamental and technical data inputs.

---

## Data Integrity & Business Rules

To protect data consistency across highly coupled assets and portfolios, the system enforces advanced constraints natively at the database level:

* **Transactional Exclusivity:** A check constraint ensures a transaction records either an individual `ASSET` buy/sell or a `SCHEME` unit buy/sell, never both simultaneously or neither.
* **Referential Actions:** Utilizes cascade deletes (`ON DELETE CASCADE`) strategically on mapping tables, while blocking parent table deletions (`ON DELETE RESTRICT`) on critical reference points like corporate structures.
* **Financial Safeguards:** Hard validation checks to protect against financial anomalies:
    * $\text{Salary} > 0$
    * $\text{Transaction Amount} > 0$
    * $\text{Asset Holding Quantities} \ge 0$
    * Positive Valuation Multiples ($P/E, P/B, EPS$)
* **Strict Enumeration Controls:** Hardcoded parameters enforcing risk bounds (`LOW`, `MEDIUM`, `HIGH`) and market directions (`BUY`, `SELL`, `HOLD`).


