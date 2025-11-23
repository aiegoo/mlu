# ✅ **False Positive (FP)**

A **false positive** happens when a model predicts **Positive** but the actual truth is **Negative**.

### 📌 Example (simple)

* **Spam filter** marks a legitimate email as *spam* → **False Positive**
* **Medical test** says “disease detected” but the patient is healthy → **False Positive**

### 📌 Why false positives matter

* They create *unnecessary actions, alerts, or costs*.
* In many domains, FPs are less dangerous than false negatives (but it depends on context).

---

# ✅ **False Positive Rate (FPR)**

FPR = FP / (FP + TN)

It measures:
👉 *Out of all actual negatives, how many did the model wrongly flag as positive?*

AWS Exam note:
**High FPR = noisy model = unacceptable in security, fraud, or alerts-based systems.**

---

# 📊 **Evaluation Metrics — AWS ML Exam Essential Version**

Below are the metrics most commonly tested, how they relate to FP/FN, and where they matter.

---

# **1. Accuracy**

**Accuracy = (TP + TN) / (TP + TN + FP + FN)**

✔ Good when **class distribution is balanced**
✘ Misleading when **dataset is imbalanced** (e.g., fraud 1%)

---

# **2. Precision**

**Precision = TP / (TP + FP)**
“How many predicted positives were actually correct?”

* High precision ⇒ **low false positives**
* Used when **false positives are expensive**

📌 Example use cases:

* Spam detection
* Credit card fraud alerts
* Intrusion detection
* Email marketing targeting

---

# **3. Recall (Sensitivity / True Positive Rate)**

**Recall = TP / (TP + FN)**
“How many actual positives did we catch?”

* High recall ⇒ **low false negatives**
* Used when **missing a positive is dangerous**

📌 Examples:

* Cancer detection
* Fraud detection (catch as much as possible)
* Safety systems / event monitoring

---

# **4. F1 Score**

**F1 = harmonic mean of Precision & Recall**
Balances precision and recall when both matter.

Used when:

* Classes are imbalanced
* You want overall "positive class" performance

---

# **5. ROC Curve & AUC**

### ROC Curve

Plots:

* **TPR (Recall)** vs **FPR**

### AUC = Area Under Curve

* 1.0 → perfect model
* 0.5 → random guessing
* <0.5 → worse than random

AWS Exam:
**ROC-AUC is threshold-independent**, which means it evaluates model quality without choosing a p>0.5 threshold.

---

# **6. Confusion Matrix**

The source of all FP / FN metric calculations.

|                     | Predicted Positive | Predicted Negative |
| ------------------- | ------------------ | ------------------ |
| **Actual Positive** | TP                 | FN                 |
| **Actual Negative** | FP                 | TN                 |

AWS ML exam frequently asks:

* Interpret FP, FN counts
* Decide whether recall or precision is more important
* Diagnose imbalance using confusion matrix

---

# **7. Log Loss / Cross-Entropy**

Used in:

* Logistic regression
* Neural networks
* Classification models in Amazon SageMaker

Lower Log Loss ⇒ better probability predictions.

Good for:

* Models that output probabilities
* Highly sensitive to incorrect predictions with high confidence

---

# **8. RMSE / MAE / MAPE (Regression Metrics)**

### RMSE

* Penalizes large errors
* Use when **large mistakes are unacceptable**

### MAE

* Treats errors linearly
* Use when **all errors should be treated equally**

### MAPE

* Percent-based error
* Can fail when actual values are near zero

These appear on the exam in questions about choosing a metric for:

* Forecasting
* Pricing models
* AWS Forecast (supports RMSE/MASE/etc.)

---

# ✅ **Overfitting & Underfitting**

## Overfitting (과적합)
- The model learns the training data *too well*, including noise and outliers.
- High accuracy on training data, but poor generalization to new/unseen data.
- **Symptoms:**
  - Training accuracy ≫ Validation/Test accuracy
  - Model is too complex for the amount of data
