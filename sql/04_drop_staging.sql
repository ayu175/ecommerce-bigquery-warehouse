-- Remove the raw staging table once the normalized tables are built,
-- so storage is not paid for twice.

DROP TABLE `your_project.your_dataset.staging_raw`;
