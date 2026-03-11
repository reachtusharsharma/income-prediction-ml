import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import OneHotEncoder
from sklearn.compose import ColumnTransformer
from sklearn.pipeline import Pipeline
from sklearn.metrics import classification_report
from sklearn.linear_model import LogisticRegression
from sklearn.ensemble import RandomForestClassifier
import joblib

# Load dataset
dataset = pd.read_csv("data/processed_adult.csv")

# Features used
X = dataset[
    [
        "age",
        "educational.num",
        "occupation",
        "race",
        "hours.per.week",
        "native.country"
    ]
]

y = dataset["income"]

# Identify categorical and numeric columns
categorical_features = [
    "occupation",
    "race",
    "native.country"
]

numeric_features = [
    "age",
    "educational.num",
    "hours.per.week"
]

# Preprocessing pipeline
preprocessor = ColumnTransformer(
    transformers=[
        ("cat", OneHotEncoder(handle_unknown="ignore"), categorical_features)
    ],
    remainder="passthrough"
)

# Logistic Regression pipeline
lr_pipeline = Pipeline(
    steps=[
        ("preprocessor", preprocessor),
        ("model", LogisticRegression(max_iter=1000))
    ]
)

# Random Forest pipeline
rf_pipeline = Pipeline(
    steps=[
        ("preprocessor", preprocessor),
        ("model", RandomForestClassifier())
    ]
)

# Train/test split
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42
)

# Train models
lr_pipeline.fit(X_train, y_train)
rf_pipeline.fit(X_train, y_train)

# Predictions
lr_pred = lr_pipeline.predict(X_test)
rf_pred = rf_pipeline.predict(X_test)

print("Logistic Regression")
print(classification_report(y_test, lr_pred))

print("Random Forest")
print(classification_report(y_test, rf_pred))

# Save models
joblib.dump(lr_pipeline, "lr_pipeline.pkl")
joblib.dump(rf_pipeline, "rf_pipeline.pkl")

print("Models saved successfully")