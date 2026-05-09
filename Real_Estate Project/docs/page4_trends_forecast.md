# Page 4 — Trends & Forecast Intelligence

> **Page purpose:** Surface monthly price and volume trends from the available data, apply smoothing via moving averages, and build a transparent forecast band that communicates both direction and uncertainty — all framed with appropriate caveats for a 492-listing dataset.

---

## KPI Card Measures

```dax
-- [KPI 1] Listings in High-Volume Window (Sep 2023 – Mar 2024)
HV Period Listings =
    CALCULATE(
        COUNTROWS(uae_properties_clean),
        uae_properties_clean[listing_date] >= DATE(2023, 9, 1)
    )


-- [KPI 2] Latest Month Avg Price
-- Returns the average price for the most recent month in the current filter
Latest Month Avg Price =
    CALCULATE(
        AVERAGE(uae_properties_clean[price]),
        LASTDATE(uae_properties_clean[listing_date])
    )


-- [KPI 3] 3-Month Moving Average (latest 3 months)
-- The smoothed price signal — more stable than single-month avg
MA3 Avg Price =
    VAR LastDate = MAX(uae_properties_clean[listing_date])
    VAR StartDate = EDATE(LastDate, -2)   -- 3 months back (current + 2 prior)
    RETURN
        CALCULATE(
            AVERAGE(uae_properties_clean[price]),
            uae_properties_clean[listing_date] >= DATE(YEAR(StartDate), MONTH(StartDate), 1),
            uae_properties_clean[listing_date] <= LastDate
        )


-- [KPI 4] Price Direction (MoM — current month vs previous month)
Price MoM Change =
    VAR CurrentAvg =
        CALCULATE(
            AVERAGE(uae_properties_clean[price]),
            DATESMTD(uae_properties_clean[listing_date])
        )
    VAR PrevAvg =
        CALCULATE(
            AVERAGE(uae_properties_clean[price]),
            PREVIOUSMONTH(uae_properties_clean[listing_date])
        )
    RETURN DIVIDE(CurrentAvg - PrevAvg, PrevAvg)


-- [KPI 5] Studio vs 3BR Price Gap (latest 3-month window)
Studio 3BR Gap =
    VAR BR3Avg =
        CALCULATE(
            [MA3 Avg Price],
            uae_properties_clean[bedrooms] = 3
        )
    VAR StudioAvg =
        CALCULATE(
            [MA3 Avg Price],
            uae_properties_clean[bedrooms] = 0
        )
    RETURN DIVIDE(BR3Avg - StudioAvg, StudioAvg)
---

## Main Trend Line Chart: Monthly Avg + Moving Average

These measures power the primary dual-line chart (monthly actual price + smoothed MA).

```
--3-Month Moving Average
-- Smooths the monthly volatility caused by the small sample
3M Moving Avg Price =
    VAR CurrentMonth = MAX(uae_properties_clean[listing_date])
    VAR Window3Start =
        EDATE(
            DATE(YEAR(CurrentMonth), MONTH(CurrentMonth), 1),
            -2
        )
    RETURN
        CALCULATE(
            AVERAGE(uae_properties_clean[price]),
            FILTER(
                ALL(uae_properties_clean),
                uae_properties_clean[listing_date] >= Window3Start
                && uae_properties_clean[listing_date] <= CurrentMonth
            )
        )

---

## Volume Trend Bar Chart

```dax
-- Monthly Listing Count
Monthly Listing Count =
    COUNTROWS(uae_properties_clean)


-- Volume MoM Change
Volume MoM Change =
    VAR CurrentCount =
        CALCULATE(COUNTROWS(uae_properties_clean), DATESMTD(uae_properties_clean[listing_date]))
    VAR PrevCount =
        CALCULATE(COUNTROWS(uae_properties_clean), PREVIOUSMONTH(uae_properties_clean[listing_date]))
    RETURN DIVIDE(CurrentCount - PrevCount, PrevCount)


-- Cumulative Listings (for running total line overlay)
Cumulative Listings =
    CALCULATE(
        COUNTROWS(uae_properties_clean),
        FILTER(
            ALL(uae_properties_clean[listing_date]),
            uae_properties_clean[listing_date] <= MAX(uae_properties_clean[listing_date])
        )
    )
```


## Studio vs 3BR Divergence Line Chart

```dax
-- Studio Monthly Avg Price
Studio Monthly Avg =
    CALCULATE(
        AVERAGE(uae_properties_clean[price]),
        uae_properties_clean[bedrooms] = 0
    )


-- 3BR Monthly Avg Price
3BR Monthly Avg =
    CALCULATE(
        AVERAGE(uae_properties_clean[price]),
        uae_properties_clean[bedrooms] = 3
    )


-- 3BR vs Studio Index
3BR vs Studio Index =
    VAR StudioBase =
        CALCULATE(
            AVERAGE(uae_properties_clean[price]),
            uae_properties_clean[bedrooms] = 0,
            uae_properties_clean[listing_date] = DATE(2023, 9, 1)   -- base month
        )
    VAR Current3BR =
        CALCULATE(
            AVERAGE(uae_properties_clean[price]),
            uae_properties_clean[bedrooms] = 3
        )
    RETURN DIVIDE(Current3BR, StudioBase) * 100


-- Studio 3-Month Moving Avg
Studio MA3 =
    VAR CurrentMonth = MAX(uae_properties_clean[listing_date])
    VAR Window3Start = EDATE(DATE(YEAR(CurrentMonth), MONTH(CurrentMonth), 1), -2)
    RETURN
        CALCULATE(
            AVERAGE(uae_properties_clean[price]),
            uae_properties_clean[bedrooms] = 0,
            FILTER(
                ALL(uae_properties_clean),
                uae_properties_clean[listing_date] >= Window3Start
                && uae_properties_clean[listing_date] <= CurrentMonth
            )
        )


-- 3BR 3-Month Moving Avg
3BR MA3 =
    VAR CurrentMonth = MAX(uae_properties_clean[listing_date])
    VAR Window3Start = EDATE(DATE(YEAR(CurrentMonth), MONTH(CurrentMonth), 1), -2)
    RETURN
        CALCULATE(
            AVERAGE(uae_properties_clean[price]),
            uae_properties_clean[bedrooms] = 3,
            FILTER(
                ALL(uae_properties_clean),
                uae_properties_clean[listing_date] >= Window3Start
                && uae_properties_clean[listing_date] <= CurrentMonth
            )
        )
```

---

### Implementation in Power BI

Power BI Desktop has a built-in **Analytics pane forecast** for line charts — use it as follows:

1. Build the `[3M Moving Avg Price]` line chart with `year__month` on the axis (Sep 2023 – Mar 2024 only)
2. Open the **Analytics pane** (magnifying glass icon in Visualizations)
3. Expand **Forecast**
4. Set: Units = Months, Length = 3, Confidence interval = 68%, Seasonality = Auto
5. The forecast line and shaded band will auto-render


## Monthly Summary Table

```

-- MoM Price Change % (for colour-coded column)
MoM Price Change % =
    DIVIDE([MoM Price Change AED], [Prior Month Avg Price])
-- Format: +0.0%;-0.0%
-- Apply conditional formatting: positive = green, negative = red
```

**Summary table columns:**
`year__month` | `Monthly Listing Count` | `Monthly Avg Price`| `MoM Price Change %` | `3M Moving Avg Price`

---