- **Prevention:**
  - Use simpler models
  - Regularization (L1/L2)
  - More training data
  - Early stopping
  - Data augmentation

## Underfitting (과소적합)
- The model is *too simple* to capture the underlying pattern in the data.
- Low accuracy on both training and validation/test data.
- **Symptoms:**
  - Training accuracy ≈ Validation/Test accuracy (both low)
  - Model is not complex enough
- **Prevention:**
  - Use more complex models
  - Add more features
  - Reduce regularization

---

# ✅ **Summary Table: Metrics & Error Types**

| Metric / Error Type | Formula | What it Measures | When to Use |
|--------------------|---------|------------------|-------------|
| **Accuracy** | (TP + TN) / (TP + TN + FP + FN) | Overall correctness | Balanced classes |
| **Precision** | TP / (TP + FP) | Correctness of positive predictions | FP is costly (spam, fraud) |
| **Recall** | TP / (TP + FN) | Coverage of actual positives | FN is costly (medical, fraud) |
| **F1 Score** | 2 * (Precision * Recall) / (Precision + Recall) | Balance of precision & recall | Imbalanced classes |
| **False Positive (FP)** | - | Predicted positive, actually negative | - |
| **False Negative (FN)** | - | Predicted negative, actually positive | - |
| **False Positive Rate (FPR)** | FP / (FP + TN) | Out of all negatives, how many were flagged positive | Security, alerts |
| **True Positive Rate (Recall)** | TP / (TP + FN) | Out of all positives, how many were caught | Medical, fraud |

---

# ✅ **Korean Glossary (용어 정리)**

- Overfitting: 과적합
- Underfitting: 과소적합
- Accuracy: 정확도
- Precision: 정밀도
- Recall: 재현율
- F1 Score: F1 점수
- False Positive: 위양성 (거짓 양성)
- False Negative: 위음성 (거짓 음성)
- True Positive: 진양성
- True Negative: 진음성

---

# 🔥 **Exam-specific Tips for AWS ML Certificate**

### **1. Fraud detection → prioritize Recall (FN is costly)**

BUT sometimes precision matters to reduce FPs triggering manual reviews.

### **2. Medical diagnosis → Recall > Precision**

Missing an illness is worse.

### **3. Recommendation systems → Precision**

You want recommended items to be relevant.

### **4. Security alerts → Precision**

Too many false alarms → alert fatigue.

### **5. Imbalanced datasets → accuracy is meaningless**

Use:

* Precision
* Recall
* F1
* ROC-AUC

### **6. Monitor model drift using:**

* Accuracy drops
* Precision/recall decline
* FP/FN trend changes
  (Exam includes model monitoring & MLOps questions.)


to simulate a fraud-detection lab environment using any Kaggle/HF fraud dataset.



✔ Load, clean, and split the dataset
✔ Handle class imbalance
✔ Simulate *real-time* transaction streaming
✔ Trigger fraud events
✔ Build a detection pipeline
✔ Visualize metrics (confusion matrix, precision-recall, thresholds)
✔ Create “attack scenarios” (fraud patterns)

This is ideal practice for **AWS Machine Learning Specialty**, **SageMaker**, and general ML workflow.

---

# ⭐ **1. Load and prepare your dataset**

Example using the Kaggle dataset (`creditcard.csv`).

```python
import pandas as pd

df = pd.read_csv("creditcard.csv")

print(df.head())
print(df['Class'].value_counts())  # Check imbalance
```

OUTPUT (fraud is class `1`):

```
0: 284315
1:     492
```

---

# ⭐ **2. Create a realistic train/test split**

Fraud datasets are *time-ordered*.

Use **time-based split**, not random split.

```python
df = df.sort_values("Time")

train = df.iloc[:200000]
test = df.iloc[200000:]
```

Why?

📌 In real life, you train on past transactions → detect future fraud.

---

# ⭐ **3. Handle class imbalance**

Fraud datasets are extremely imbalanced.

Use **either**:

### Option A — Undersample majority class

