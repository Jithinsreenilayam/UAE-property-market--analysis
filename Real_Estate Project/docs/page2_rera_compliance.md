# DAX Measures — Page 2: RERA & Compliance Intelligence

All measures below apply to the `uae_properties_clean` table.  
**Important:** Create the `rera_status` calculated column first — every other measure on this page depends on it.

---

## Step 1 — Calculated Column (Required First)

```dax
-- Table: uae_properties_clean
-- This column classifies every row as RERA Registered or Non-RERA
-- The CSV stores 0 or NULL for unregistered; both are handled here.

rera_status =
    IF(
        ISBLANK(uae_properties_clean[rera]) || uae_properties_clean[rera] = 0,
        "Non-RERA",
        "RERA Registered"
    )
```

---

## KPI Card Measures

```dax
-- [KPI 1] Total Listings
Total Listings = COUNTROWS(uae_properties_clean)


-- [KPI 2] RERA Registered Count
RERA Listings =
    CALCULATE(
        COUNTROWS(uae_properties_clean),
        uae_properties_clean[rera_status] = "RERA Registered"
    )


-- [KPI 3] RERA Compliance Rate (format as: 0.0%)
RERA Compliance Rate =
    DIVIDE([RERA Listings], [Total Listings])


-- [KPI 4] RERA Average Price (format as: AED #,##0)
RERA Avg Price =
    CALCULATE(
        AVERAGE(uae_properties_clean[price]),
        uae_properties_clean[rera_status] = "RERA Registered"
    )


-- [KPI 5] Non-RERA Average Price (format as: AED #,##0)
Non-RERA Avg Price =
    CALCULATE(
        AVERAGE(uae_properties_clean[price]),
        uae_properties_clean[rera_status] = "Non-RERA"
    )


-- [KPI 6] RERA Price Premium % (format as: 0%)
-- Shows the % by which RERA avg price exceeds non-RERA avg price
RERA Price Premium % =
    DIVIDE(
        [RERA Avg Price] - [Non-RERA Avg Price],
        [Non-RERA Avg Price]
    )
```

---

## Compliance Rate by Emirate (Horizontal Bar Chart)

```dax
-- Use this as the bar value; set city on the axis
-- The measure automatically calculates rate within each city's filter context

City RERA Rate =
    DIVIDE(
        CALCULATE(
            COUNTROWS(uae_properties_clean),
            uae_properties_clean[rera_status] = "RERA Registered"
        ),
        COUNTROWS(uae_properties_clean)
    )
-- Format as: 0.0%
-- Add a reference line at [RERA Compliance Rate] (market average = 65.7%)
```

---

## Price Gap Matrix (RERA vs Non-RERA by Bedroom Type)

```dax
-- Base measure — works in any filter context (bedroom_category row, rera_status column)
Avg Price =
    AVERAGE(uae_properties_clean[price])


-- Price Premium column in the matrix (add as an extra column measure)
RERA vs NonRERA Premium % =
    DIVIDE(
        CALCULATE([Avg Price], uae_properties_clean[rera_status] = "RERA Registered")
        - CALCULATE([Avg Price], uae_properties_clean[rera_status] = "Non-RERA"),
        CALCULATE([Avg Price], uae_properties_clean[rera_status] = "Non-RERA")
    )
-- Format as: +0%;-0%;0%
```

---

## Donut Chart (RERA Split)

```dax
-- Use [RERA Listings] and a Non-RERA count together
Non-RERA Listings =
    CALCULATE(
        COUNTROWS(uae_properties_clean),
        uae_properties_clean[rera_status] = "Non-RERA"
    )

-- In the donut visual: Values = [RERA Listings] and [Non-RERA Listings]
-- Or use rera_status column as Legend with COUNT(id) as Values — simpler approach
```

---

## Tile Slicer Setup

```
Slicer field : listing_year (calculated column)
Style        : Tile → Horizontal
Selection    : Single + "All" option enabled
Active tile  : Gold fill (#C9A84C background, navy text)
```

---

## Page-Level Filter Recommendation

Added a Tile Slicer using `Year` with options:
- Select All
- 2022
- 2023
- 2024

This single slicer drives all 7 visuals on Page 2 simultaneously.
