import pandas as pd
import numpy as np

# Load dataset
dataset = pd.read_csv("data/adult.csv")

# -----------------------------
# Normalize column names
# -----------------------------
dataset.columns = dataset.columns.str.lower().str.replace("-", ".")

# Now columns look like:
# educational.num, hours.per.week, native.country etc.

print("Columns after normalization:")
print(dataset.columns)

# -----------------------------
# Handle missing values
# -----------------------------
dataset.replace("?", np.nan, inplace=True)

# Fill numeric missing values
dataset["age"].fillna(dataset["age"].mean(), inplace=True)
dataset["hours.per.week"].fillna(dataset["hours.per.week"].mean(), inplace=True)

# -----------------------------
# Convert target variable
# -----------------------------
dataset["income"] = dataset["income"].map({
    "<=50K": 0,
    ">50K": 1
})

# -----------------------------
# Workclass grouping
# -----------------------------
dataset["workclass"] = dataset["workclass"].replace({
    "Federal-gov": "Government",
    "Local-gov": "Government",
    "State-gov": "Government",
    "Self-emp-inc": "Self-Employed",
    "Self-emp-not-inc": "Self-Employed",
    "Never-worked": "Other",
    "Without-pay": "Other"
})

# -----------------------------
# Marital status grouping
# -----------------------------
dataset["marital.status"] = dataset["marital.status"].replace({
    "Married-AF-spouse": "Married",
    "Married-civ-spouse": "Married",
    "Married-spouse-absent": "Married",
    "Never-married": "Single"
})

# -----------------------------
# Convert categorical columns
# -----------------------------
categorical_columns = [
    "workclass",
    "education",
    "marital.status",
    "occupation",
    "relationship",
    "race",
    "gender",
    "native.country"
]

for col in categorical_columns:
    dataset[col] = dataset[col].astype("category")

# -----------------------------
# Quick dataset summary
# -----------------------------
print("\nDataset shape:", dataset.shape)
print("\nMissing values:")
print(dataset.isnull().sum())

print("\nFirst 5 rows:")
print(dataset.head())

# -----------------------------
# Save processed dataset
# -----------------------------
dataset.to_csv("processed_adult.csv", index=False)

print("\nPreprocessing completed successfully.")
print("Saved file: processed_adult.csv")