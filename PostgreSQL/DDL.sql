-- ============================================================================
-- ASSET & INVESTMENT MANAGEMENT SYSTEM — COMPLETE DDL
-- BCNF Normalized Schema (24 Tables)
-- ============================================================================

BEGIN;

-- ============================================================================
-- 1) MASTER / REFERENCE TABLES
-- ============================================================================

CREATE TABLE sector (
    sector_id       INT PRIMARY KEY,
    sector_name     VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE industry (
    industry_id     INT PRIMARY KEY,
    sector_id       INT NOT NULL,
    industry_name   VARCHAR(100) NOT NULL,
    CONSTRAINT fk_industry_sector FOREIGN KEY (sector_id)
        REFERENCES sector(sector_id) ON DELETE RESTRICT
);

CREATE TABLE company (
    company_id          INT PRIMARY KEY,
    company_name        VARCHAR(255) NOT NULL,
    industry_id          INT NOT NULL,
    market_cap           DECIMAL(18,2) NOT NULL CHECK (market_cap > 0),
    nse_listed_number    VARCHAR(50) UNIQUE,
    CONSTRAINT fk_company_industry FOREIGN KEY (industry_id)
        REFERENCES industry(industry_id) ON DELETE RESTRICT
);

CREATE TABLE asset (
    asset_id        INT PRIMARY KEY,
    asset_name      VARCHAR(255) NOT NULL,
    asset_value      INT NOT NULL,          -- units held at AMC level (per ER diagram)
    market_id        INT,                   -- placeholder ref, populated via market_data
    asset_type        VARCHAR(50) NOT NULL DEFAULT 'EQUITY',
    company_id        INT NOT NULL,
    CONSTRAINT fk_asset_company FOREIGN KEY (company_id)
        REFERENCES company(company_id) ON DELETE RESTRICT
);

CREATE TABLE amc (
    amc_id          INT PRIMARY KEY,
    amc_name        VARCHAR(255) NOT NULL UNIQUE,
    total_aum       DECIMAL(18,2) NOT NULL CHECK (total_aum >= 0),
    ceo_name        VARCHAR(100),
    founded_year    INT
);

-- ============================================================================
-- 2) ORGANIZATION / PERSONNEL TABLES
-- ============================================================================

CREATE TABLE department (
    department_id   INT PRIMARY KEY,
    dept_name       VARCHAR(100) NOT NULL,
    function        VARCHAR(255),
    amc_id          INT NOT NULL,
    dept_head_id    INT,                     -- FK to employee, added after employee table
    CONSTRAINT fk_department_amc FOREIGN KEY (amc_id)
        REFERENCES amc(amc_id) ON DELETE RESTRICT
);

CREATE TABLE employee (
    employee_id     INT PRIMARY KEY,
    department_id   INT,
    employee_name   VARCHAR(100) NOT NULL,
    role            VARCHAR(100),
    email           VARCHAR(100) UNIQUE,
    salary          DECIMAL(12,2) NOT NULL CHECK (salary > 0),
    manager_id      INT,
    CONSTRAINT fk_employee_department FOREIGN KEY (department_id)
        REFERENCES department(department_id) ON DELETE SET NULL,
    CONSTRAINT fk_employee_manager FOREIGN KEY (manager_id)
        REFERENCES employee(employee_id) ON DELETE SET NULL
);

-- Now that employee exists, add the dept_head_id FK on department
ALTER TABLE department
    ADD CONSTRAINT fk_department_head FOREIGN KEY (dept_head_id)
        REFERENCES employee(employee_id) ON DELETE SET NULL;

-- ============================================================================
-- 3) INVESTOR / PORTFOLIO TABLES
-- ============================================================================

CREATE TABLE investor (
    investor_id     INT PRIMARY KEY,
    investor_name   VARCHAR(100) NOT NULL,
    fund            VARCHAR(100),           -- descriptive fund/portfolio label
    email           VARCHAR(100) UNIQUE,
    phone_number    VARCHAR(15) UNIQUE,
    investor_type   VARCHAR(50) NOT NULL    -- RETAIL / INSTITUTIONAL / HNI
);

CREATE TABLE portfolio (
    portfolio_id      INT PRIMARY KEY,
    investor_id       INT NOT NULL,
    invested_amount   DECIMAL(18,2) NOT NULL CHECK (invested_amount >= 0),
    liquid_cash       DECIMAL(18,2) NOT NULL CHECK (liquid_cash >= 0),
    CONSTRAINT fk_portfolio_investor FOREIGN KEY (investor_id)
        REFERENCES investor(investor_id) ON DELETE CASCADE
);

