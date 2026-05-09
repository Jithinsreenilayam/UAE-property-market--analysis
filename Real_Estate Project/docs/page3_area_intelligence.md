# DAX Measures — Page 3: Area Intelligence & Investment Lens

All measures apply to `uae_properties_clean`.  
The `rera_status` calculated column from Page 2 is also used here — ensure it exists before building Page 3.

---

## KPI Card Measures

```dax
-- [KPI 1] Premium Area Name
-- Returns the area name with the highest average price (min 3 listings)
Premium Area =
    VAR AreaTable =
        FILTER(
            ADDCOLUMNS(
                VALUES(uae_properties_clean[area]),
                "AvgP", CALCULATE(AVERAGE(uae_properties_clean[price])),
                "Cnt",  CALCULATE(COUNTROWS(uae_properties_clean))
            ),
            [Cnt] >= 3
        )
    RETURN
        MAXX(TOPN(1, AreaTable, [AvgP], DESC), uae_properties_clean[area])


-- [KPI 2] Best Value Area Name
-- Returns the area with the lowest avg price per bedroom (min 3 listings)
Best Value Area =
    VAR AreaTable =
        FILTER(
            ADDCOLUMNS(
                VALUES(uae_properties_clean[area]),
                "AvgPPB", CALCULATE(
                    AVERAGEX(
                        FILTER(uae_properties_clean, uae_properties_clean[bedrooms] > 0),
                        uae_properties_clean[price] / uae_properties_clean[bedrooms]
                    )
                ),
                "Cnt", CALCULATE(COUNTROWS(uae_properties_clean))
            ),
            [Cnt] >= 3
        )
    RETURN
        MAXX(TOPN(1, AreaTable, [AvgPPB], ASC), uae_properties_clean[area])


-- [KPI 3] Largest Supply Area Name
-- Area with the most listings
Largest Supply Area =
    VAR AreaTable =
        ADDCOLUMNS(
            VALUES(uae_properties_clean[area]),
            "Cnt", CALCULATE(COUNTROWS(uae_properties_clean))
        )
    RETURN
        MAXX(TOPN(1, AreaTable, [Cnt], DESC), uae_properties_clean[area])


-- [KPI 4] Price Spread Ratio (Max area avg / Min area avg, min 3 listings)
-- Format as: 0.0"×"   → displays as e.g. 26.2×
Price Spread Ratio =
    VAR AreaSummary =
        FILTER(
            ADDCOLUMNS(
                VALUES(uae_properties_clean[area]),
                "AvgP", CALCULATE(AVERAGE(uae_properties_clean[price])),
                "Cnt",  CALCULATE(COUNTROWS(uae_properties_clean))
            ),
            [Cnt] >= 3
        )
    RETURN
        DIVIDE(
            MAXX(AreaSummary, [AvgP]),
            MINX(AreaSummary, [AvgP])
        )
```

---

## Scatter Chart Measures

```dax
-- X Axis: listing volume per area
Area Listing Count = COUNTROWS(uae_properties_clean)


-- Y Axis: average price per area
Area Avg Price = AVERAGE(uae_properties_clean[price])


-- Size field: same as X axis (in Power BI Scatter, put [Area Listing Count] in both X Axis and Size)
```

**Scatter chart setup:**
- Details = `area`
- X Axis = `[Area Listing Count]`
- Y Axis = `[Area Avg Price]`
- Size = `[Area Listing Count]`
- Legend = `city`
- Color by city: Dubai = Gold, Abu Dhabi = Blue, Sharjah = Green, RAK = Red, Ajman = Grey
- Add constant line on X = overall avg listing count per area
- Add constant line on Y = `[Area Avg Price]` with ALL filter removed (market average)
- Enable zoom slider

---

## Top 10 Premium Areas Table

```dax
-- Rank measure (add as a column in the Table visual)
Area Rank by Avg Price =
    RANKX(
        FILTER(
            ALL(uae_properties_clean[area]),
            CALCULATE(COUNTROWS(uae_properties_clean)) >= 3
        ),
        CALCULATE(AVERAGE(uae_properties_clean[price])),
        ,
        DESC,
        DENSE
    )
```

**Table setup:**
- Columns: `[Area Rank by Avg Price]`, `area`, `city`, `[Area Avg Price]`, `[Area Listing Count]`
- Visual-level filter: `[Area Rank by Avg Price]` is ≤ 10
- Add data bars on the avg price column (gold colour)
- Apply conditional formatting on city column to show pill badges

---

## Best Value Areas Bar Chart

```dax
-- Core measure: avg price per bedroom (studios excluded — bedrooms = 0 are filtered out)
Avg Price Per Bedroom =
    AVERAGEX(
        FILTER(uae_properties_clean, uae_properties_clean[bedrooms] > 0),
        uae_properties_clean[price] / uae_properties_clean[bedrooms]
    )
-- Format as: AED #,##0
```

**Horizontal bar chart setup:**
- Axis = `area`
- Value = `[Avg Price Per Bedroom]`
- Visual filter: `[Area Listing Count]` >= 3
- Apply BOTTOM N 8 filter by `[Avg Price Per Bedroom]` (show lowest 8 areas)
- Colour gradient: green for lowest values, transitioning to gold for highest shown
- Sort: ascending (lowest price/BR at top)

---

## Price per Bedroom by Emirate (Column Chart)

```dax
-- Same [Avg Price Per Bedroom] measure, but with city on the axis
-- Power BI will automatically aggregate at city level when city is placed on X axis
-- No additional measure needed — just use [Avg Price Per Bedroom] with city on axis
```

**Column chart setup:**
- X Axis = `city`
- Y Value = `[Avg Price Per Bedroom]`
- Sort: descending
- Dubai bar = Gold, others = Blue scale
- Data labels ON, format: AED #,##0

---
## City Slicer

```
Slicer field : city and Year
Style        : Tile → Horizontal
Placement    : Top-right of the page (cross-filters all visuals)
```

---

## Notes

- The `Area Listing Count >= 3` filter is applied consistently across all area-level visuals to avoid misleading single-listing outliers skewing the analysis.
- `[Area Avg Price]` and `[Area Listing Count]` are simple measures that Power BI can aggregate at any grain (area, city, overall) depending on what field is placed on the visual axis — no separate city-level measures are needed.
- For the scatter chart quadrant labels, use Power BI text boxes positioned manually over the four quadrants — these cannot be generated by a DAX measure.
