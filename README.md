# Machine Maintenance & Failure Analytics

## Project Overview

This project analyzes machine operating, failure, tool-wear, and maintenance data using **SQL and Microsoft Power BI**.

The objective is to identify patterns associated with machine failures and develop an interactive dashboard that can support machine-health monitoring and preventive maintenance decisions.

## Tools Used

- SQL
- Microsoft Power Query
- Microsoft Power BI

## Dataset

The dataset contains **10,000 machine records** with information related to:

- Product type
- Machine failure
- Air temperature
- Process temperature
- Rotational speed
- Torque
- Tool wear
- Maintenance cost

## Power BI Dashboard

The Power BI dashboard provides an interactive overview of machine health and failure patterns.

### Key Performance Indicators

| KPI | Value |
|---|---:|
| Total Machines | 10,000 |
| Failed Machines | 339 |
| Failure Rate | 3.39% |
| Average Torque | 39.99 Nm |
| Average Tool Wear | 107.95 min |

### Dashboard Analysis

The dashboard includes:

- Failed Machines by Product Type
- Average Torque by Failure Status
- Average Tool Wear by Failure Status
- Failed Machines by Tool Wear Status
- Average Maintenance Cost by Failure Status
- Machine-level risk details
- Interactive filters for Failure Status, Product Type, and Tool Wear Category

## Key Findings

- **339 out of 10,000 machines failed**, resulting in an overall failure rate of **3.39%**.
- **L-type machines recorded the highest number of failures (235)**, followed by M-type machines (83) and H-type machines (21).
- Failed machines had a higher average torque of **50.17 Nm**, compared with **39.63 Nm** for non-failed machines.
- Failed machines had higher average tool wear of **143.78 min**, compared with **106.69 min** for non-failed machines.
- Among failed machines, **118 had tool wear above 200 minutes**, while 221 had tool wear at or below 200 minutes.
- Average maintenance cost was **2,754.62** for failed machines and **2,741.03** for non-failed machines.

## Interactivity

The dashboard contains slicers that allow users to investigate the data by:

- Failure Status
- Product Type
- Tool Wear Category

These filters interact with the dashboard visuals and machine-level details table.

## Outcome

The analysis shows that failed machines have higher average torque and tool wear than non-failed machines, while product type also shows noticeable differences in failure counts.

The dashboard provides a visual and interactive way to investigate machine-health patterns and can support **data-driven preventive maintenance decisions**.
