
BEGIN;

-- ============================================================================
-- 1) SECTOR
-- ============================================================================
INSERT INTO sector (sector_id, sector_name) VALUES
(1, 'Financial Services'),
(2, 'Information Technology'),
(3, 'Pharma & Healthcare'),
(4, 'FMCG'),
(5, 'Automobile'),
(6, 'Real Estate')
ON CONFLICT DO NOTHING;

-- ============================================================================
-- 2) INDUSTRY
-- ============================================================================
INSERT INTO industry (industry_id, sector_id, industry_name) VALUES
(101, 1, 'Banking'),
(102, 1, 'NBFC (Non-Banking Financial Companies)'),
(103, 1, 'Asset Management (AMC)'),
(104, 1, 'Insurance'),
(201, 2, 'IT Services'),
(202, 2, 'Software Products & SaaS'),
(203, 2, 'Engineering Research & Development (ER&D)'),
(301, 3, 'Medicines & Formulation (Pharmaceuticals)'),
(302, 3, 'Medical Devices & Equipment'),
(303, 3, 'Healthcare Services & Hospitals'),
(304, 3, 'Diagnostics & Laboratories'),
(401, 4, 'Food, Beverages & Packaged Foods'),
(402, 4, 'Personal Care & Household Products'),
(403, 4, 'Tobacco Products'),
(501, 5, 'Passenger Cars & Commercial Vehicles'),
(502, 5, 'Two-Wheelers & Three-Wheelers'),
(601, 6, 'Residential & Commercial Developers'),
(602, 6, 'Real Estate Investment Trusts (REITs)')
ON CONFLICT DO NOTHING;

-- ============================================================================
-- 3) COMPANY
-- ============================================================================
INSERT INTO company (company_id, company_name, industry_id, market_cap, nse_listed_number) VALUES
(1001, 'HDFC Bank Ltd.', 101, 1350000.00, 'HDFCBANK'),
(1002, 'ICICI Bank Ltd.', 101, 850000.00, 'ICICIBANK'),
(1003, 'State Bank of India', 101, 750000.00, 'SBIN'),
(1004, 'Bajaj Finance Ltd.', 102, 420000.00, 'BAJFINANCE'),
(1005, 'HDFC Asset Management Company Ltd.', 103, 85000.00, 'HDFCAMC'),
(2001, 'Tata Consultancy Services Ltd.', 201, 1450000.00, 'TCS'),
(2002, 'Infosys Ltd.', 201, 650000.00, 'INFY'),
(3001, 'Sun Pharmaceutical Industries Ltd.', 301, 380000.00, 'SUNPHARMA'),
(3002, 'Cipla Ltd.', 301, 120000.00, 'CIPLA'),
(3003, 'Poly Medicure Ltd.', 302, 22000.00, 'POLYMED'),
(3004, 'Apollo Hospitals Enterprise Ltd.', 303, 92000.00, 'APOLLOHOSP'),
(3005, 'Dr. Lal PathLabs Ltd.', 304, 23000.00, 'LALPATHLAB'),
(4001, 'Nestle India Ltd.', 401, 240000.00, 'NESTLEIND'),
(4002, 'ITC Ltd.', 403, 520000.00, 'ITC'),
(5001, 'Tata Motors Ltd.', 501, 350000.00, 'TATAMOTORS'),
(6001, 'DLF Ltd.', 601, 210000.00, 'DLF')
ON CONFLICT DO NOTHING;

-- ============================================================================
-- 4) AMC
-- ============================================================================
INSERT INTO amc (amc_id, amc_name, total_aum, ceo_name, founded_year) VALUES
(1, 'HDFC Asset Management Company Ltd.', 844000.00, 'Navneet Munot', 1999),
(2, 'ICICI Prudential Asset Management Company Ltd.', 1104787.00, 'Nimesh Shah', 1993),
(3, 'Nippon Life India Asset Management Ltd.', 773481.00, 'Sundeep Sikka', 1995),
(4, 'SBI Funds Management Limited', 1255524.28, 'Nand Kishore', 1987),
(5, 'Axis Asset Management Company', 285000.00, 'B. Gopkumar', 2009),
(6, 'Kotak Mahindra Asset Management', 412000.00, 'Nilesh Shah', 1998),
(7, 'Mirae Asset Investment Managers', 195000.00, 'Swarup Mohanty', 2007),
(8, 'UTI Asset Management Company', 305000.00, 'Imtaiyazur Rahman', 2003)
ON CONFLICT DO NOTHING;

-- ============================================================================
-- 5) DEPARTMENT (dept_head_id filled later, after employees are inserted)
-- ============================================================================
INSERT INTO department (department_id, dept_name, function, amc_id, dept_head_id) VALUES
(11, 'Investment Management', 'Portfolio Construction & Asset Allocation', 1, NULL),
(12, 'Equity Research', 'Company & Sector Valuations', 1, NULL),
(13, 'Quantitative Research', 'Algorithmic & Mathematical Modeling', 1, NULL),
(14, 'Risk Management', 'Stress Testing, Value-at-Risk (VaR) & Compliance', 1, NULL),
(21, 'Investment Management', 'Core Portfolio Management & Trading Decisions', 2, NULL),
(22, 'Equity Research', 'Fundamental Financial Statement Analysis', 2, NULL),
(23, 'Quantitative Research', 'AI & Python-based Algorithmic Strategies', 2, NULL),
(24, 'Risk Management', 'Risk Control, Beta & Drawdown Analysis', 2, NULL),
(31, 'Investment Management', 'Active & Passive Scheme Allocations', 3, NULL),
(32, 'Equity Research', 'Micro-cap & Small-cap Valuation Models', 3, NULL),
(33, 'Quantitative Research', 'Arbitrage & Systematic Quant Funds', 3, NULL),
(34, 'Risk Management', 'SEBI Compliance & Operational Risk Audits', 3, NULL),
(41, 'Investment Management', 'Multi-Asset & Large-scale Equity Deployments', 4, NULL),
(42, 'Equity Research', 'Sector Specific Earnings Modeling', 4, NULL),
(43, 'Quantitative Research', 'Statistical Arbitrage & Derivative Trading', 4, NULL),
(44, 'Risk Management', 'Asset Liability Management & Stress Tests', 4, NULL)
ON CONFLICT DO NOTHING;

