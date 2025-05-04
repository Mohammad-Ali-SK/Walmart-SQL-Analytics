# 🛒 Walmart Sales Analysis

A data analytics project focused on Walmart's transactional sales data to uncover business-critical insights. Using SQL, we answer a set of business questions aimed at improving sales, understanding customer behavior, identifying revenue drops, and enhancing profitability.

---

## 📁 Dataset Columns

The dataset used (`walmart_data`) contains the following fields:

- `invoice_id`, `Branch`, `City`, `category`, `unit_price_USD`, `quantity`, `date`, `time`, `payment_method`, `rating`, `profit_margin`, `Day`, `Month`, `Year`, `Total_price`

---

## 🛠️ Tools Used

- **PostgreSQL** – For SQL-based data querying
- **Excel / Power BI** *(optional)* – For visualization and dashboards
- **Git & GitHub** – For version control and collaboration

---

## 🔍 Business Questions & Answers

**1. What are the different payment methods, and how many transactions and items were sold with each method?**

```sql
SELECT payment_method, COUNT(DISTINCT invoice_id) AS total_transactions, SUM(quantity) AS total_items_sold
FROM walmart_data
GROUP BY payment_method;
````

---

**2. Which category received the highest average rating in each branch?**

```sql
SELECT Branch, category, ROUND(AVG(rating), 2) AS avg_rating
FROM walmart_data
GROUP BY Branch, category
QUALIFY ROW_NUMBER() OVER(PARTITION BY Branch ORDER BY AVG(rating) DESC) = 1;
```

---

**3. What is the busiest day of the week for each branch based on transaction volume?**

```sql
SELECT Branch, Day, COUNT(invoice_id) AS total_transactions
FROM walmart_data
GROUP BY Branch, Day
QUALIFY ROW_NUMBER() OVER(PARTITION BY Branch ORDER BY COUNT(invoice_id) DESC) = 1;
```

---

**4. How many items were sold through each payment method?**

```sql
SELECT payment_method, SUM(quantity) AS total_items_sold
FROM walmart_data
GROUP BY payment_method;
```

---

**5. What are the average, minimum, and maximum ratings for each category in each city?**

```sql
SELECT City, category, ROUND(AVG(rating), 2) AS avg_rating, MIN(rating), MAX(rating)
FROM walmart_data
GROUP BY City, category;
```

---

**6. What is the total profit for each category, ranked from highest to lowest?**

```sql
SELECT category, ROUND(SUM(profit_margin), 2) AS total_profit
FROM walmart_data
GROUP BY category
ORDER BY total_profit DESC;
```

---

**7. What is the most frequently used payment method in each branch?**

```sql
SELECT Branch, payment_method, COUNT(*) AS usage_count
FROM walmart_data
GROUP BY Branch, payment_method
QUALIFY ROW_NUMBER() OVER(PARTITION BY Branch ORDER BY COUNT(*) DESC) = 1;
```

---

**8. How many transactions occur in each shift (Morning, Afternoon, Evening) across branches?**

```sql
SELECT Branch,
    CASE
        WHEN time BETWEEN '00:00:00' AND '11:59:59' THEN 'Morning'
        WHEN time BETWEEN '12:00:00' AND '17:59:59' THEN 'Afternoon'
        ELSE 'Evening'
    END AS shift,
    COUNT(invoice_id) AS total_transactions
FROM walmart_data
GROUP BY Branch, shift;
```

---

**9. Which branches experienced the largest decrease in revenue compared to the previous year?**

```sql
SELECT 
    curr."Branch",
    prev."Year" AS previous_year,
    curr."Year" AS current_year,
    prev.total_revenue AS revenue_previous_year,
    curr.total_revenue AS revenue_current_year,
    (curr.total_revenue - prev.total_revenue) AS revenue_change
FROM (
    SELECT "Branch", "Year", SUM("Total_price") AS total_revenue
    FROM walmart_data
    GROUP BY "Branch", "Year"
) curr
JOIN (
    SELECT "Branch", "Year", SUM("Total_price") AS total_revenue
    FROM walmart_data
    GROUP BY "Branch", "Year"
) prev
ON curr."Branch" = prev."Branch" AND curr."Year" = prev."Year" + 1
ORDER BY revenue_change ASC;
```

---

## 📌 Key Findings

* 💳 **Most used payment method:** Credit card dominates in some branches, while cash is more prevalent in others.
* 📆 **Busiest day per branch:** Different branches have unique traffic patterns – Fridays and Sundays were typically the busiest.
* 📦 **Top-rated categories:** Health and Electronics categories consistently received the highest average ratings.
* 🕑 **Shift trends:** Evening shifts had more transactions than mornings across almost all branches.
* 📉 **Revenue drop:** Specific branches showed a year-over-year decrease in revenue, indicating potential operational or demand-related issues.

---

## 📊 Reports & Insights

* 📈 **Branch-Level Revenue Trends:** By comparing total revenue across years, we identified underperforming branches that need strategic improvement.
* 🎯 **Category Profitability:** Fashion and Electronics stood out as highly profitable, while Grocery had lower margins.
* 🛍️ **Payment Behavior:** Understanding customer payment preferences can help optimize POS systems and targeted promotions.
* ⭐ **Customer Satisfaction:** Ratings varied by category and city, highlighting where product or service enhancements are needed.

---

## ✅ Conclusion

This project successfully identified key sales insights from Walmart's transactional data using SQL. We answered crucial business questions related to customer behavior, category performance, payment preferences, and profitability. These insights can guide business decisions such as staffing shifts, marketing campaigns, inventory planning, and improving branch performance.

---

## 📂 Folder Structure (Recommended)

```
Walmart-Sales-Analysis/
├── data/                  # Raw CSV or database exports
├── queries/               # All SQL scripts used for business questions
├── reports/               # Final report, PDF insights
├── README.md              # Project summary and documentation
```

---

## 📬 Contact

For any questions or feedback, feel free to reach out or raise an issue.

---

```

Would you like me to save this `README.md` file and provide it for download so you can upload it to GitHub directly?
```
