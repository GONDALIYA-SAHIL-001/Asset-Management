# Asset & Investment Management System

A comprehensive, enterprise-grade relational database built in **PostgreSQL**, modeling the complete backend of an Asset Management Company (AMC) — from corporate hierarchy and investor portfolios to mutual fund schemes, market data, and algorithmic trading signals.

The project is fully normalized to **BCNF** (24 tables) and populated with **realistic Indian mutual fund industry data** (HDFC, ICICI Prudential, SBI, Nippon India, Axis, Kotak, Mirae, UTI) to demonstrate real-world query scenarios across multiple stakeholder perspectives.

---

## 📌 Project Overview

This database models the intricate lifecycle of investments, quantitative analysis, and corporate management within the financial services sector. It supports:

- **Corporate Hierarchy** — AMCs, departments, employees, managers, and fund managers
- **Investment Instruments** — structural tracking from Sector → Industry → Company → Asset
- **Portfolio & Fund Management** — retail/HNI investors, dynamic cash balances, fund schemes (AUM, NAV, risk levels), transactions, and real-time holdings
- **Market Intelligence & Analytics** — historical OHLCV market data, technical indicators (RSI, FVG, moving averages), fundamental ratios (P/E, P/B, ROE, ROCE), and algorithmic trading signals (BUY/SELL/HOLD)

---

## 🏗️ Database Architecture

The schema is divided into three layers for separation of concerns, high integrity, and scalable performance:

### 1. Master & Reference Data
`amc`, `department`, `employee`, `employee_scheme`, `sector`, `industry`, `company`, `asset`, `investor`

### 2. Portfolio & Investment Engine
- `portfolio` — investor capital allocation and liquid cash
- `fund_scheme` — individual mutual funds managed by specific fund managers
- `transactions` — single audit log with strict segregation between asset trades and scheme trades
- `scheme_holding`, `investment_position`, `scheme_position` — composite-key ledger tables for cross-sectional holdings

### 3. Market & Analysis Module
- `market_data` — daily OHLCV metrics
- `fundamental_data` — quarterly corporate financial ratios (P/E, P/B, EPS, ROE, ROCE)
- `analysis` & `technical_data` — trading signals with RSI, support/resistance, candlestick patterns
- `algorithm` — links quantitative strategies to their underlying fundamental and technical inputs

---

## 🔐 Data Integrity & Business Rules

- **Transactional Exclusivity** — a CHECK constraint ensures every transaction records either an ASSET trade *or* a SCHEME trade, never both or neither
- **Referential Actions** — `ON DELETE CASCADE` on dependent mapping tables; `ON DELETE RESTRICT` on core reference tables (AMC, company, industry)
- **Financial Safeguards** — hard validation checks: salary > 0, transaction amount > 0, holding quantities ≥ 0, positive valuation multiples
- **Circular Dependency Handling** — `department ↔ employee` and `asset ↔ market_data` resolved via deferred FK addition (`ALTER TABLE`) to avoid chicken-and-egg constraint errors

---

## 📊 Query Library — Persona-Based Insights

The `DQL.sql` file is organized around **four real-world stakeholder perspectives**, going beyond basic CRUD to demonstrate practical decision-support use cases:

### 👔 Fund Manager Perspective
- Which schemes under a manager are performing well vs. underperforming
- Total AUM managed and ranking across fund managers

### 🏢 AMC Perspective
- Which scheme types attract the most investor capital
- AMC-wise investor count and total AUM (trust/popularity ranking)

### 💰 Investor Perspective
- Full portfolio breakdown — stocks vs. mutual funds, allocation by value
- Profit/loss on mutual fund holdings (current NAV vs. average cost)
- Year-wise transaction history (stocks vs. schemes)
- Risk-adjusted investment recommendations (best AUM/NAV among low-medium risk schemes)

### 📈 Sector / Market Perspective
- Fastest-growing sectors by revenue growth
- Sector-wise valuation (P/E ratio) to flag undervalued vs. overvalued sectors

### 🎯 Algorithm vs. Human Behavior
- Missed opportunities — BUY signals the investor did not act on
- Independent wins — investor entries with no algorithmic signal that turned profitable
- Signal accuracy tracking against actual market movement

---

## 🛠️ Tech Stack

- **Database:** PostgreSQL
- **Tool:** pgAdmin
- **Design:** Pure SQL — DDL, DML, and DQL.

---

## 🚀 Getting Started

```bash
# 1. Create the schema
psql -U <username> -d <database> -f DDL.sql

# 2. Populate with realistic data
psql -U <username> -d <database> -f Data_Insertion.sql

# 3. Run analytical queries
psql -U <username> -d <database> -f DQL.sql
```