-- ============================================================================
-- 6) EMPLOYEE
-- ============================================================================
INSERT INTO employee (employee_id, department_id, employee_name, role, email, salary, manager_id) VALUES
(1, 11, 'Chirag Setalvad', 'Head of Equity & PM', 'chirag.setalvad@hdfcfund.com', 250000.00, NULL),
(2, 11, 'Anupam Joshi', 'Debt Fund Manager', 'anupam.joshi@hdfcfund.com', 180000.00, 1),
(3, 11, 'Srinivasan Ramamurthy', 'Equity Fund Manager', 's.ramamurthy@hdfcfund.com', 170000.00, 1),
(4, 12, 'Nandita Menezes', 'Head of Research', 'nandita.menezes@hdfcfund.com', 140000.00, 1),
(5, 13, 'Priya Ranjan', 'Chief Quant Analyst', 'priya.ranjan@hdfcfund.com', 160000.00, 1),
(6, 13, 'Aditya Sharma', 'Quant Developer', 'aditya.sharma@hdfcfund.com', 95000.00, 5),
(7, 14, 'Ritu Arora', 'Chief Risk Officer', 'ritu.arora@hdfcfund.com', 150000.00, NULL),
(8, 21, 'Sankaran Naren', 'Executive Director & CIO', 's.naren@icicipruamc.com', 320000.00, NULL),
(9, 21, 'Manish Banthia', 'CIO - Debt Portfolio', 'manish.banthia@icicipruamc.com', 220000.00, 8),
(10, 22, 'Priyanka Khandelwal', 'Head of Equity Research', 'priyanka.k@icicipruamc.com', 130000.00, 8),
(13, 22, 'Mittul Kalawadia', 'Sector Research Analyst', 'mittul.k@icicipruamc.com', 85000.00, 10),
(11, 23, 'Sharmila D''Silva', 'Lead Quant Researcher', 'sharmila.dsilva@icicipruamc.com', 165000.00, 8),
(14, 23, 'Aniket Varma', 'Quant Developer', 'aniket.varma@icicipruamc.com', 90000.00, 11),
(12, 24, 'Komal Shah', 'Risk Manager', 'komal.shah@icicipruamc.com', 110000.00, 8),
(15, 31, 'Sailesh Raj Bhan', 'CIO - Equity Investments', 'sailesh.bhan@nipponindiaim.com', 280000.00, NULL),
(16, 31, 'Amit Tripathi', 'CIO - Fixed Income', 'amit.tripathi@nipponindiaim.com', 210000.00, 15),
(17, 32, 'Meenakshi Dawar', 'Head of Equity Research', 'meenakshi.dawar@nipponindiaim.com', 145000.00, 15),
(20, 32, 'Samir Rachh', 'Small Cap Fund Manager', 'samir.rachh@nipponindiaim.com', 185000.00, 15),
(18, 33, 'Kinjal Desai', 'Lead Quant Strategist', 'kinjal.desai@nipponindiaim.com', 155000.00, 15),
(21, 33, 'Nemish Sheth', 'Quant PM & Dealer', 'nemish.sheth@nipponindiaim.com', 120000.00, 18),
(19, 34, 'Rishi Garg', 'Chief Risk Officer', 'rishi.garg@nipponindiaim.com', 160000.00, NULL),
(22, 41, 'Rama Iyer Srinivasan', 'CIO - Equity', 'r.srinivasan@sbimf.com', 310000.00, NULL),
(23, 41, 'Rajeev Radhakrishnan', 'CIO - Debt Portfolio', 'rajeev.r@sbimf.com', 230000.00, 22),
(27, 41, 'Dinesh Balachandran', 'Contra Fund PM', 'dinesh.b@sbimf.com', 190000.00, 22),
(28, 41, 'Nidhi Chawla', 'Equity Fund PM', 'nidhi.chawla@sbimf.com', 135000.00, 22),
(24, 42, 'Ranjana Gupta', 'Head of Research', 'ranjana.gupta@sbimf.com', 150000.00, 22),
(25, 43, 'Tanmaya Desai', 'Quant Lead Researcher', 'tanmaya.desai@sbimf.com', 170000.00, 22),
(26, 44, 'Aparna Nirgude', 'Chief Risk Officer', 'aparna.nirgude@sbimf.com', 165000.00, NULL)
ON CONFLICT DO NOTHING;

-- Repair department -> employee head links
UPDATE department SET dept_head_id = 1  WHERE department_id = 11;
UPDATE department SET dept_head_id = 4  WHERE department_id = 12;
UPDATE department SET dept_head_id = 5  WHERE department_id = 13;
UPDATE department SET dept_head_id = 7  WHERE department_id = 14;
UPDATE department SET dept_head_id = 8  WHERE department_id = 21;
UPDATE department SET dept_head_id = 10 WHERE department_id = 22;
UPDATE department SET dept_head_id = 11 WHERE department_id = 23;
UPDATE department SET dept_head_id = 12 WHERE department_id = 24;
UPDATE department SET dept_head_id = 15 WHERE department_id = 31;
UPDATE department SET dept_head_id = 17 WHERE department_id = 32;
UPDATE department SET dept_head_id = 18 WHERE department_id = 33;
UPDATE department SET dept_head_id = 19 WHERE department_id = 34;
UPDATE department SET dept_head_id = 22 WHERE department_id = 41;
UPDATE department SET dept_head_id = 24 WHERE department_id = 42;
UPDATE department SET dept_head_id = 25 WHERE department_id = 43;
UPDATE department SET dept_head_id = 26 WHERE department_id = 44;

-- ============================================================================
-- 7) INVESTOR
-- ============================================================================
INSERT INTO investor (investor_id, investor_name, fund, email, phone_number, investor_type) VALUES
(1, 'Rajesh Mehta', 'Direct Stock Portfolio', 'rajesh.mehta@gmail.com', '+919825012345', 'RETAIL'),
(2, 'Sunita Patel', 'ICICI Core Bluechip Fund', 'sunita.patel@yahoo.com', '+919898023456', 'RETAIL'),
(3, 'Sanjay Sharma', 'Multi-Scheme Wealth Portfolio', 'sanjay.sharma@gmail.com', '+919712034567', 'RETAIL'),
(4, 'Priya Shah', 'Monthly SIP Regular Plan', 'priya.shah@gmail.com', '+919426045678', 'RETAIL'),
(5, 'Amit Joshi', 'Hybrid Strategic Fund', 'amit.joshi@outlook.com', '+919924056789', 'RETAIL'),
(6, 'Meena Gupta', 'ICICI Focused Growth Portfolio', 'meena.gupta@rediff.com', '+919375067890', 'RETAIL'),
(7, 'Vikram Singh', 'HNI Premium Allocation Fund', 'vikram.singh@gmail.com', '+919824078901', 'HNI'),
(8, 'Anjali Desai', 'SBI Small Cap Growth Scheme', 'anjali.desai@gmail.com', '+919537089012', 'RETAIL'),
(9, 'Kavita Rao', 'Direct Healthcare Securities', 'kavita.rao@gmail.com', '+919714090123', 'RETAIL'),
(10, 'Deepak Pandya', 'Balanced Asset Allocator Portfolio', 'deepak.pandya@gmail.com', '+919099012345', 'RETAIL'),
(11, 'Sneha Iyer', 'Retirement Long Term Goal', 'sneha.iyer@gmail.com', '+919112234455', 'RETAIL'),
(12, 'Manoj Yadav', 'SBI Capital Gainer Scheme', 'manoj.yadav@yahoo.com', '+919223345566', 'RETAIL'),
(13, 'Pooja Trivedi', 'SIP Recurring High Growth', 'pooja.trivedi@gmail.com', '+919334456677', 'RETAIL'),
(14, 'Sanjay Bhatia', 'HNI Multi-Asset Balanced Core', 'sanjay.bhatia@gmail.com', '+919445567788', 'HNI'),
(15, 'Divya Choudhary', 'Direct IT & Tech Basket', 'divya.choudhary@gmail.com', '+919556678899', 'RETAIL')
ON CONFLICT DO NOTHING;