-- ============================================================================
-- 4) FUND SCHEME TABLES
-- ============================================================================

CREATE TABLE fund_scheme (
    scheme_id             INT PRIMARY KEY,
    amc_id                INT NOT NULL,
    scheme_name           VARCHAR(255) NOT NULL,
    scheme_type           VARCHAR(100) NOT NULL,
    launch_date           DATE NOT NULL,
    fund_manager_id       INT NOT NULL,
    expense_ratio         DECIMAL(5,2) NOT NULL CHECK (expense_ratio >= 0),
    minimum_investment    DECIMAL(15,2) NOT NULL CHECK (minimum_investment > 0),
    benchmark_index       VARCHAR(100),
    aum                   DECIMAL(18,2) NOT NULL CHECK (aum >= 0),
    nav                   DECIMAL(15,4) NOT NULL CHECK (nav > 0),
    risk_level            VARCHAR(50) NOT NULL,   -- Low / Medium / High / Very High
    CONSTRAINT fk_fundscheme_amc FOREIGN KEY (amc_id)
        REFERENCES amc(amc_id) ON DELETE RESTRICT,
    CONSTRAINT fk_fundscheme_manager FOREIGN KEY (fund_manager_id)
        REFERENCES employee(employee_id) ON DELETE RESTRICT
);

CREATE TABLE employee_scheme (
    employee_id     INT NOT NULL,
    scheme_id       INT NOT NULL,
    role            VARCHAR(10),
    assigned_date   DATE,
    PRIMARY KEY (employee_id, scheme_id),
    CONSTRAINT fk_empscheme_employee FOREIGN KEY (employee_id)
        REFERENCES employee(employee_id) ON DELETE CASCADE,
    CONSTRAINT fk_empscheme_scheme FOREIGN KEY (scheme_id)
        REFERENCES fund_scheme(scheme_id) ON DELETE CASCADE
);

CREATE TABLE scheme_holding (
    scheme_id                INT NOT NULL,
    asset_id                 INT NOT NULL,
    quantity                 DECIMAL(18,4) NOT NULL CHECK (quantity >= 0),
    allocation_percentage    DECIMAL(5,2) NOT NULL CHECK (allocation_percentage >= 0),
    avg_price                DECIMAL(18,2) NOT NULL CHECK (avg_price >= 0),
    PRIMARY KEY (scheme_id, asset_id),
    CONSTRAINT fk_schemeholding_scheme FOREIGN KEY (scheme_id)
        REFERENCES fund_scheme(scheme_id) ON DELETE CASCADE,
    CONSTRAINT fk_schemeholding_asset FOREIGN KEY (asset_id)
        REFERENCES asset(asset_id) ON DELETE CASCADE
);

CREATE TABLE scheme_position (
    portfolio_id    INT NOT NULL,
    scheme_id       INT NOT NULL,
    unit            DECIMAL(18,4) NOT NULL CHECK (unit >= 0),
    avg_nav         DECIMAL(18,2) NOT NULL CHECK (avg_nav >= 0),
    PRIMARY KEY (portfolio_id, scheme_id),
    CONSTRAINT fk_schemeposition_portfolio FOREIGN KEY (portfolio_id)
        REFERENCES portfolio(portfolio_id) ON DELETE CASCADE,
    CONSTRAINT fk_schemeposition_scheme FOREIGN KEY (scheme_id)
        REFERENCES fund_scheme(scheme_id) ON DELETE CASCADE
);

CREATE TABLE scheme_transaction (
    txn_id          INT PRIMARY KEY,
    scheme_id       INT NOT NULL,
    asset_id        INT NOT NULL,
    txn_type        VARCHAR(10) NOT NULL,     -- BUY / SELL
    txn_date        DATE NOT NULL,
    CONSTRAINT fk_schemetxn_scheme FOREIGN KEY (scheme_id)
        REFERENCES fund_scheme(scheme_id) ON DELETE CASCADE,
    CONSTRAINT fk_schemetxn_asset FOREIGN KEY (asset_id)
        REFERENCES asset(asset_id) ON DELETE CASCADE
);

