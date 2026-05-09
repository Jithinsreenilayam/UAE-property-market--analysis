# Data Dictionary — UAE Property Market Analysis

This document describes every field in the dataset at each stage of the pipeline: raw, transformed, and cleaned.

---

## Stage 1 — Raw Table: `uae_properties`

| Field | Data Type | Nullable | Description | Example |
|---|---|---|---|---|
| `id` | BIGINT | No | Unique listing identifier from the source portal | `10837871` |
| `title` | TEXT | No | Listing title — typically project name + area | `"Sobha One, Sobha Hartland"` |
| `displayAddress` | TEXT | No | Full comma-separated address string used to extract city and area | `"Sobha One, Sobha Hartland, Mohammed Bin Rashid City, Dubai"` |
| `bathrooms` | INT | Yes | Number of bathrooms in the unit | `2` |
| `bedrooms` | INT | Yes | Number of bedrooms. `0` indicates a studio apartment | `3` |
| `addedOn` | TEXT (raw) | Yes | Listing publication datetime in ISO 8601 format with timezone | `"2024-01-06T17:05:24+00:00"` |
| `type` | TEXT | No | Transaction type. All records in this dataset = `'buy'` | `"buy"` |
| `rera` | TEXT (raw) | Yes | RERA (Real Estate Regulatory Agency) registration number. NULL = unregistered listing | `"817185656"` |
| `propertyType` | TEXT | No | Property category. All records = `'apartment'` | `"apartment"` |
| `price` | TEXT (raw) | No | Listed price in AED. May contain commas in raw form | `"3,950,000"` |

---

## Stage 2 — Transformed Table: `uae_properties_transform`

Type-safe intermediate table. All fields cast to correct SQL types.

| Field | Data Type | Transformation Applied |
|---|---|---|
| `id` | BIGINT | `CAST(NULLIF(id, '') AS UNSIGNED)` |
| `title` | TEXT | No change |
| `displayAddress` | VARCHAR(200) | No change (column widened via ALTER) |
| `bathrooms` | INT | `CAST(NULLIF(bathrooms, '') AS UNSIGNED)` |
| `bedrooms` | INT | `CAST(NULLIF(bedrooms, '') AS UNSIGNED)` |
| `addedOn` | DATE | `STR_TO_DATE(LEFT(addedOn, 10), '%Y-%m-%d')` — extracts date portion from ISO timestamp |
| `type` | TEXT | No change |
| `rera` | BIGINT | `CASE WHEN rera REGEXP '^[0-9]+$' THEN CAST(rera AS UNSIGNED) ELSE NULL END` — non-numeric RERA values set to NULL |
| `propertyType` | TEXT | No change |
| `price` | BIGINT | `CAST(NULLIF(REPLACE(price, ',', ''), '') AS UNSIGNED)` — removes commas, casts to integer |

---

## Stage 3 — Clean Table: `uae_properties_clean`

Final analytical table. Contains all original fields plus 12 engineered features. This is the primary source for Power BI.

### Original Fields (cleaned)

| Field | Data Type | Description |
|---|---|---|
| `id` | BIGINT (PK) | Unique listing identifier. Primary key with index. |
| `title` | TEXT | Trimmed listing title |
| `display_address` | TEXT | Trimmed full address string |
| `bathrooms` | INT | Number of bathrooms |
| `bedrooms` | INT | Number of bedrooms (0 = Studio) |
| `type` | TEXT | Transaction type ('buy') |
| `property_type` | TEXT | Property category ('apartment') |
| `rera` | BIGINT | RERA registration number. NULL = unregistered |
| `price` | BIGINT | Listed price in AED |

### Engineered Features

| Field | Data Type | Logic | Business Purpose |
|---|---|---|---|
| `bedroom_category` | VARCHAR | `CASE WHEN bedrooms=0 THEN 'Studio' WHEN bedrooms IN (1,2) THEN '1-2 BR' WHEN bedrooms=3 THEN '3 BR' ELSE '4+ BR' END` | Groups bedrooms for segment analysis and chart readability |
| `listing_date` | DATE | `DATE(addedOn)` | Clean date for time-series analysis |
| `listing_year` | INT | `YEAR(DATE(addedOn))` | Year dimension for annual filtering |
| `listing_month` | INT | `MONTH(DATE(addedOn))` | Month number for sorting |
| `listing_month_name` | VARCHAR | `MONTHNAME(DATE(addedOn))` | Human-readable month label for charts |
| `year__month` | VARCHAR | `DATE_FORMAT(DATE(addedOn), '%Y-%m')` | YYYY-MM string for time-series X-axis (e.g. `2024-02`) |
| `city` | VARCHAR | `TRIM(SUBSTRING_INDEX(displayAddress, ',', -1))` | Last segment after final comma in address |
| `area` | VARCHAR | `TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(displayAddress, ',', -2), ',', 1))` | Second-to-last address segment |
| `price_m_aed` | DECIMAL | `ROUND(price / 1000000, 2)` | Price in millions for concise display |
| `price_tier` | VARCHAR | `CASE WHEN price < 500K THEN 'Under 500K' ... ELSE 'Above 5M' END` | Five price brackets for tier distribution analysis |
| `price_per_bedroom` | BIGINT | `CASE WHEN bedrooms > 0 THEN ROUND(price/bedrooms, 0) ELSE NULL END` | Affordability metric. NULL for studios to avoid misleading avg |

---

## Analytical View

### `vw_listings_detail`
Full clean listing record — used as Power BI drill-through source.

Contains all 21 fields from `uae_properties_clean` without aggregation.

---

## RERA Field Notes

The `rera` field is central to regulatory compliance analysis and requires special handling:

- **Raw format:** Mixed numeric string and NULL values
- **Validation:** `REGEXP '^[0-9]+$'` ensures only valid numeric RERA codes are retained
- **NULL meaning:** A NULL `rera` value means the listing is **not registered** with the Real Estate Regulatory Agency — not that the data is missing
- **Compliance status derivation:** `IF(ISBLANK(rera), "Non-RERA", "RERA Registered")` — created as a calculated column in Power BI
- **UAE context:** Dubai mandates RERA registration for all listed properties (100% in dataset). Other emirates have varying levels of adoption.

---

*Last updated: 2024 | UAE Property Market Analysis Project*
