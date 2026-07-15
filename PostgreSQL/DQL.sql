
--1. Find which employee (fund manager) has schemes that are in profit and
--   which ones are in loss/underperforming.
SELECT e.employee_name AS fund_manager,
       f.scheme_name,
       f.nav,
       f.aum,
       f.risk_level,
       CASE
           WHEN f.nav > 100 THEN 'High Performing'
           WHEN f.nav BETWEEN 50 AND 100 THEN 'Moderate'
           ELSE 'Underperforming'
       END AS performance_tag
FROM fund_scheme f
JOIN employee e ON e.employee_id = f.fund_manager_id
ORDER BY e.employee_name, f.nav DESC;


--2. Find total AUM under management for each fund manager, ranked from
--   best to worst manager by AUM.
SELECT e.employee_name AS fund_manager,
       COUNT(f.scheme_id) AS schemes_handled,
       SUM(f.aum) AS total_aum_managed,
       ROUND(AVG(f.nav), 2) AS avg_nav
FROM fund_scheme f
JOIN employee e ON e.employee_id = f.fund_manager_id
GROUP BY e.employee_name
ORDER BY total_aum_managed DESC;


--3. Find which scheme_type investors are putting the most money into
--   (helps AMC decide which type of new fund to launch).
SELECT f.scheme_type,
       COUNT(DISTINCT sp.portfolio_id) AS num_investors,
       SUM(sp.unit * sp.avg_nav) AS total_invested_amount
FROM scheme_position sp
JOIN fund_scheme f ON f.scheme_id = sp.scheme_id
GROUP BY f.scheme_type
ORDER BY total_invested_amount DESC;


--4. Find AMC-wise total investor count and total AUM
--   (identify which AMC is most trusted/popular).
SELECT a.amc_name, COUNT(DISTINCT sp.portfolio_id) AS total_investors, SUM(f.aum) AS total_aum
FROM fund_scheme f
JOIN amc a ON a.amc_id = f.amc_id
JOIN scheme_position sp ON sp.scheme_id = f.scheme_id
GROUP BY a.amc_name
ORDER BY total_aum DESC;


--5. Get an investor's portfolio breakdown — how much money is allocated
--   to which asset/stock and how much to which mutual fund scheme.
SELECT 'STOCK' AS investment_type, a.asset_name AS name, ip.quantity, ip.avg_price,
       (ip.quantity * ip.avg_price) AS invested_value
FROM investment_position ip
JOIN asset a ON a.asset_id = ip.asset_id
JOIN portfolio p ON p.portfolio_id = ip.portfolio_id
WHERE p.investor_id = 5

UNION ALL

SELECT 'MUTUAL FUND' AS investment_type, f.scheme_name AS name, sp.unit, sp.avg_nav,
       (sp.unit * sp.avg_nav) AS invested_value
FROM scheme_position sp
JOIN fund_scheme f ON f.scheme_id = sp.scheme_id
JOIN portfolio p ON p.portfolio_id = sp.portfolio_id
WHERE p.investor_id = 5

ORDER BY invested_value DESC;


--6. Find an investor's mutual fund profit/loss
--   (current value vs invested/average cost).
SELECT i.investor_name, f.scheme_name,
       sp.unit, sp.avg_nav AS bought_at_nav, f.nav AS current_nav,
       ROUND((f.nav - sp.avg_nav) * sp.unit, 2) AS profit_loss_amount,
       ROUND(((f.nav - sp.avg_nav) / sp.avg_nav) * 100, 2) AS profit_loss_percent
FROM scheme_position sp
JOIN fund_scheme f ON f.scheme_id = sp.scheme_id
JOIN portfolio p ON p.portfolio_id = sp.portfolio_id
JOIN investor i ON i.investor_id = p.investor_id
WHERE i.investor_id = 5
ORDER BY profit_loss_amount DESC;


--7. Find investor id 5's transactions over the last 3 years, grouped as
--   stock vs mutual fund, with year-wise total amount.
SELECT EXTRACT(YEAR FROM t.transaction_date) AS txn_year,
       t.transaction_type,
       COUNT(*) AS num_transactions,
       SUM(t.amount) AS total_amount