CREATE TABLE investment_position (
    portfolio_id    INT NOT NULL,
    asset_id        INT NOT NULL,
    quantity        DECIMAL(18,4) NOT NULL CHECK (quantity >= 0),
    avg_price       DECIMAL(18,2) NOT NULL CHECK (avg_price >= 0),
    PRIMARY KEY (portfolio_id, asset_id),
    CONSTRAINT fk_investpos_portfolio FOREIGN KEY (portfolio_id)
        REFERENCES portfolio(portfolio_id) ON DELETE CASCADE,
    CONSTRAINT fk_investpos_asset FOREIGN KEY (asset_id)
        REFERENCES asset(asset_id) ON DELETE CASCADE
);

CREATE TABLE transactions (
    transaction_id        INT PRIMARY KEY,
    portfolio_id          INT NOT NULL,
    asset_id              INT,
    scheme_id             INT,
    quantity              DECIMAL(18,4),
    amount                DECIMAL(18,2) NOT NULL CHECK (amount > 0),
    transaction_type      VARCHAR(20) NOT NULL,   -- ASSET / SCHEME / BUY / SELL
    transaction_date      DATE NOT NULL,
    transaction_status    VARCHAR(20) NOT NULL,   -- COMPLETED / FAILED / PENDING
    CONSTRAINT fk_txn_portfolio FOREIGN KEY (portfolio_id)
        REFERENCES portfolio(portfolio_id) ON DELETE CASCADE,
    CONSTRAINT fk_txn_asset FOREIGN KEY (asset_id)
        REFERENCES asset(asset_id) ON DELETE SET NULL,
    CONSTRAINT fk_txn_scheme FOREIGN KEY (scheme_id)
        REFERENCES fund_scheme(scheme_id) ON DELETE SET NULL,
    CONSTRAINT chk_txn_exclusive CHECK (
        (asset_id IS NOT NULL AND scheme_id IS NULL) OR
        (asset_id IS NULL AND scheme_id IS NOT NULL)
    )
);

-- ============================================================================
-- 5) MARKET & ANALYSIS TABLES
-- ============================================================================

CREATE TABLE market_data (
    market_id       INT PRIMARY KEY,
    asset_id        INT NOT NULL,
    date            DATE NOT NULL,
    open_price      DECIMAL(18,2) NOT NULL CHECK (open_price > 0),
    low_price       DECIMAL(18,2) NOT NULL CHECK (low_price > 0),
    high_price      DECIMAL(18,2) NOT NULL CHECK (high_price > 0),
    close_price     DECIMAL(18,2) NOT NULL CHECK (close_price > 0),
    volume          BIGINT NOT NULL CHECK (volume >= 0),
    CONSTRAINT fk_marketdata_asset FOREIGN KEY (asset_id)
        REFERENCES asset(asset_id) ON DELETE CASCADE,
    CONSTRAINT uq_marketdata_asset_date UNIQUE (asset_id, date)
);

-- Now that market_data exists, link asset.market_id properly
ALTER TABLE asset
    ADD CONSTRAINT fk_asset_market FOREIGN KEY (market_id)
        REFERENCES market_data(market_id) ON DELETE SET NULL;

CREATE TABLE analysis (
    analysis_id     INT PRIMARY KEY,
    asset_id        INT NOT NULL,
    analysis_date   DATE NOT NULL,
    signal          VARCHAR(15) NOT NULL,     -- BUY / SELL / HOLD
    duration        TIME,
    entry_price     DECIMAL(18,2) NOT NULL CHECK (entry_price > 0),
    stoploss        DECIMAL(18,2) NOT NULL CHECK (stoploss > 0),
    target_price    DECIMAL(18,2) NOT NULL CHECK (target_price > 0),
    analyst_id      INT NOT NULL,
    CONSTRAINT fk_analysis_asset FOREIGN KEY (asset_id)
        REFERENCES asset(asset_id) ON DELETE CASCADE,
    CONSTRAINT fk_analysis_analyst FOREIGN KEY (analyst_id)
        REFERENCES employee(employee_id) ON DELETE RESTRICT
);

