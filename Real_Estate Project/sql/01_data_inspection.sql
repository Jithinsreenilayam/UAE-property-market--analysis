/* ============================================================
   UAE PROPERTY MARKET ANALYSIS
   Dataset: uae_properties.xlsx  |  492 listings across UAE
   Tools: MySQL 8.0+  +  Power BI Desktop
   ============================================================
   FILE 01 — DATA INSPECTION
   Purpose : Explore the raw table structure, row counts,
             null values, and distinct categorical values
             before any transformation is applied.
   ============================================================ */

/* ── Select the working database ── */
USE uae_property_db;

/* ── 1. Preview raw data ── */
SELECT * FROM uae_properties LIMIT 10;

/* ── 2. Total row count ── */
SELECT COUNT(*) AS total_rows FROM uae_properties;

/* ── 3. Inspect column data types ── */
DESCRIBE uae_properties;

/* ── 4. Null audit across all key columns ── */
SELECT
    SUM(id              IS NULL)                   AS null_id,
    SUM(title           IS NULL)                   AS null_title,
    SUM(displayAddress  IS NULL)                   AS null_address,
    SUM(bathrooms       IS NULL)                   AS null_bathrooms,
    SUM(bedrooms        IS NULL)                   AS null_bedrooms,
    SUM(addedOn         IS NULL)                   AS null_addedOn,
    SUM(rera            IS NULL OR TRIM(rera) = '') AS null_rera,
    SUM(propertyType    IS NULL)                   AS null_propertyType,
    SUM(price           IS NULL)                   AS null_price
FROM uae_properties;

/* ── 5. Distinct values for categorical columns ── */
SELECT DISTINCT type         FROM uae_properties;
SELECT DISTINCT propertyType FROM uae_properties;
SELECT DISTINCT bedrooms     FROM uae_properties ORDER BY bedrooms;

/* ── 6. Sample rows for visual inspection ── */
SELECT * FROM uae_properties LIMIT 5;