-- ============================================================================
-- 8) PORTFOLIO
-- ============================================================================
INSERT INTO portfolio (portfolio_id, investor_id, invested_amount, liquid_cash) VALUES
(1, 1, 343200.00, 156800.00),
(2, 2, 50000.00, 200000.00),
(3, 3, 150000.00, 100000.00),
(4, 4, 50000.00, 200000.00),
(5, 5, 140000.00, 110000.00),
(6, 6, 50000.00, 200000.00),
(7, 7, 1302500.00, 197500.00),
(8, 8, 60000.00, 190000.00),
(9, 9, 147000.00, 103000.00),
(10, 10, 214000.00, 36000.00),
(11, 11, 100000.00, 150000.00),
(12, 12, 217000.00, 33000.00),
(13, 13, 100000.00, 150000.00),
(14, 14, 995000.00, 505000.00),
(15, 15, 277000.00, 123000.00)
ON CONFLICT DO NOTHING;

-- ============================================================================
-- 9) FUND_SCHEME
-- ============================================================================
INSERT INTO fund_scheme (scheme_id, amc_id, scheme_name, scheme_type, launch_date, fund_manager_id, expense_ratio, minimum_investment, benchmark_index, aum, nav, risk_level) VALUES
(1, 1, 'HDFC Balanced Advantage Fund Direct Growth', 'Hybrid - Balanced Advantage', '2013-09-11', 3, 0.85, 5000.00, 'NIFTY 50 Hybrid Composite debt 50:50 Index', 83000.00, 420.5500, 'High'),
(2, 1, 'HDFC Mid-Cap Opportunities Direct Growth', 'Equity - Mid Cap', '2007-06-25', 1, 0.75, 5000.00, 'NIFTY Midcap 150 TRI', 65000.00, 175.4500, 'Very High'),
(3, 2, 'ICICI Prudential Bluechip Fund Direct Growth', 'Equity - Large Cap', '2008-05-23', 8, 1.05, 100.00, 'NIFTY 100 TRI', 48000.00, 125.6000, 'Very High'),
(4, 2, 'ICICI Prudential Value Discovery Direct Growth', 'Equity - Value', '2004-08-16', 8, 0.95, 5000.00, 'NIFTY 500 TRI', 39000.00, 345.1000, 'Very High'),
(5, 3, 'Nippon India Small Cap Fund Direct Growth', 'Equity - Small Cap', '2010-09-16', 20, 0.65, 5000.00, 'NIFTY Smallcap 250 TRI', 52000.00, 165.2500, 'Very High'),
(6, 3, 'Nippon India Multi Cap Fund Direct Growth', 'Equity - Multi Cap', '2005-03-28', 15, 0.85, 5000.00, 'NIFTY 500 Multicap 50:25:25 TRI', 31000.00, 220.4000, 'Very High'),
(7, 4, 'SBI Small Cap Fund Direct Growth', 'Equity - Small Cap', '2009-09-09', 22, 0.70, 5000.00, 'NIFTY Smallcap 250 TRI', 37000.00, 195.8000, 'Very High'),
(8, 4, 'SBI Contra Fund Direct Growth', 'Equity - Contra', '1999-07-05', 27, 0.80, 5000.00, 'NIFTY 500 TRI', 35500.00, 385.1200, 'Very High'),
(9, 5, 'Axis Bluechip Fund Direct Growth', 'Equity - Large Cap', '2010-01-05', 4, 0.60, 500.00, 'NIFTY 100 TRI', 42000.00, 58.7500, 'Very High'),
(10, 5, 'Axis Midcap Fund Direct Growth', 'Equity - Mid Cap', '2011-02-18', 9, 0.55, 500.00, 'NIFTY Midcap 150 TRI', 38500.00, 92.3000, 'Very High'),
(11, 6, 'Kotak Emerging Equity Fund Direct Growth', 'Equity - Mid Cap', '2007-03-30', 12, 0.50, 5000.00, 'NIFTY Midcap 150 TRI', 45000.00, 145.6000, 'Very High'),
(12, 6, 'Kotak Flexicap Fund Direct Growth', 'Equity - Flexi Cap', '1998-09-11', 12, 0.70, 5000.00, 'NIFTY 500 TRI', 51000.00, 88.2500, 'Very High'),
(13, 7, 'Mirae Asset Large Cap Fund Direct Growth', 'Equity - Large Cap', '2008-04-04', 18, 0.55, 5000.00, 'NIFTY 100 TRI', 37000.00, 112.4500, 'Very High'),
(14, 7, 'Mirae Asset Emerging Bluechip Fund Direct Growth', 'Equity - Large & Mid Cap', '2010-07-09', 18, 0.65, 5000.00, 'NIFTY Large Midcap 250 TRI', 33000.00, 175.9000, 'Very High'),
(15, 8, 'UTI Flexi Cap Fund Direct Growth', 'Equity - Flexi Cap', '1992-05-18', 25, 0.95, 5000.00, 'NIFTY 500 TRI', 28000.00, 265.3000, 'Very High'),
(16, 8, 'UTI Nifty 50 Index Fund Direct Growth', 'Equity - Index', '2000-03-06', 25, 0.20, 5000.00, 'NIFTY 50 TRI', 19500.00, 145.1000, 'High'),
(17, 1, 'HDFC Liquid Fund Direct Growth', 'Debt - Liquid', '2002-01-15', 1, 0.25, 500.00, 'NIFTY Liquid Index', 12500.00, 38.4200, 'Low'),
(18, 4, 'SBI Magnum Gilt Fund Direct Growth', 'Debt - Gilt', '2000-06-10', 22, 0.40, 5000.00, 'NIFTY All Duration G-Sec Index', 8500.00, 45.1500, 'Medium')
ON CONFLICT DO NOTHING;

