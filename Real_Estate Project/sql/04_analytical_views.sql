/* ============================================================
   UAE PROPERTY MARKET ANALYSIS
   Dataset: uae_properties.xlsx  |  492 listings across UAE
   Tools: MySQL 8.0+  +  Power BI Desktop
   ============================================================
   FILE 04 — ANALYTICAL VIEWS FOR POWER BI
   Purpose : Pre-aggregate the clean table into 8 views that
             are imported directly into Power BI Desktop.
             Each view answers a specific analytical question.

 
   Depends : 03_data_cleaning.sql  (uae_properties_clean must exist)
   ============================================================ */

USE uae_property_db;


/* ── VIEW : Full clean listing table  */
CREATE OR REPLACE VIEW vw_listings_detail AS
SELECT
    id, title, display_address, city, area,
    bedrooms, bedroom_category, bathrooms,
    price, price_m_aed, price_tier, price_per_bedroom,
    listing_date, listing_year, listing_month_name,
    year__month, property_type, type, rera
FROM uae_properties_clean;

-- Verify
SELECT * FROM vw_listings_detail LIMIT 5;


/* ── Final verification: list all views created ──────────────── */
SELECT TABLE_NAME, TABLE_TYPE
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = DATABASE()
  AND TABLE_TYPE   = 'VIEW'
ORDER BY TABLE_NAME;
