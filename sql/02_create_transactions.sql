-- Transactions: one row per order, linked to customers by customer_id.
-- transaction_date is cast to TIMESTAMP so it can be filtered and partitioned by date.

CREATE TABLE `your_project.your_dataset.transactions` AS
SELECT
  transaction_id,
  customer.customer_id,
  TIMESTAMP(transaction_date) AS transaction_date,
  shipping_method,
  total_amount
FROM `your_project.your_dataset.staging_raw`;