-- ============================================================================
-- 10) EMPLOYEE_SCHEME
-- ============================================================================
INSERT INTO employee_scheme (employee_id, scheme_id, role, assigned_date) VALUES
(3, 1, 'Lead Portfolio Manager', '2013-09-11'),
(1, 2, 'Lead Portfolio Manager', '2007-06-25'),
(8, 3, 'ED & Lead Manager', '2008-05-23'),
(8, 4, 'ED & Lead Manager', '2004-08-16'),
(20, 5, 'Lead Portfolio Manager', '2010-09-16'),
(15, 6, 'ED & Lead Manager', '2005-03-28'),
(22, 7, 'ED & Lead Manager', '2009-09-09'),
(27, 8, 'Lead Portfolio Manager', '1999-07-05'),
(2, 1, 'Co-Fund Manager (Debt Portfolio)', '2021-06-01'),
(9, 3, 'Co-Fund Manager (Debt Portfolio)', '2021-06-01'),
(16, 6, 'Co-Fund Manager (Debt Portfolio)', '2021-06-01'),
(23, 8, 'Co-Fund Manager (Debt Portfolio)', '2021-06-01')
ON CONFLICT DO NOTHING;

-- ============================================================================
-- 11) ASSET (market_id left NULL for now; filled after market_data insert)
-- ============================================================================
INSERT INTO asset (asset_id, asset_name, asset_value, market_id, asset_type, company_id) VALUES
(1, 'HDFC Bank Ltd. Equity Share', 10, NULL, 'EQUITY', 1001),
(2, 'ICICI Bank Ltd. Equity Share', 2, NULL, 'EQUITY', 1002),
(3, 'State Bank of India Equity Share', 1, NULL, 'EQUITY', 1003),
(4, 'Bajaj Finance Ltd. Equity Share', 2, NULL, 'EQUITY', 1004),
(5, 'HDFC AMC Ltd. Equity Share', 5, NULL, 'EQUITY', 1005),
(6, 'TCS Ltd. Equity Share', 1, NULL, 'EQUITY', 2001),
(7, 'Infosys Ltd. Equity Share', 5, NULL, 'EQUITY', 2002),
(8, 'Sun Pharma Industries Ltd. Equity Share', 1, NULL, 'EQUITY', 3001),
(9, 'Cipla Ltd. Equity Share', 2, NULL, 'EQUITY', 3002),
(10, 'Poly Medicure Ltd. Equity Share', 10, NULL, 'EQUITY', 3003),
(11, 'Apollo Hospitals Enterprise Ltd. Equity Share', 5, NULL, 'EQUITY', 3004),
(12, 'Dr. Lal PathLabs Ltd. Equity Share', 10, NULL, 'EQUITY', 3005),
(13, 'Nestle India Ltd. Equity Share', 1, NULL, 'EQUITY', 4001),
(14, 'ITC Ltd. Equity Share', 1, NULL, 'EQUITY', 4002),
(15, 'Tata Motors Ltd. Equity Share', 2, NULL, 'EQUITY', 5001),
(16, 'DLF Ltd. Equity Share', 2, NULL, 'EQUITY', 6001)
ON CONFLICT DO NOTHING;

