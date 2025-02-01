## Overview
This repository contains SQL scripts to train, fine-tune, evaluate, and deploy a machine learning model using BigQuery ML for house price prediction.

## Steps
1. **Load Data**: The dataset must be uploaded to BigQuery. Follow these steps to create the dataset and load data:
   - Navigate to the [Google Cloud Console](https://console.cloud.google.com/).
   - Open the **BigQuery** service.
   - Click **Create Dataset** and name it `house_prices`.
   - Click on the created dataset and then **Create Table**.
   - Upload the CSV file containing house price data or select an existing Google Cloud Storage location.
   - Ensure appropriate schema mapping and load the data.
2. **Data Cleaning**: Handle missing values by replacing them with appropriate defaults.
3. **Feature Engineering & Selection**:
   - Transform raw features and apply log transformation to the price column.
   - Perform feature selection by filtering highly correlated or less informative features.
   - Convert categorical features using one-hot encoding for better model performance.
   - Create interaction terms between numerical features to enhance predictive power.
4. **Model Training & Hyperparameter Tuning**:
   - Train the model using `CREATE OR REPLACE MODEL`.
   - Tune hyperparameters such as `L1_REG`, `L2_REG`, `LEARNING_RATE`, and feature selection.
   - Use different model versions to compare performance (`versioning` for tracking improvements).
5. **Model Evaluation & Explainability**:
   - Assess model performance using `ML.EVALUATE`.
   - Extract feature importance using `ML.WEIGHTS`.
   - Perform bias analysis using feature impact on predictions.
6. **Predictions & Deployment**:
   - Predict house prices on new data using `ML.PREDICT`.
   - Store model predictions for further analysis.
   - Deploy the model using BigQuery ML endpoints or scheduled queries.
