## Overview
This repository contains SQL scripts to train, evaluate, and deploy a machine learning model using BigQuery ML for house price prediction.

## Steps
1. **Load Data**: The dataset must be uploaded to BigQuery. Follow these steps to create the dataset and load data:
   - Navigate to the [Google Cloud Console](https://console.cloud.google.com/).
   - Open the **BigQuery** service.
   - Click **Create Dataset** and name it `house_prices`.
   - Click on the created dataset and then **Create Table**.
   - Upload the CSV file containing house price data or select an existing Google Cloud Storage location.
   - Ensure appropriate schema mapping and load the data.
2. **Data Cleaning**: Handle missing values by replacing them with appropriate defaults.
3. **Feature Engineering**: Transform raw features and apply log transformation to the price column.
4. **Model Training**: Use `CREATE OR REPLACE MODEL` with linear regression.
5. **Model Evaluation**: Assess model performance using `ML.EVALUATE`.
6. **Predictions**: Predict house prices on new data using `ML.PREDICT`.

**Refrences** <a>https://cloud.google.com/bigquery/docs/create-machine-learning-model<a>