-- ============================================================================
-- 12) MARKET_DATA
-- ============================================================================
INSERT INTO market_data (market_id, asset_id, date, open_price, low_price, high_price, close_price, volume) VALUES
(1, 1, '2022-06-15', 1343.25, 1329.75, 1370.25, 1350.00, 1545678),
(2, 1, '2023-06-15', 1592.00, 1576.00, 1624.00, 1600.00, 1569134),
(3, 1, '2024-06-15', 1542.25, 1526.75, 1573.25, 1550.00, 1592590),
(4, 1, '2025-06-15', 1492.50, 1477.50, 1522.50, 1500.00, 1616046),
(5, 1, '2026-03-15', 1641.75, 1625.25, 1674.75, 1650.00, 1639502),
(6, 2, '2022-06-15', 716.40, 709.20, 730.80, 720.00, 1891356),
(7, 2, '2023-06-15', 925.35, 916.05, 943.95, 930.00, 1914812),
(8, 2, '2024-06-15', 1104.45, 1093.35, 1126.65, 1110.00, 1938268),
(9, 2, '2025-06-15', 1144.25, 1132.75, 1167.25, 1150.00, 1961724),
(10, 2, '2026-03-15', 1213.90, 1201.70, 1238.30, 1220.00, 1985180),
(11, 3, '2022-06-15', 457.70, 453.10, 466.90, 460.00, 2237034),
(12, 3, '2023-06-15', 567.15, 561.45, 578.55, 570.00, 2260490),
(13, 3, '2024-06-15', 805.95, 797.85, 822.15, 810.00, 2283946),
(14, 3, '2025-06-15', 776.10, 768.30, 791.70, 780.00, 2307402),
(15, 3, '2026-03-15', 825.85, 817.55, 842.45, 830.00, 2330858),
(16, 4, '2022-06-15', 5572.00, 5516.00, 5684.00, 5600.00, 2582712),
(17, 4, '2023-06-15', 7064.50, 6993.50, 7206.50, 7100.00, 2606168),
(18, 4, '2024-06-15', 7164.00, 7092.00, 7308.00, 7200.00, 2629624),
(19, 4, '2025-06-15', 6865.50, 6796.50, 7003.50, 6900.00, 2653080),
(20, 4, '2026-03-15', 7263.50, 7190.50, 7409.50, 7300.00, 2676536),
(21, 5, '2022-06-15', 1840.75, 1822.25, 1877.75, 1850.00, 2928390),
(22, 5, '2023-06-15', 1940.25, 1920.75, 1979.25, 1950.00, 2951846),
(23, 5, '2024-06-15', 3681.50, 3644.50, 3755.50, 3700.00, 2975302),
(24, 5, '2025-06-15', 3582.00, 3546.00, 3654.00, 3600.00, 2998758),
(25, 5, '2026-03-15', 3930.25, 3890.75, 4009.25, 3950.00, 3022214),
(26, 6, '2022-06-15', 3084.50, 3053.50, 3146.50, 3100.00, 3274068),
(27, 6, '2023-06-15', 3193.95, 3161.85, 3258.15, 3210.00, 3297524),
(28, 6, '2024-06-15', 3830.75, 3792.25, 3907.75, 3850.00, 3320980),
(29, 6, '2025-06-15', 3880.50, 3841.50, 3958.50, 3900.00, 3344436),
(30, 6, '2026-03-15', 4129.25, 4087.75, 4212.25, 4150.00, 3367892),
(31, 7, '2022-06-15', 1412.90, 1398.70, 1441.30, 1420.00, 3619746),
(32, 7, '2023-06-15', 1283.55, 1270.65, 1309.35, 1290.00, 3643202),
(33, 7, '2024-06-15', 1482.55, 1467.65, 1512.35, 1490.00, 3666658),
(34, 7, '2025-06-15', 1592.00, 1576.00, 1624.00, 1600.00, 3690114),
(35, 7, '2026-03-15', 1711.40, 1694.20, 1745.80, 1720.00, 3713570),
(36, 8, '2022-06-15', 825.85, 817.55, 842.45, 830.00, 3965424),
(37, 8, '2023-06-15', 975.10, 965.30, 994.70, 980.00, 3988880),
(38, 8, '2024-06-15', 1512.40, 1497.20, 1542.80, 1520.00, 4012336),
(39, 8, '2025-06-15', 1542.25, 1526.75, 1573.25, 1550.00, 4035792),
(40, 8, '2026-03-15', 1611.90, 1595.70, 1644.30, 1620.00, 4059248),
(41, 9, '2022-06-15', 915.40, 906.20, 933.80, 920.00, 4311102),
(42, 9, '2023-06-15', 1004.95, 994.85, 1025.15, 1010.00, 4334558),
(43, 9, '2024-06-15', 1442.75, 1428.25, 1471.75, 1450.00, 4358014),
(44, 9, '2025-06-15', 1472.60, 1457.80, 1502.20, 1480.00, 4381470),
(45, 9, '2026-03-15', 1522.35, 1507.05, 1552.95, 1530.00, 4404926),
(46, 10, '2022-06-15', 845.75, 837.25, 862.75, 850.00, 4656780),
(47, 10, '2023-06-15', 1094.50, 1083.50, 1116.50, 1100.00, 4680236),
(48, 10, '2024-06-15', 1641.75, 1625.25, 1674.75, 1650.00, 4703692),
(49, 10, '2025-06-15', 1741.25, 1723.75, 1776.25, 1750.00, 4727148),
(50, 10, '2026-03-15', 1910.40, 1891.20, 1948.80, 1920.00, 4750604),
(51, 11, '2022-06-15', 3781.00, 3743.00, 3857.00, 3800.00, 5002458),
(52, 11, '2023-06-15', 4875.50, 4826.50, 4973.50, 4900.00, 5025914),
(53, 11, '2024-06-15', 6069.50, 6008.50, 6191.50, 6100.00, 5049370),
(54, 11, '2025-06-15', 5771.00, 5713.00, 5887.00, 5800.00, 5072826),
(55, 11, '2026-03-15', 6268.50, 6205.50, 6394.50, 6300.00, 5096282),
(56, 12, '2022-06-15', 2089.50, 2068.50, 2131.50, 2100.00, 5348136),
(57, 12, '2023-06-15', 2039.75, 2019.25, 2080.75, 2050.00, 5371592),
(58, 12, '2024-06-15', 2587.00, 2561.00, 2639.00, 2600.00, 5395048),
(59, 12, '2025-06-15', 2437.75, 2413.25, 2486.75, 2450.00, 5418504),
(60, 12, '2026-03-15', 2736.25, 2708.75, 2791.25, 2750.00, 5441960),
(61, 13, '2022-06-15', 1741.25, 1723.75, 1776.25, 1750.00, 5693814),
(62, 13, '2023-06-15', 2189.00, 2167.00, 2233.00, 2200.00, 5717270),
(63, 13, '2024-06-15', 2487.50, 2462.50, 2537.50, 2500.00, 5740726),
(64, 13, '2025-06-15', 2388.00, 2364.00, 2436.00, 2400.00, 5764182),
(65, 13, '2026-03-15', 2567.10, 2541.30, 2618.70, 2580.00, 5787638),
(66, 14, '2022-06-15', 263.67, 261.02, 268.97, 265.00, 6039492),
(67, 14, '2023-06-15', 437.80, 433.40, 446.60, 440.00, 6062948),
(68, 14, '2024-06-15', 427.85, 423.55, 436.45, 430.00, 6086404),
(69, 14, '2025-06-15', 407.95, 403.85, 416.15, 410.00, 6109860),
(70, 14, '2026-03-15', 452.72, 448.17, 461.82, 455.00, 6133316),
(71, 15, '2022-06-15', 407.95, 403.85, 416.15, 410.00, 6385170),
(72, 15, '2023-06-15', 557.20, 551.60, 568.40, 560.00, 6408626),
(73, 15, '2024-06-15', 975.10, 965.30, 994.70, 980.00, 6432082),
(74, 15, '2025-06-15', 925.35, 916.05, 943.95, 930.00, 6455538),
(75, 15, '2026-03-15', 1014.90, 1004.70, 1035.30, 1020.00, 6478994),
(76, 16, '2022-06-15', 318.40, 315.20, 324.80, 320.00, 6730848),
(77, 16, '2023-06-15', 477.60, 472.80, 487.20, 480.00, 6754304),
(78, 16, '2024-06-15', 835.80, 827.40, 852.60, 840.00, 6777760),
(79, 16, '2025-06-15', 786.05, 778.15, 801.85, 790.00, 6801216),
(80, 16, '2026-03-15', 890.52, 881.57, 908.42, 895.00, 6824672),
(81, 4, '2024-03-01', 6800.00, 6750.00, 7100.00, 6950.00, 1250000),
(82, 7, '2024-03-01', 1420.00, 1400.00, 1480.00, 1455.00, 2100000),
(83, 9, '2024-03-01', 980.00, 965.00, 1020.00, 1005.00, 980000),
(84, 15, '2024-03-01', 940.00, 925.00, 990.00, 965.00, 3200000),
(85, 16, '2024-03-01', 820.00, 810.00, 860.00, 845.00, 1800000)
ON CONFLICT DO NOTHING;

-- Backfill asset.market_id to point to latest (2026-03-15) market_data row per asset
UPDATE asset SET market_id = 5  WHERE asset_id = 1;
UPDATE asset SET market_id = 10 WHERE asset_id = 2;
UPDATE asset SET market_id = 15 WHERE asset_id = 3;
UPDATE asset SET market_id = 20 WHERE asset_id = 4;
UPDATE asset SET market_id = 25 WHERE asset_id = 5;
UPDATE asset SET market_id = 30 WHERE asset_id = 6;
UPDATE asset SET market_id = 35 WHERE asset_id = 7;
UPDATE asset SET market_id = 40 WHERE asset_id = 8;
UPDATE asset SET market_id = 45 WHERE asset_id = 9;
UPDATE asset SET market_id = 50 WHERE asset_id = 10;
UPDATE asset SET market_id = 55 WHERE asset_id = 11;
UPDATE asset SET market_id = 60 WHERE asset_id = 12;
UPDATE asset SET market_id = 65 WHERE asset_id = 13;
UPDATE asset SET market_id = 70 WHERE asset_id = 14;
UPDATE asset SET market_id = 75 WHERE asset_id = 15;
UPDATE asset SET market_id = 80 WHERE asset_id = 16;

