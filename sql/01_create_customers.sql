-- Customers: one row per customer, flattened from the nested customer record.
-- Replace `your_project.your_dataset` with your own BigQuery project and dataset.

CREATE TABLE `your_project.your_dataset.customers` AS
SELECT DISTINCT
  customer.customer_id,
  customer.name,
  customer.email,
  customer.phone,
  customer.address
FROM `your_project.your_dataset.staging_raw`;
