# Brazilian E-commerce Sales and Delivery Analytics

## Project Overview

This project analyzes Brazilian e-commerce order data to understand sales performance, customer demand, delivery efficiency, product category performance, payment behavior, and review trends.

The main goal of this project was to convert raw e-commerce data into useful business insights using SQL and Power BI. The project focuses on answering business questions such as which states and categories generate the most revenue, how delivery delays affect customer experience, and which areas need operational improvement.

## Dataset Source

Dataset used: Brazilian E-commerce Public Dataset by Olist

Source: Kaggle

The dataset contains order, customer, payment, product, seller, delivery, and review information from a Brazilian e-commerce marketplace.

## Tools Used

SQL: Data cleaning, joins, aggregations, CTEs, window functions, and business analysis  
PostgreSQL: Database storage and query execution  
Power BI: Dashboard creation and visual reporting  
Excel: Basic checking and supporting analysis  

## Tables Used

orders  
customers  
order_items  
payments  
products  
reviews  
category_translation  
sellers  

## Work Done

Created a master SQL view by joining order, customer, product, payment, review, and delivery tables.

Cleaned and transformed date columns to calculate delivery days, delayed orders, and monthly revenue trends.

Analyzed sales performance by month, product category, customer state, and customer city.

Calculated key metrics such as total revenue, total orders, average delivery days, delay percentage, review score, and payment value.

Used SQL CTEs and window functions to rank categories, states, cities, and monthly revenue trends.

Built Power BI dashboard visuals for revenue trends, delivery performance, payment mix, review scores, and regional sales performance.

## Key Business Insights

Total revenue was mainly driven by a few high-performing product categories and major customer states.

São Paulo and other large states contributed strongly to overall order volume and revenue.

Delivered orders had an average delivery time of around 12 days.

Some states showed higher delivery delay percentages, indicating possible logistics or regional fulfillment issues.

Delayed deliveries were useful for identifying operational bottlenecks and areas where customer satisfaction could be affected.

Payment type analysis showed how customers preferred to pay and which payment methods contributed most to total transaction value.

Review score analysis helped connect customer satisfaction with delivery performance and product categories.

Certain categories generated high revenue but also required deeper review due to delivery delays or lower customer ratings.

Monthly revenue trend analysis helped identify growth patterns and changes in order demand over time.

## Dashboard Metrics

Total Revenue  
Total Orders  
Total Customers  
Average Delivery Days  
Delayed Orders  
Delay Percentage  
Average Review Score  
Revenue by Month  
Revenue by State  
Revenue by Product Category  
Payment Type Mix  
Delivery Status Breakdown  
Top Cities by Revenue  

## SQL Concepts Applied

Joins  
Group By  
Aggregate Functions  
Case When  
Date Conversion  
Date Truncation  
CTEs  
Window Functions  
Rank  
Lag  
Null Handling  
Views  

## Business Value

This project helps an e-commerce business understand where revenue is coming from, which products and regions are performing well, and where delivery operations need improvement.

The analysis can support decisions related to logistics planning, product category focus, regional sales strategy, payment behavior tracking, and customer experience improvement.