-- ============================================================================
-- 13) FUNDAMENTAL_DATA
-- ============================================================================
INSERT INTO fundamental_data (fundamental_id, company_id, pe_ratio, pb_ratio, eps, revenue_growth, debt_to_equity, roe, roce, dividend_yield, market_cap_category, last_quarter) VALUES
(1, 1001, 17.50, 2.80, 85.40, 0.1450, 0.90, 0.1620, 0.1480, 0.0110, 'LARGE CAP', 'Q4-2025'),
(2, 1002, 16.20, 3.10, 68.20, 0.1680, 0.85, 0.1810, 0.1550, 0.0090, 'LARGE CAP', 'Q4-2025'),
(3, 1003, 9.50, 1.40, 82.10, 0.1120, 1.10, 0.1540, 0.1320, 0.0210, 'LARGE CAP', 'Q4-2025'),
(4, 1004, 28.40, 6.20, 245.50, 0.2150, 1.25, 0.2240, 0.1980, 0.0050, 'LARGE CAP', 'Q4-2025'),
(5, 1005, 32.10, 11.40, 115.30, 0.1850, 0.00, 0.2850, 0.3420, 0.0180, 'LARGE CAP', 'Q4-2025'),
(6, 2001, 26.80, 12.50, 128.40, 0.0820, 0.05, 0.3950, 0.4850, 0.0240, 'LARGE CAP', 'Q4-2025'),
(7, 2002, 22.40, 8.50, 64.10, 0.0650, 0.02, 0.2920, 0.3680, 0.0280, 'LARGE CAP', 'Q4-2025'),
(8, 3001, 31.50, 4.80, 48.50, 0.1180, 0.08, 0.1480, 0.1620, 0.0070, 'LARGE CAP', 'Q4-2025'),
(9, 3002, 24.20, 3.40, 52.10, 0.0950, 0.12, 0.1380, 0.1450, 0.0120, 'LARGE CAP', 'Q4-2025'),
(10, 3003, 45.10, 7.80, 38.20, 0.2240, 0.15, 0.1850, 0.2120, 0.0030, 'MID CAP', 'Q4-2025'),
(11, 3004, 54.20, 9.10, 108.40, 0.1540, 0.35, 0.1650, 0.1780, 0.0040, 'LARGE CAP', 'Q4-2025'),
(12, 3005, 41.80, 8.40, 61.30, 0.1080, 0.02, 0.1980, 0.2450, 0.0060, 'MID CAP', 'Q4-2025'),
(13, 4001, 68.40, 22.10, 35.80, 0.0780, 0.04, 0.9540, 1.1240, 0.0140, 'LARGE CAP', 'Q4-2025'),
(14, 4002, 24.80, 14.20, 16.50, 0.0910, 0.00, 0.5240, 0.6480, 0.0345, 'LARGE CAP', 'Q4-2025'),
(15, 5001, 18.20, 4.50, 56.40, 0.2850, 1.45, 0.2180, 0.1850, 0.0080, 'LARGE CAP', 'Q4-2025'),
(16, 6001, 48.50, 5.10, 18.20, 0.1820, 0.40, 0.1020, 0.1140, 0.0030, 'LARGE CAP', 'Q4-2025')
ON CONFLICT DO NOTHING;

-- ============================================================================
-- 14) ANALYSIS
-- ============================================================================
INSERT INTO analysis (analysis_id, asset_id, analysis_date, signal, duration, entry_price, stoploss, target_price, analyst_id) VALUES
(1, 1, '2026-03-10', 'BUY', '09:15:00', 1600.00, 1540.00, 1780.00, 5),
(2, 2, '2026-03-12', 'BUY', '09:15:00', 1200.00, 1150.00, 1350.00, 11),
(3, 6, '2026-03-13', 'HOLD', '09:15:00', 4100.00, 3950.00, 4300.00, 17),
(4, 8, '2026-03-14', 'BUY', '09:15:00', 1600.00, 1540.00, 1800.00, 18),
(5, 15, '2026-03-15', 'BUY', '11:00:00', 990.00, 940.00, 1100.00, 24)
ON CONFLICT DO NOTHING;

-- ============================================================================
-- 15) TECHNICAL_DATA
-- ============================================================================
INSERT INTO technical_data (technical_id, analysis_id, market_id, rsi, moving_average, fvg, candle_type, candle_pattern, trend_direction, support_level, resistance_level) VALUES
(1, 1, 5, 62.50, 1580.00, 1.2500, 'Hammer', 'Bullish Reversal', 'BULLISH', 1540.00, 1680.00),
(2, 2, 10, 58.20, 1170.00, 0.0000, 'Marubozu', 'Strong Bullish Marubozu', 'BULLISH', 1150.00, 1250.00),
(3, 3, 30, 49.80, 4050.00, 0.0000, 'Doji', 'Sideways Channel', 'SIDEWAYS', 3950.00, 4250.00),
(4, 4, 40, 64.30, 1540.00, 2.1000, 'Hammer', 'Ascending Triangle', 'BULLISH', 1500.00, 1650.00),
(5, 5, 75, 61.20, 970.00, 1.5000, 'Hammer', 'Inverse Head & Shoulders', 'BULLISH', 930.00, 1050.00),
(6, 1, 81, 22.50, 3280.00, 1.0000, 'BEARISH', 'HAMMER', 'BEARISH', 3180.00, 3520.00),
(7, 2, 82, 27.30, 1190.00, 1.0000, 'BEARISH', 'MORNING_STAR', 'BEARISH', 1140.00, 1280.00),
(8, 3, 83, 78.40, 475.00, 0.0000, 'BULLISH', 'SHOOTING_STAR', 'BULLISH', 440.00, 520.00),
(9, 4, 84, 82.10, 1700.00, 0.0000, 'BULLISH', 'BEARISH_ENGULF', 'BULLISH', 1620.00, 1820.00),
(10, 5, 85, 74.60, 620.00, 0.0000, 'BULLISH', 'DOJI', 'BULLISH', 590.00, 680.00)
ON CONFLICT DO NOTHING;

-- ============================================================================
-- 16) ALGORITHM
-- ============================================================================
INSERT INTO algorithm (algorithm_id, analysis_id, strategy_name, logic, risk_level) VALUES
(1, 1, 'EMA Crossover Strategy', 'Triggers BUY signal when 20 EMA crosses above 50 EMA on daily charts with RSI > 50 and strong Fair Value Gap (FVG) confirmation.', 'Medium'),
(2, 2, 'Mean Reversion Strategy', 'Triggers BUY when stock price touches lower Bollinger Band and RSI is oversold (< 35), aiming to catch rebounds to the 20-period moving average.', 'Medium'),
(3, 4, 'Pharma Sector Momentum Strategy', 'Triggers BUY on top pharmaceutical stocks exhibiting breakout above 52-week resistance levels with increased volumes and high ROE backing.', 'High')
ON CONFLICT DO NOTHING;

-- ============================================================================
-- 17) ALGORITHM_ANALYSIS (bridge)
-- ============================================================================
INSERT INTO algorithm_analysis (analysis_id, fundamental_id) VALUES
(1, 1),
(2, 2),
(3, 6),
(4, 8),
(5, 15)
ON CONFLICT DO NOTHING;

-- ============================================================================
-- 18) ALGORITHM_FUNDAMENTAL_DATA (bridge)
-- ============================================================================
INSERT INTO algorithm_fundamental_data (algorithm_id, fundamental_id) VALUES
(1, 1),
(1, 6),
(2, 2),
(3, 8)
ON CONFLICT DO NOTHING;