CREATE TABLE technical_data (
    technical_id      INT PRIMARY KEY,
    analysis_id       INT NOT NULL,
    market_id         INT NOT NULL,
    rsi               DECIMAL(5,2) CHECK (rsi >= 0 AND rsi <= 100),
    moving_average    DECIMAL(18,2),
    fvg               DECIMAL(10,4),
    candle_type       VARCHAR(50),
    candle_pattern    VARCHAR(100),
    trend_direction   VARCHAR(20),
    support_level     DECIMAL(18,2),
    resistance_level  DECIMAL(18,2),
    CONSTRAINT fk_techdata_analysis FOREIGN KEY (analysis_id)
        REFERENCES analysis(analysis_id) ON DELETE CASCADE,
    CONSTRAINT fk_techdata_market FOREIGN KEY (market_id)
        REFERENCES market_data(market_id) ON DELETE CASCADE,
    CONSTRAINT uq_techdata_analysis_market UNIQUE (analysis_id, market_id)
);

CREATE TABLE fundamental_data (
    fundamental_id        INT PRIMARY KEY,
    company_id            INT NOT NULL,
    pe_ratio               DECIMAL(10,2) CHECK (pe_ratio > 0),
    pb_ratio                DECIMAL(10,2) CHECK (pb_ratio > 0),
    eps                     DECIMAL(10,2),
    revenue_growth          DECIMAL(17,4),
    debt_to_equity          DECIMAL(10,2) CHECK (debt_to_equity >= 0),
    roe                     DECIMAL(7,4),
    roce                    DECIMAL(7,4),
    dividend_yield          DECIMAL(7,4) CHECK (dividend_yield >= 0),
    market_cap_category     VARCHAR(50),
    last_quarter            VARCHAR(15) NOT NULL,
    CONSTRAINT fk_fundamentaldata_company FOREIGN KEY (company_id)
        REFERENCES company(company_id) ON DELETE CASCADE,
    CONSTRAINT uq_fundamentaldata_company_quarter UNIQUE (company_id, last_quarter)
);

-- ============================================================================
-- 6) ALGORITHM / QUANT ENGINE TABLES
-- ============================================================================

CREATE TABLE algorithm (
    algorithm_id     INT PRIMARY KEY,
    analysis_id      INT NOT NULL,
    strategy_name    VARCHAR(100) NOT NULL,
    logic            TEXT,
    risk_level       VARCHAR(50) NOT NULL,   -- Low / Medium / High
    CONSTRAINT fk_algorithm_analysis FOREIGN KEY (analysis_id)
        REFERENCES analysis(analysis_id) ON DELETE CASCADE
);

-- Bridge tables (composite PK only, no non-key attributes → trivially BCNF)
CREATE TABLE algorithm_analysis (
    analysis_id       INT NOT NULL,
    fundamental_id    INT NOT NULL,
    PRIMARY KEY (analysis_id, fundamental_id),
    CONSTRAINT fk_algoanalysis_analysis FOREIGN KEY (analysis_id)
        REFERENCES analysis(analysis_id) ON DELETE CASCADE,
    CONSTRAINT fk_algoanalysis_fundamental FOREIGN KEY (fundamental_id)
        REFERENCES fundamental_data(fundamental_id) ON DELETE CASCADE
);

CREATE TABLE algorithm_fundamental_data (
    algorithm_id      INT NOT NULL,
    fundamental_id    INT NOT NULL,
    PRIMARY KEY (algorithm_id, fundamental_id),
    CONSTRAINT fk_algofund_algorithm FOREIGN KEY (algorithm_id)
        REFERENCES algorithm(algorithm_id) ON DELETE CASCADE,
    CONSTRAINT fk_algofund_fundamental FOREIGN KEY (fundamental_id)
        REFERENCES fundamental_data(fundamental_id) ON DELETE CASCADE
);

CREATE TABLE algorithm_market_data (
    algorithm_id    INT NOT NULL,
    market_id       INT NOT NULL,
    PRIMARY KEY (algorithm_id, market_id),
    CONSTRAINT fk_algomarket_algorithm FOREIGN KEY (algorithm_id)
        REFERENCES algorithm(algorithm_id) ON DELETE CASCADE,
    CONSTRAINT fk_algomarket_market FOREIGN KEY (market_id)
        REFERENCES market_data(market_id) ON DELETE CASCADE
);

COMMIT;

-- ============================================================================
-- END OF DDL
-- 24 Tables Created: sector, industry, company, asset, amc, department,
-- employee, investor, portfolio, fund_scheme, employee_scheme, scheme_holding,
-- scheme_position, scheme_transaction, investment_position, transactions,
-- market_data, analysis, technical_data, fundamental_data, algorithm,
-- algorithm_analysis, algorithm_fundamental_data, algorithm_market_data
-- ============================================================================
