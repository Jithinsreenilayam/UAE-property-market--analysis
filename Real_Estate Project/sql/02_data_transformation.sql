/* ============================================================
   UAE PROPERTY MARKET ANALYSIS
   Dataset: uae_properties.xlsx  |  492 listings across UAE
   Tools: MySQL 8.0+  +  Power BI Desktop
   ============================================================
   FILE 02 — DATA TRANSFORMATION
   Purpose : Cast raw string columns to their correct data
             types, parse dates, validate the RERA field,
             and strip commas from price values.
             Output: uae_properties_transform
   Depends : 01_data_inspection.sql (raw table must exist)
   ============================================================ */

USE uae_property_db;

/* ── 1. Create the typed staging table ── */
CREATE TABLE uae_properties_transform (
    id             BIGINT,
    title          TEXT,
    displayAddress TEXT,
    bathrooms      INT,
    bedrooms       INT,
    addedOn        DATE,
    type           TEXT,
    rera           BIGINT,
    propertyType   TEXT,
    price          BIGINT
);

/* ── 2. Insert with type-cast transformations ── */
INSERT INTO uae_properties_transform
SELECT
    -- Cast ID to unsigned integer; NULL if blank
    CAST(NULLIF(id, '') AS UNSIGNED),

    title,
    displayAddress,

    -- Cast bathrooms and bedrooms; NULL if blank
    CAST(NULLIF(bathrooms, '') AS UNSIGNED),
    CAST(NULLIF(bedrooms,  '') AS UNSIGNED),

    -- Parse ISO 8601 date string to DATE (takes first 10 chars: YYYY-MM-DD)
    STR_TO_DATE(LEFT(addedOn, 10), '%Y-%m-%d'),

    type,

    -- RERA: keep only purely numeric values; anything else becomes NULL
    CASE
        WHEN rera REGEXP '^[0-9]+$' THEN CAST(rera AS UNSIGNED)
        ELSE NULL
    END,

    propertyType,

    -- Price: strip commas (e.g. "1,200,000" → 1200000), then cast
    CAST(NULLIF(REPLACE(price, ',', ''), '') AS UNSIGNED)

FROM uae_properties;

/* ── 3. Widen displayAddress to support string operations in next stage ── */
ALTER TABLE uae_properties_transform
MODIFY displayAddress VARCHAR(200);

/* ── 4. Verify transformation output ── */
SELECT * FROM uae_properties_transform LIMIT 5;