-- ============================================================================
-- 19) ALGORITHM_MARKET_DATA (bridge)
-- ============================================================================
INSERT INTO algorithm_market_data (algorithm_id, market_id) VALUES
(1, 5),
(1, 30),
(2, 10),
(3, 40)
ON CONFLICT DO NOTHING;

-- ============================================================================
-- 20) SCHEME_HOLDING
-- ============================================================================
INSERT INTO scheme_holding (scheme_id, asset_id, quantity, allocation_percentage, avg_price) VALUES
(1, 1, 1200000.0000, 45.00, 1450.00),
(1, 2, 1500000.0000, 35.00, 850.00),
(1, 3, 1000000.0000, 20.00, 520.00),
(2, 15, 800000.0000, 60.00, 480.00),
(2, 16, 1200000.0000, 40.00, 380.00),
(3, 6, 500000.0000, 100.00, 3300.00),
(4, 7, 1000000.0000, 100.00, 1350.00),
(5, 10, 300000.0000, 55.00, 950.00),
(5, 12, 150000.0000, 45.00, 2100.00),
(7, 11, 200000.0000, 100.00, 4200.00),
(8, 14, 1800000.0000, 100.00, 310.00)
ON CONFLICT DO NOTHING;

-- ============================================================================
-- 21) SCHEME_POSITION
-- ============================================================================
INSERT INTO scheme_position (portfolio_id, scheme_id, unit, avg_nav) VALUES
(2, 3, 398.0891, 125.60),
(3, 1, 118.8919, 420.55),
(3, 3, 398.0891, 125.60),
(3, 5, 302.5718, 165.25),
(4, 1, 118.8915, 420.55),
(6, 3, 398.0891, 125.60),
(7, 1, 475.5677, 420.55),
(7, 8, 519.3186, 385.12),
(8, 5, 363.0861, 165.25),
(10, 8, 259.6593, 385.12),
(11, 4, 289.7710, 345.10),
(12, 1, 237.7838, 420.55),
(13, 2, 284.9814, 175.45),
(13, 7, 255.3626, 195.80),
(14, 3, 1592.3566, 125.60),
(9, 9, 800.0000, 55.20),
(10, 10, 450.0000, 85.50),
(11, 11, 600.0000, 138.00),
(12, 12, 700.0000, 82.00),
(13, 13, 500.0000, 105.00),
(14, 14, 350.0000, 165.00),
(15, 15, 550.0000, 250.00),
(5, 16, 85.0000, 130.00),
(5, 2, 170.9888, 145.20),
(5, 4, 86.9313, 380.50)
ON CONFLICT DO NOTHING;

-- ============================================================================
-- 22) SCHEME_TRANSACTION
-- NOTE: exact day-of-month was truncated in source screenshot; 15th assumed
-- to match the pattern seen elsewhere. Verify/correct if exact dates known.
-- ============================================================================
INSERT INTO scheme_transaction (txn_id, scheme_id, asset_id, txn_type, txn_date) VALUES
(1, 1, 1, 'BUY', '2023-01-15'),
(2, 1, 2, 'BUY', '2023-01-15'),
(3, 1, 3, 'BUY', '2023-01-15'),
(4, 2, 15, 'BUY', '2023-07-15'),
(5, 2, 16, 'BUY', '2023-07-15'),
(6, 3, 6, 'BUY', '2024-01-15'),
(7, 4, 7, 'BUY', '2024-01-15'),
(8, 5, 10, 'BUY', '2024-08-15'),
(9, 5, 12, 'BUY', '2024-08-15'),
(10, 7, 11, 'BUY', '2024-09-15'),
(11, 8, 14, 'BUY', '2025-01-15')
ON CONFLICT DO NOTHING;

-- ============================================================================
-- 23) INVESTMENT_POSITION
-- ============================================================================
INSERT INTO investment_position (portfolio_id, asset_id, quantity, avg_price) VALUES
(1, 1, 100.0000, 1350.00),
(1, 2, 200.0000, 720.00),
(1, 6, 20.0000, 3210.00),
(5, 1, 50.0000, 1600.00),
(7, 6, 250.0000, 3210.00),
(7, 13, 100.0000, 2500.00),
(9, 8, 150.0000, 980.00),
(10, 3, 200.0000, 570.00),
(12, 3, 150.0000, 780.00),
(14, 1, 300.0000, 1500.00),
(14, 4, 50.0000, 6900.00),
(15, 10, 50.0000, 1750.00),
(15, 11, 20.0000, 5800.00),
(15, 12, 30.0000, 2450.00),
(5, 6, 20.0000, 3850.00),
(5, 8, 100.0000, 1780.00)
ON CONFLICT DO NOTHING;