```python
fraud = train[train.Class == 1]
normal = train[train.Class == 0].sample(len(fraud) * 5)

train_balanced = pd.concat([fraud, normal]).sample(frac=1)
```

### Option B — Oversample minority (SMOTE)

```python
from imblearn.over_sampling import SMOTE

X = train.drop("Class", axis=1)
y = train["Class"]

X_res, y_res = SMOTE().fit_resample(X, y)
```

### Option C — Train an anomaly detection model

IsolationForest, LOF, Autoencoder, etc.

---

# ⭐ **4. Build a baseline fraud model**

Simple model example:

```python
from sklearn.ensemble import RandomForestClassifier

clf = RandomForestClassifier(n_estimators=150)
clf.fit(train_balanced.drop("Class", axis=1),
        train_balanced["Class"])
```

---

# ⭐ **5. Simulate *real-time* transactions**

Turn the test set into a **streaming generator**:

```python
import time

def transaction_stream(df, delay=0.1):
    for _, row in df.iterrows():
        yield row
        time.sleep(delay)  # simulate real-time arrival
```

Usage:

```python
stream = transaction_stream(test, delay=0.01)

for tx in stream:
    features = tx.drop("Class")
    pred = clf.predict([features])[0]

    if pred == 1:
        print("⚠️ Fraud detected!", tx)
```

You now have a **live detection simulator**.

---

# ⭐ **6. Create fraud event scenarios (lab attack patterns)**

Add synthetic fraud:

### **Scenario 1 — Micro-payment laundering**

Add many small fraudulent transactions:

```python
import numpy as np

def add_micro_fraud(df, n=200):
    sample = df.sample(n).copy()
    sample["Amount"] = np.random.uniform(0.1, 3.0, n)
    sample["Class"] = 1
    return pd.concat([df, sample])
```

---

### **Scenario 2 — Sudden high-value spikes**

```python
def add_high_value_fraud(df, n=50):
    sample = df.sample(n).copy()
    sample["Amount"] = np.random.uniform(5000, 15000, n)
    sample["Class"] = 1
    return pd.concat([df, sample])
```

---

### **Scenario 3 — Time-based fraud burst**

Multiple attacks within a minute:

```python
def burst_attack(df, center_time, size=30):
    sample = df.sample(size).copy()
    sample["Time"] = center_time + np.random.randint(-30, 30, size)
    sample["Class"] = 1
    return pd.concat([df, sample])
```

---

# ⭐ **7. Evaluate the model (key AWS exam metrics)**

### Confusion Matrix

```python
from sklearn.metrics import confusion_matrix
preds = clf.predict(test.drop("Class", axis=1))
cm = confusion_matrix(test["Class"], preds)
print(cm)
```

AWS exam focuses on:

* **False Positives (FP)** → good transactions flagged as fraud
* **False Negatives (FN)** → fraud that the model failed to detect (most dangerous)

---

# ⭐ **8. Precision, Recall, F1, ROC-AUC, PR-AUC**

```python
from sklearn.metrics import classification_report, roc_auc_score

print(classification_report(test["Class"], preds))
print("ROC-AUC:", roc_auc_score(test["Class"], preds))
```

**Very important for fraud detection:**

* **Recall** → catch as many frauds as possible
* **Precision** → minimize false alarms
* **PR-AUC** → best when data is imbalanced

---

# ⭐ **9. Threshold tuning**

Fraud models need **probability threshold tuning**:

```python
probs = clf.predict_proba(test.drop("Class", axis=1))[:,1]

threshold = 0.15
preds = (probs > threshold).astype(int)
```

Lower threshold → catch more fraud, more false alarms
Higher threshold → fewer false alarms, more missed fraud

---

# ⭐ **10. Optional: Simulate AWS SageMaker pipeline**

You can help to set this up after local implementation:

* S3 bucket for dataset
* Ground Truth labeling (if needed)
* SageMaker Processing → feature engineering
* Training jobs (XGBoost, RF, LightGBM)
* Model registry
* Endpoint deployment
* CloudWatch alarms for fraud detection
* Lambda for real-time scoring

