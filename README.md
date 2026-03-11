# Income Prediction using Machine Learning

## Overview

This project predicts whether an individual's annual income exceeds **$50K** using demographic and employment features from the **Adult Census dataset**.

The project was originally developed as a **college data science project in R**, where exploratory data analysis and a prediction interface were implemented using **R and Shiny**.

The repository now contains an **improved Python implementation** that introduces a modern machine learning pipeline built using **Scikit-Learn** and an interactive **Streamlit web application** for real-time predictions.

---

## Project Evolution

### Initial Implementation (Academic Project)

The original version of this project was developed using **R** as part of a college data science assignment.

Features included:

* Data exploration using R
* Data visualization
* Logistic regression and Naive Bayes models
* Interactive prediction interface using **Shiny**

The original implementation is preserved in the folder:

```
legacy_r_shiny_project/
```

---

### Current Implementation (Python ML Pipeline)

The improved version of the project introduces a more structured machine learning workflow using Python.

Enhancements include:

* Automated preprocessing pipeline
* One-hot encoding of categorical features
* Model training using Scikit-Learn
* Model persistence using Joblib
* Interactive web interface using Streamlit

Models implemented:

* Logistic Regression
* Random Forest

---

## Dataset

The model uses the **Adult Income Dataset** derived from the U.S. Census database.

Features used include:

* Age
* Education level
* Occupation
* Race
* Hours worked per week
* Native country

Target variable:

```
Income > $50K
Income ≤ $50K
```

Dataset location:

```
data/adult.csv
```

---

## Project Structure

```
income-prediction-ml
│
├── data
│   ├── adult.csv
│   └── processed_adult.csv
│
├── models
│   ├── lr_pipeline.pkl
│   └── rf_pipeline.pkl
│
├── r_version (LEGACY)
│   ├── data_exploration.R
│   ├── income_prediction.R
│   └── shiny_app_2.R
│
├── data_preprocessing.py
├── model_training.py
├── app.py
├── requirements.txt
└── README.md
```

---

## Machine Learning Pipeline

The Python implementation follows this workflow:

```
Raw Dataset
      ↓
Data Cleaning
      ↓
Feature Encoding
      ↓
Train/Test Split
      ↓
Model Training
      ↓
Saved Models
      ↓
Streamlit Web Application
```

---

## Running the Project Locally

### 1. Install dependencies

```
pip install -r requirements.txt
```

### 2. Preprocess the dataset

```
python data_preprocessing.py
```

### 3. Train the models

```
python model_training.py
```

### 4. Run the web application

```
streamlit run app.py
```

The application will launch in your browser.

---

## Technologies Used

### Programming Languages

* Python
* R

### Libraries and Frameworks

* Pandas
* Scikit-Learn
* Streamlit
* Joblib
* ggplot2 (R version)
* Shiny (R version)

---

## Motivation

This project demonstrates the transition from a traditional **academic data science implementation in R** to a more production-oriented **Python machine learning pipeline** with an interactive deployment interface.

It showcases:

* Data preprocessing
* Machine learning model training
* pipeline-based ML architecture
* web deployment of ML models

---

## Author

Tushar Sharma
