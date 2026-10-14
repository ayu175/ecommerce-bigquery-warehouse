-- Shopping cart items: one row per product line in each order.
--
-- UNNEST flattens the repeated shopping_cart array into one row per item.
-- GENERATE_UUID creates a surrogate key, because (transaction_id, product_id)
-- is not unique: the same product can appear more than once in a cart.
--
-- The source JSON stores the vendor under a malformed key, "vendor: "
-- (with a trailing colon and space). To recover it, each cart item is
-- serialized back to JSON and the value is extracted with a regular expression.

CREATE TABLE `your_project.your_dataset.shopping_cart_items` AS
SELECT
  GENERATE_UUID() AS cart_item_id,
  s.transaction_id,
  item.product_id,
  REGEXP_EXTRACT(TO_JSON_STRING(item), r'"vendor: "\s*:\s*"([^"]+)"') AS vendor,
  item.product_category,
  item.product_name,
  item.quantity,
  item.price
FROM `your_project.your_dataset.staging_raw` AS s,
UNNEST(s.shopping_cart) AS item;
