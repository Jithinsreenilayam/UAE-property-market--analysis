/* ============================================================
   UAE PROPERTY MARKET ANALYSIS
   Dataset: uae_properties.xlsx  |  492 listings across UAE
   Tools: MySQL 8.0+  +  Power BI Desktop
   ============================================================
   FILE 03 — DATA CLEANING & FEATURE ENGINEERING
   Purpose : Build the final analytical table from the typed
             staging table. Adds derived columns:
               - bedroom_category (label buckets)
               - listing_date, listing_year, listing_month,
                 listing_month_name, year__month
               - city  (extracted from displayAddress)
               - area  (extracted from displayAddress)
               - price_m_aed  (price in millions)
               - price_tier   (AED bucket label)
               - price_per_bedroom
             Filters out rows with zero price or invalid dates.
             Output: uae_properties_clean  (primary analytical table)
   Depends : 02_data_transformation.sql
   ============================================================ */

USE uae_property_db;

/* ── 1. Build the clean analytical table ── */
CREATE TABLE uae_properties_clean AS
SELECT
    /* ── Core identifiers ── */
    id,
    TRIM(title)          AS title,
    TRIM(displayAddress) AS display_address,

    /* ── Numeric fields ── */
    bathrooms,
    bedrooms,

    /* ── Bedroom category label ── */
    CASE
        WHEN bedrooms IS NULL OR bedrooms = 0 THEN 'Studio'
        WHEN bedrooms BETWEEN 1 AND 2         THEN '1-2 BR'
        WHEN bedrooms = 3                     THEN '3 BR'
        ELSE                                       '4+ BR'
    END AS bedroom_category,

    /* ── Date fields (parsed from ISO 8601 string) ── */
    DATE(addedOn)                       AS listing_date,
    YEAR(DATE(addedOn))                 AS listing_year,
    MONTH(DATE(addedOn))                AS listing_month,
    MONTHNAME(DATE(addedOn))            AS listing_month_name,
    DATE_FORMAT(DATE(addedOn), '%Y-%m') AS year__month,

    /* ── Geography: extract city (last comma segment) ── */
    TRIM(SUBSTRING_INDEX(displayAddress, ',', -1)) AS city,

    /* ── Geography: extract area (second-to-last comma segment) ── */
    TRIM(
        SUBSTRING_INDEX(
            SUBSTRING_INDEX(displayAddress, ',', -2),
            ',', 1
        )
    ) AS area,

    /* ── Listing classification ── */
    type,
    propertyType AS property_type,
    rera,

    /* ── Price fields ── */
    price,
    ROUND(price / 1000000, 2) AS price_m_aed,

    /* ── Price tier buckets ── */
    CASE
        WHEN price < 500000                    THEN 'Under 500K'
        WHEN price BETWEEN 500000  AND 999999  THEN '500K–1M'
        WHEN price BETWEEN 1000000 AND 1999999 THEN '1M–2M'
        WHEN price BETWEEN 2000000 AND 4999999 THEN '2M–5M'
        ELSE                                        'Above 5M'
    END AS price_tier,

    /* ── Price per bedroom (NULL for studios — 0 bedrooms — to avoid distortion) ── */
    CASE
        WHEN bedrooms > 0 THEN ROUND(price / bedrooms, 0)
        ELSE NULL
    END AS price_per_bedroom

FROM uae_properties_transform
WHERE
    price > 0                    -- exclude zero-price records
    AND DATE(addedOn) IS NOT NULL; -- exclude unparseable dates

/* ── 2. Add primary key for performance ── */
ALTER TABLE uae_properties_clean ADD PRIMARY KEY (id);

/* ── 3. Add indexes on columns used in GROUP BY / WHERE / JOINs ── */
CREATE INDEX idx_city     ON uae_properties_clean (city);
CREATE INDEX idx_area     ON uae_properties_clean (area);
CREATE INDEX idx_bedrooms ON uae_properties_clean (bedrooms);
CREATE INDEX idx_price    ON uae_properties_clean (price);
CREATE INDEX idx_date     ON uae_properties_clean (listing_date);

/* ── 4. Verify output ── */
SELECT COUNT(*) AS clean_rows FROM uae_properties_clean;
SELECT * FROM uae_properties_clean;
