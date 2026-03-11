import streamlit as st
import pandas as pd
import joblib

# Load models
lr_model = joblib.load("models/lr_pipeline.pkl")
rf_model = joblib.load("models/rf_pipeline.pkl")

# Load dataset
dataset = pd.read_csv("processed_adult.csv")

st.title("Income Prediction System")

model_choice = st.selectbox(
    "Choose Model",
    ["Logistic Regression", "Random Forest"]
)

age = st.slider("Age", 18, 80, 30)

education = st.slider("Years of Education", 0, 22, 12)

hours = st.slider("Hours per Week", 1, 80, 40)

occupation = st.selectbox(
    "Occupation",
    dataset["occupation"].unique()
)

race = st.selectbox(
    "Race",
    dataset["race"].unique()
)

country = st.selectbox(
    "Country",
    dataset["native.country"].unique()
)

if st.button("Predict"):

    input_data = pd.DataFrame(
        {
            "age":[age],
            "educational.num":[education],
            "occupation":[occupation],
            "race":[race],
            "hours.per.week":[hours],
            "native.country":[country]
        }
    )

    if model_choice == "Logistic Regression":
        prediction = lr_model.predict(input_data)

    else:
        prediction = rf_model.predict(input_data)

    if prediction[0] == 1:
        st.success("Predicted Income: > $50K")
    else:
        st.warning("Predicted Income: <= $50K")