-- ============================================================================
-- 24) TRANSACTIONS
-- ============================================================================
INSERT INTO transactions (transaction_id, portfolio_id, asset_id, scheme_id, quantity, amount, transaction_type, transaction_date, transaction_status) VALUES
(1, 1, 1, NULL, 100.0000, 135000.00, 'BUY', '2022-06-15', 'COMPLETED'),
(2, 1, 2, NULL, 200.0000, 144000.00, 'BUY', '2022-06-15', 'COMPLETED'),
(3, 1, 6, NULL, 20.0000, 64200.00, 'BUY', '2023-06-15', 'COMPLETED'),
(4, 2, NULL, 3, 398.0891, 50000.00, 'BUY', '2023-06-15', 'COMPLETED'),
(5, 3, 1, NULL, 118.8919, 50000.00, 'BUY', '2022-06-15', 'COMPLETED'),
(6, 3, NULL, 3, 398.0891, 50000.00, 'BUY', '2023-06-15', 'COMPLETED'),
(7, 3, NULL, 5, 302.5718, 50000.00, 'BUY', '2024-06-15', 'COMPLETED'),
(8, 4, 1, NULL, 23.7783, 10000.00, 'BUY', '2023-01-15', 'COMPLETED'),
(9, 4, 1, NULL, 23.7783, 10000.00, 'BUY', '2023-02-15', 'COMPLETED'),
(10, 4, 1, NULL, 23.7783, 10000.00, 'BUY', '2023-03-15', 'COMPLETED'),
(11, 4, 1, NULL, 23.7783, 10000.00, 'BUY', '2023-04-15', 'COMPLETED'),
(12, 4, 1, NULL, 23.7783, 10000.00, 'BUY', '2023-05-15', 'COMPLETED'),
(13, 5, 1, NULL, 50.0000, 80000.00, 'ASSET', '2023-06-15', 'COMPLETED'),
(14, 5, NULL, 2, 170.9888, 30000.00, 'SCHEME', '2023-06-15', 'COMPLETED'),
(15, 5, NULL, 4, 86.9313, 30000.00, 'SCHEME', '2024-06-15', 'COMPLETED'),
(16, 6, NULL, 3, 398.0891, 50000.00, 'BUY', '2023-06-15', 'COMPLETED'),
(17, 7, 6, NULL, 250.0000, 802500.00, 'BUY', '2023-06-15', 'COMPLETED'),
(18, 7, NULL, 6, 2268.6025, 500000.00, 'BUY', '2024-06-15', 'COMPLETED'),
(19, 8, NULL, 7, 1021.4504, 200000.00, 'BUY', '2024-06-15', 'COMPLETED'),
(20, 9, 8, NULL, 150.0000, 147000.00, 'BUY', '2023-06-15', 'COMPLETED'),
(21, 10, 3, NULL, 200.0000, 114000.00, 'BUY', '2023-06-15', 'COMPLETED'),
(22, 10, NULL, 8, 259.6593, 100000.00, 'BUY', '2025-06-15', 'COMPLETED'),
(23, 11, NULL, 4, 289.7710, 100000.00, 'BUY', '2025-06-15', 'COMPLETED'),
(24, 12, 3, NULL, 150.0000, 117000.00, 'BUY', '2025-06-15', 'COMPLETED'),
(25, 12, NULL, 1, 237.7838, 100000.00, 'BUY', '2025-06-15', 'COMPLETED'),
(26, 13, NULL, 2, 284.9814, 50000.00, 'BUY', '2024-06-15', 'COMPLETED'),
(27, 13, NULL, 7, 255.3626, 50000.00, 'BUY', '2024-06-15', 'COMPLETED'),
(28, 14, 1, NULL, 300.0000, 450000.00, 'BUY', '2025-06-15', 'COMPLETED'),
(29, 14, 4, NULL, 50.0000, 345000.00, 'BUY', '2025-06-15', 'COMPLETED'),
(30, 14, NULL, 3, 1592.3566, 200000.00, 'BUY', '2025-06-15', 'COMPLETED'),
(31, 15, 10, NULL, 50.0000, 87500.00, 'BUY', '2025-06-15', 'COMPLETED'),
(32, 15, 11, NULL, 20.0000, 116000.00, 'BUY', '2025-06-15', 'COMPLETED'),
(33, 15, 12, NULL, 30.0000, 73500.00, 'BUY', '2025-06-15', 'COMPLETED'),
(34, 5, NULL, 1, 118.8919, 50000.00, 'SCHEME', '2026-02-15', 'FAILED'),
(35, 5, 1, NULL, 50.0000, 82500.00, 'ASSET', '2024-03-12', 'COMPLETED'),
(36, 5, NULL, 15, 100.0000, 25000.00, 'SCHEME', '2024-06-20', 'COMPLETED'),
(37, 5, 6, NULL, 20.0000, 77000.00, 'ASSET', '2024-11-05', 'COMPLETED'),
(38, 5, NULL, 15, 60.0000, 15000.00, 'SCHEME', '2025-01-18', 'COMPLETED'),
(39, 5, 8, NULL, 100.0000, 178000.00, 'ASSET', '2025-05-22', 'COMPLETED'),
(40, 5, NULL, 16, 85.0000, 30000.00, 'SCHEME', '2025-08-30', 'COMPLETED'),
(41, 5, 1, NULL, 30.0000, 50000.00, 'ASSET', '2026-02-10', 'COMPLETED'),
(42, 5, NULL, 16, 40.0000, 12000.00, 'SCHEME', '2026-04-15', 'COMPLETED'),
(43, 1, 1, NULL, 10.0000, 15000.00, 'BUY', '2021-03-15', 'COMPLETED'),
(44, 1, 2, NULL, 15.0000, 22000.00, 'BUY', '2021-09-10', 'COMPLETED'),
(45, 1, NULL, 1, NULL, 18000.00, 'BUY', '2022-01-20', 'COMPLETED'),
(46, 1, 1, NULL, 5.0000, 8000.00, 'SELL', '2022-08-05', 'COMPLETED'),
(47, 1, 3, NULL, 20.0000, 35000.00, 'BUY', '2023-04-12', 'COMPLETED'),
(48, 2, 2, NULL, 8.0000, 12000.00, 'BUY', '2020-06-18', 'COMPLETED'),
(49, 2, NULL, 2, NULL, 25000.00, 'BUY', '2020-11-22', 'COMPLETED'),
(50, 2, 1, NULL, 12.0000, 19000.00, 'BUY', '2021-05-30', 'COMPLETED'),
(51, 2, 2, NULL, 6.0000, 9500.00, 'SELL', '2022-02-14', 'COMPLETED'),
(52, 2, NULL, 3, NULL, 30000.00, 'BUY', '2023-07-08', 'COMPLETED'),
(53, 3, 3, NULL, 25.0000, 40000.00, 'BUY', '2019-08-25', 'COMPLETED'),
(54, 3, 1, NULL, 18.0000, 28000.00, 'BUY', '2020-03-10', 'COMPLETED'),
(55, 3, NULL, 1, NULL, 22000.00, 'BUY', '2021-01-15', 'COMPLETED'),
(56, 3, 2, NULL, 10.0000, 16000.00, 'BUY', '2022-06-20', 'COMPLETED'),
(57, 3, 3, NULL, 8.0000, 13000.00, 'SELL', '2023-09-05', 'COMPLETED'),
(58, 3, NULL, 2, NULL, 18000.00, 'BUY', '2024-02-28', 'COMPLETED'),
(59, 7, 1, NULL, 30.0000, 48000.00, 'BUY', '2020-05-12', 'COMPLETED'),
(60, 7, 2, NULL, 22.0000, 35000.00, 'BUY', '2021-02-18', 'COMPLETED'),
(61, 7, NULL, 3, NULL, 42000.00, 'BUY', '2021-10-30', 'COMPLETED'),
(62, 7, 3, NULL, 15.0000, 24000.00, 'BUY', '2022-04-22', 'COMPLETED'),
(63, 7, 1, NULL, 10.0000, 16000.00, 'SELL', '2023-01-08', 'COMPLETED'),
(64, 7, NULL, 1, NULL, 55000.00, 'BUY', '2024-05-15', 'COMPLETED'),
(65, 10, 2, NULL, 14.0000, 21000.00, 'BUY', '2021-04-08', 'COMPLETED'),
(66, 10, NULL, 2, NULL, 16000.00, 'BUY', '2021-11-25', 'COMPLETED'),
(67, 10, 1, NULL, 9.0000, 14000.00, 'BUY', '2022-07-14', 'COMPLETED'),
(68, 10, 3, NULL, 7.0000, 11000.00, 'SELL', '2023-03-20', 'COMPLETED'),
(69, 10, NULL, 1, NULL, 28000.00, 'BUY', '2024-08-10', 'COMPLETED')
ON CONFLICT DO NOTHING;

COMMIT;

-- ============================================================================
-- END OF DATA INSERTION SCRIPT
-- ============================================================================
