## SQL Script

-- Step 1: Load Data into BigQuery
-- Ensure the dataset `house_prices` is created and data is available in `house_prices.raw_data`

-- Step 2: Clean and Transform the Data
WITH cleaned_data AS (
  SELECT
    IFNULL(sqft, 0) AS sqft,
    IFNULL(num_bedrooms, 0) AS num_bedrooms,
    IFNULL(num_bathrooms, 0) AS num_bathrooms,
    IFNULL(year_built, 0) AS year_built,
    IFNULL(garage_spaces, 0) AS garage_spaces,
    IFNULL(zipcode, "") AS zipcode,
    IFNULL(price, 0) AS price
  FROM `my_project.house_prices.raw_data`
)
-- Step 3: Feature Engineering & Selection
, feature_engineered AS (
  SELECT
    sqft,
    num_bedrooms,
    num_bathrooms,
    year_built,
    garage_spaces,
    zipcode,
    LOG(price) AS log_price, -- Applying log transformation to price
    sqft * num_bedrooms AS sqft_bedroom_interaction, -- Interaction feature
    IF(zipcode IN ("532345", "543678"), 1, 0) AS prime_location -- Categorical encoding
  FROM cleaned_data
  WHERE sqft > 500 AND num_bedrooms > 0 -- Simple feature filtering
)
SELECT * FROM feature_engineered;

-- Step 4: Create and Fine-Tune the Model with Versioning
CREATE OR REPLACE MODEL `house_prices.price_prediction_model_v1`
OPTIONS(
  model_type='linear_reg',
  l1_reg=0.05,  -- Adjusted L1 regularization for feature sparsity
  l2_reg=0.3,  -- Adjusted L2 regularization for better generalization
  learn_rate=0.02  -- Lower learning rate for better convergence
) AS
SELECT * FROM feature_engineered;

-- Step 5: Evaluate the Model
SELECT * FROM ML.EVALUATE(MODEL `house_prices.price_prediction_model_v1`);

-- Step 6: Extract Feature Importance
SELECT * FROM ML.WEIGHTS(MODEL `house_prices.price_prediction_model_v1`);

-- Step 7: Perform Bias Analysis (Optional)
SELECT 
    feature, 
    weight, 
    weight * 100 AS impact_percentage 
FROM ML.WEIGHTS(MODEL `house_prices.price_prediction_model_v1`)
ORDER BY ABS(weight) DESC;

-- Step 8: Predict House Prices and Store Results
CREATE OR REPLACE TABLE `house_prices.predictions` AS
SELECT
  sqft,
  num_bedrooms,
  num_bathrooms,
  year_built,
  garage_spaces,
  zipcode,
  EXP(predicted_log_price) AS predicted_price -- Reverse log transformation
FROM ML.PREDICT(MODEL `house_prices.price_prediction_model_v1`, (
  SELECT * FROM `house_prices.new_listings`
));

-- Step 9: Deploy the Model for Automated Predictions
-- You can schedule this query to run at regular intervals using BigQuery scheduled queries
CREATE OR REPLACE TABLE `house_prices.scheduled_predictions` AS
SELECT
  *,
  CURRENT_TIMESTAMP() AS prediction_timestamp
FROM ML.PREDICT(MODEL `house_prices.price_prediction_model_v1`, (
  SELECT * FROM `house_prices.upcoming_listings`
));

