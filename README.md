## 🛒 Walmart Sales Analysis

A data-driven SQL project analyzing Walmart sales transactions to extract actionable business insights using PostgreSQL. The project is based on a series of real-world business questions related to branch performance, customer behavior, and profitability.

---

### 📁 Dataset Columns

* `invoice_id`, `Branch`, `City`, `category`, `unit_price_USD`, `quantity`, `date`, `time`, `payment_method`, `rating`, `profit_margin`, `Day`, `Month`, `Year`, `Total_price`

---

### 📊 Tools Used

* **PostgreSQL** – Data querying and manipulation
* **Excel / Power BI** *(optional)* – Visualization (not shown here)
* **Git & GitHub** – Version control and collaboration

---

### 🔍 Business Questions & Answers

---

**1. What are the different payment methods, and how many transactions and items were sold with each method?**

```sql
SELECT 
    payment_method, 
    COUNT(DISTINCT invoice_id) AS total_transactions,
    SUM(quantity) AS total_items_sold
FROM walmart_data
GROUP BY payment_method;
```

---

**2. Which category received the highest average rating in each branch?**

```sql
SELECT 
    Branch,
    category,
    ROUND(AVG(rating), 2) AS avg_rating
FROM walmart_data
GROUP BY Branch, category
QUALIFY ROW_NUMBER() OVER(PARTITION BY Branch ORDER BY AVG(rating) DESC) = 1;
```

---

**3. What is the busiest day of the week for each branch based on transaction volume?**

```sql
SELECT 
    Branch, 
    Day, 
    COUNT(invoice_id) AS total_transactions
FROM walmart_data
GROUP BY Branch, Day
QUALIFY ROW_NUMBER() OVER(PARTITION BY Branch ORDER BY COUNT(invoice_id) DESC) = 1;
```

---

**4. How many items were sold through each payment method?**

```sql
SELECT 
    payment_method, 
    SUM(quantity) AS total_items_sold
FROM walmart_data
GROUP BY payment_method;
```

---

**5. What are the average, minimum, and maximum ratings for each category in each city?**

```sql
SELECT 
    City, 
    category, 
    ROUND(AVG(rating), 2) AS avg_rating,
    MIN(rating) AS min_rating,
    MAX(rating) AS max_rating
FROM walmart_data
GROUP BY City, category;
```

---

**6. What is the total profit for each category, ranked from highest to lowest?**

```sql
SELECT 
    category, 
    ROUND(SUM(profit_margin), 2) AS total_profit
FROM walmart_data
GROUP BY category
ORDER BY total_profit DESC;
```

---

**7. What is the most frequently used payment method in each branch?**

```sql
SELECT 
    Branch,
    payment_method,
    COUNT(*) AS usage_count
FROM walmart_data
GROUP BY Branch, payment_method
QUALIFY ROW_NUMBER() OVER(PARTITION BY Branch ORDER BY COUNT(*) DESC) = 1;
```

---

**8. How many transactions occur in each shift (Morning, Afternoon, Evening) across branches?**

```sql
SELECT 
    Branch,
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

### 📌 How to Use

1. Clone the repository:

   ```bash
   git clone https://github.com/yourusername/Walmart-Sales-Analysis.git
   ```

2. Open the SQL files inside the `/queries/` folder to run the questions individually.

3. Dataset is assumed to be in a table called `walmart_data`.