FROM transactions t
JOIN portfolio p ON p.portfolio_id = t.portfolio_id
WHERE p.investor_id = 5
  AND t.transaction_status = 'COMPLETED'
  AND t.transaction_date >= (CURRENT_DATE - INTERVAL '3 years')
GROUP BY EXTRACT(YEAR FROM t.transaction_date), t.transaction_type
ORDER BY txn_year DESC, t.transaction_type;


--8. Find the best investment option — Low/Medium risk schemes with the
--   highest AUM and good NAV (to help investor decision-making).
SELECT scheme_name, risk_level, aum, nav, expense_ratio
FROM fund_scheme
WHERE risk_level IN ('Low', 'Medium')
ORDER BY aum DESC, nav DESC
LIMIT 10;


--9. Find which sector is currently growing
--   (based on companies' revenue_growth, averaged sector-wise).
SELECT s.sector_name,
       ROUND(AVG(fd.revenue_growth), 4) AS avg_revenue_growth,
       COUNT(DISTINCT c.company_id) AS num_companies
FROM fundamental_data fd
JOIN company c ON c.company_id = fd.company_id
JOIN industry ind ON ind.industry_id = c.industry_id
JOIN sector s ON s.sector_id = ind.sector_id
WHERE fd.last_quarter = (SELECT MAX(last_quarter) FROM fundamental_data)
GROUP BY s.sector_name
ORDER BY avg_revenue_growth DESC;


--10. Find sector-wise average P/E ratio
--    (to identify undervalued vs overvalued sectors).
SELECT s.sector_name, ROUND(AVG(fd.pe_ratio), 2) AS avg_pe_ratio
FROM fundamental_data fd
JOIN company c ON c.company_id = fd.company_id
JOIN industry ind ON ind.industry_id = c.industry_id
JOIN sector s ON s.sector_id = ind.sector_id
GROUP BY s.sector_name
ORDER BY avg_pe_ratio ASC;


--11. Find assets where a BUY signal was generated but the investor has
--    not taken an entry (Fundamental/Technical analysis suggested BUY,
--    but investor 5 has no transaction/position in that asset).
SELECT DISTINCT a.asset_id, a.asset_name, an.signal, an.analysis_date,
       an.entry_price, an.target_price, an.stoploss
FROM analysis an
JOIN asset a ON a.asset_id = an.asset_id
WHERE an.signal = 'BUY'
  AND a.asset_id NOT IN (
      SELECT ip.asset_id
      FROM investment_position ip
      JOIN portfolio p ON p.portfolio_id = ip.portfolio_id
      WHERE p.investor_id = 5
  )
ORDER BY an.analysis_date DESC;


--12. Find cases where the algorithm did not say BUY, but the investor
--    entered on their own and is currently in profit
--    (investor 5's current holdings where the latest signal was not
--    BUY — SELL/HOLD or no analysis at all — but current market price
--    is greater than the average buy price).
SELECT a.asset_name, ip.quantity, ip.avg_price,
       md.close_price AS current_price,
       ROUND((md.close_price - ip.avg_price) * ip.quantity, 2) AS profit_amount,
       COALESCE(an.signal, 'NO SIGNAL') AS algorithm_signal
FROM investment_position ip
JOIN asset a ON a.asset_id = ip.asset_id
JOIN portfolio p ON p.portfolio_id = ip.portfolio_id
JOIN LATERAL (
    SELECT close_price FROM market_data m
    WHERE m.asset_id = ip.asset_id
    ORDER BY m.date DESC LIMIT 1
) md ON true
LEFT JOIN LATERAL (
    SELECT signal FROM analysis an2
    WHERE an2.asset_id = ip.asset_id
    ORDER BY an2.analysis_date DESC LIMIT 1
) an ON true
WHERE p.investor_id = 5
  AND (an.signal IS NULL OR an.signal != 'BUY')
  AND md.close_price > ip.avg_price
ORDER BY profit_amount DESC;


--13. Find the best employee-managed scheme by risk-adjusted return
--    (which fund manager generates the most efficient "low expense
--    ratio + high NAV" combo).
SELECT e.employee_name, f.scheme_name, f.nav, f.expense_ratio,
       ROUND(f.nav / NULLIF(f.expense_ratio, 0), 2) AS efficiency_score
FROM fund_scheme f
JOIN employee e ON e.employee_id = f.fund_manager_id
ORDER BY efficiency_score DESC
LIMIT 5;


--14. Find an investor's portfolio diversification score — which sectors
--    the portfolio is spread across (a diversification check; too much
--    money in one sector is risky).
SELECT s.sector_name, COUNT(DISTINCT a.asset_id) AS num_assets_held,
       SUM(ip.quantity * ip.avg_price) AS invested_in_sector
FROM investment_position ip
JOIN asset a ON a.asset_id = ip.asset_id
JOIN company c ON c.company_id = a.company_id
JOIN industry ind ON ind.industry_id = c.industry_id
JOIN sector s ON s.sector_id = ind.sector_id
JOIN portfolio p ON p.portfolio_id = ip.portfolio_id
WHERE p.investor_id = 5
GROUP BY s.sector_name
ORDER BY invested_in_sector DESC;


--15. Find an investor's risk appetite profile — based on the risk_level
--    of the schemes they've invested in, classify the investor as
--    Conservative/Balanced/Aggressive.
SELECT i.investor_name, f.risk_level, COUNT(*) AS scheme_count,
       SUM(sp.unit * sp.avg_nav) AS invested_amount
FROM scheme_position sp
JOIN fund_scheme f ON f.scheme_id = sp.scheme_id
JOIN portfolio p ON p.portfolio_id = sp.portfolio_id
JOIN investor i ON i.investor_id = p.investor_id
WHERE i.investor_id = 5
GROUP BY i.investor_name, f.risk_level
ORDER BY invested_amount DESC;


--16. Find assets with an RSI-based Oversold/Overbought signal.
SELECT DISTINCT ON (a.asset_id)
       a.asset_name, t.rsi, t.trend_direction,
       CASE
           WHEN t.rsi < 30 THEN 'Oversold - Buy Opportunity'
           WHEN t.rsi > 70 THEN 'Overbought - Sell Warning'
       END AS rsi_signal
FROM technical_data t
JOIN market_data m ON m.market_id = t.market_id
JOIN asset a ON a.asset_id = m.asset_id
WHERE t.rsi < 30 OR t.rsi > 70
ORDER BY a.asset_id, t.rsi;


--17. Find investor loyalty score — how long an investor has been
--    invested for, and classify them as New/Regular/Loyal.
SELECT
    i.investor_name,
    MIN(t.transaction_date) AS first_investment_date,
    MAX(t.transaction_date) AS last_investment_date,
    COUNT(*) AS total_transactions,
    ROUND(SUM(t.amount), 2) AS lifetime_invested,
    DATE_PART('year', AGE(MAX(t.transaction_date),
        MIN(t.transaction_date))) AS years_active,
    CASE
        WHEN DATE_PART('year', AGE(MAX(t.transaction_date),
            MIN(t.transaction_date))) >= 3 THEN 'Loyal Investor'
        WHEN DATE_PART('year', AGE(MAX(t.transaction_date),
            MIN(t.transaction_date))) >= 1 THEN 'Regular Investor'
        ELSE 'New Investor'
    END AS loyalty_tag
FROM investor i
JOIN portfolio p ON p.investor_id = i.investor_id
JOIN transactions t ON t.portfolio_id = p.portfolio_id
WHERE t.transaction_status = 'COMPLETED'
GROUP BY i.investor_name
ORDER BY lifetime_invested DESC;


--18. Compare scheme popularity vs performance — does a popular scheme
--    also perform well?
SELECT
    f.scheme_name,
    f.risk_level,
    f.aum,
    f.nav,
    COUNT(DISTINCT sp.portfolio_id) AS investor_count,
    ROUND(AVG(sp.unit * sp.avg_nav), 2) AS avg_invested_per_investor,
    RANK() OVER (ORDER BY f.aum DESC) AS popularity_rank,
    RANK() OVER (ORDER BY f.nav DESC) AS performance_rank,
    CASE
        WHEN RANK() OVER (ORDER BY f.aum DESC) <= 5
             AND RANK() OVER (ORDER BY f.nav DESC) <= 5
        THEN 'Popular AND Performing'
        WHEN RANK() OVER (ORDER BY f.aum DESC) <= 5
        THEN 'Popular but Underperforming'
        WHEN RANK() OVER (ORDER BY f.nav DESC) <= 5
        THEN 'Performing but Undiscovered'
        ELSE 'Average'
    END AS scheme_category
FROM fund_scheme f
LEFT JOIN scheme_position sp ON sp.scheme_id = f.scheme_id
GROUP BY f.scheme_id, f.scheme_name, f.risk_level, f.aum, f.nav
ORDER BY popularity_rank;


--19. Dead Capital Detector — money is invested but there is no
--    movement (stagnant portfolios).
SELECT
    i.investor_name,
    i.investor_type,
    p.invested_amount,
    p.liquid_cash,
    MAX(t.transaction_date) AS last_transaction_date,
    CURRENT_DATE - MAX(t.transaction_date) AS days_since_last_txn,
    ROUND(p.liquid_cash /
        NULLIF(p.invested_amount + p.liquid_cash, 0) * 100, 2) AS idle_cash_pct,
    CASE
        WHEN CURRENT_DATE - MAX(t.transaction_date) > 365
             AND p.liquid_cash > p.invested_amount * 0.3
        THEN 'Dead Capital — Immediate Action Needed'
        WHEN CURRENT_DATE - MAX(t.transaction_date) > 180
        THEN 'Inactive — Follow Up Required'
        ELSE 'Active'
    END AS capital_status
FROM investor i
JOIN portfolio p ON p.investor_id = i.investor_id
JOIN transactions t ON t.portfolio_id = p.portfolio_id
WHERE t.transaction_status = 'COMPLETED'
GROUP BY i.investor_name, i.investor_type, p.invested_amount, p.liquid_cash
ORDER BY days_since_last_txn DESC;


--20. Complete Asset Report — a full 360° view of a single asset
--    (Market + Technical + Fundamental + Algorithm combined).
SELECT
    a.asset_name,

    -- Market Data
    md.close_price AS current_price,
    md.volume AS traded_volume,

    -- Technical Signal
    t.rsi,
    t.trend_direction,
    t.support_level,
    t.resistance_level,

    -- Fundamental Health
    fd.pe_ratio,
    fd.revenue_growth,
    fd.eps,

    -- Algorithm Decision
    an.signal AS algo_signal,
    an.entry_price,
    an.target_price,
    an.stoploss,

    -- Combined Verdict
    CASE
        WHEN an.signal = 'BUY'
             AND t.rsi < 50
             AND fd.revenue_growth > 0
        THEN 'STRONG BUY'
        WHEN an.signal = 'BUY'
        THEN 'BUY'
        WHEN an.signal = 'SELL'
             AND t.rsi > 70
             AND fd.revenue_growth < 0
        THEN 'STRONG SELL'
        WHEN an.signal = 'SELL'
        THEN 'SELL'
        ELSE 'HOLD'
    END AS combined_verdict

FROM asset a
JOIN LATERAL (
    SELECT close_price, volume FROM market_data m
    WHERE m.asset_id = a.asset_id
    ORDER BY m.date DESC LIMIT 1
) md ON true
JOIN LATERAL (
    SELECT rsi, trend_direction, support_level, resistance_level
    FROM technical_data t2
    JOIN market_data m2 ON m2.market_id = t2.market_id
    WHERE m2.asset_id = a.asset_id
    ORDER BY m2.date DESC LIMIT 1
) t ON true
JOIN LATERAL (
    SELECT pe_ratio, revenue_growth, eps
    FROM fundamental_data fd2
    JOIN company c ON c.company_id = fd2.company_id
    JOIN asset a2 ON a2.asset_name LIKE '%' || c.company_name || '%'
    WHERE a2.asset_id = a.asset_id
    ORDER BY fd2.last_quarter DESC LIMIT 1
) fd ON true
JOIN LATERAL (
    SELECT signal, entry_price, target_price, stoploss
    FROM analysis an2
    WHERE an2.asset_id = a.asset_id
    ORDER BY an2.analysis_date DESC LIMIT 1
) an ON true
ORDER BY a.asset_name;
