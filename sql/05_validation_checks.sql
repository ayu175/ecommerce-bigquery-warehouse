-- Validation checks for the final tables.
-- Run after 01-03. Expected results (from profiling the source file) are noted on each check.

-- 1. Row counts
--    Expected: customers = 10,000 | transactions = 10,000 | shopping_cart_items = 29,774
SELECT 'customers' AS table_name, COUNT(*) AS row_count FROM `your_project.your_dataset.customers`
UNION ALL
SELECT 'transactions', COUNT(*) FROM `your_project.your_dataset.transactions`
UNION ALL
SELECT 'shopping_cart_items', COUNT(*) FROM `your_project.your_dataset.shopping_cart_items`;

-- 2. Primary keys are unique
--    Expected: 0 duplicates in each table
SELECT 'customers' AS table_name, COUNT(*) - COUNT(DISTINCT customer_id) AS duplicate_keys FROM `your_project.your_dataset.customers`
UNION ALL
SELECT 'transactions', COUNT(*) - COUNT(DISTINCT transaction_id) FROM `your_project.your_dataset.transactions`
UNION ALL
SELECT 'shopping_cart_items', COUNT(*) - COUNT(DISTINCT cart_item_id) FROM `your_project.your_dataset.shopping_cart_items`;

-- 3. No orphaned foreign keys
--    Expected: 0 transactions without a customer, 0 items without a transaction
SELECT
  (SELECT COUNT(*)
   FROM `your_project.your_dataset.transactions` t
   LEFT JOIN `your_project.your_dataset.customers` c USING (customer_id)
   WHERE c.customer_id IS NULL) AS orphan_transactions,
  (SELECT COUNT(*)
   FROM `your_project.your_dataset.shopping_cart_items` i
   LEFT JOIN `your_project.your_dataset.transactions` t USING (transaction_id)
   WHERE t.transaction_id IS NULL) AS orphan_items;

-- 4. Order totals reconcile with their line items
--    Expected: 0 transactions where total_amount differs from SUM(quantity * price)
SELECT COUNT(*) AS mismatched_totals
FROM `your_project.your_dataset.transactions` t
JOIN (
  SELECT transaction_id, SUM(quantity * price) AS item_total
  FROM `your_project.your_dataset.shopping_cart_items`
  GROUP BY transaction_id
) i USING (transaction_id)
WHERE ABS(t.total_amount - i.item_total) > 0.01;

-- 5. Vendor was recovered for every item
--    Expected: 0 null vendors, 30 distinct vendors
SELECT
  COUNTIF(vendor IS NULL) AS null_vendors,
  COUNT(DISTINCT vendor) AS distinct_vendors
FROM `your_project.your_dataset.shopping_cart_items`;
