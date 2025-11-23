# Machine Learning Theory & Practice: Essential Reading Notes

---

## 1. Business Understanding
- Always start with a clear business problem and measurable objectives.
- Translate business goals into ML tasks (classification, regression, etc.).
- Success = measurable business impact, not just model accuracy.

## 2. Data Engineering
- "Garbage in, garbage out": Data quality is critical.
- Data sources: databases, APIs, logs, external datasets.
- Data cleaning: handle missing values, outliers, duplicates.
- Feature engineering often has more impact than model choice.
- Data leakage is a common pitfall—keep test data separate!

## 3. Model Development
- Start simple: baseline models (mean, median, logistic regression).
- Use cross-validation to avoid overfitting.
- Hyperparameter tuning can make a big difference.
- Track experiments (parameters, metrics, code version).
- Understand model assumptions and limitations.

## 4. Model Evaluation
- Use multiple metrics (accuracy, precision, recall, F1, ROC-AUC).
- Always compare to a baseline and business KPIs.
- Beware of overfitting: high train, low test performance = overfit.
- Check for bias and fairness, especially in sensitive applications.
- Error analysis can reveal data or modeling issues.

## 5. Model Deployment
- Automate deployment (CI/CD for ML).
- Monitor for data drift and model decay.
- Document model inputs, outputs, and assumptions.
- Use version control for models and data pipelines.
- Test deployment in a staging environment before production.

## 6. Model Monitoring & Maintenance
- Set up monitoring for prediction quality and system health.
- Retrain models regularly with new data.
- Collect feedback from users and stakeholders.
- Plan for model rollback or retirement.
- Keep documentation up to date for compliance and reproducibility.

---

## Key ML Concepts to Remember
- **Bias-Variance Tradeoff**: High bias = underfit, high variance = overfit.
- **Cross-Validation**: Reliable way to estimate model performance.
- **Feature Importance**: Know which features drive predictions.
- **Regularization**: Prevents overfitting (L1, L2, dropout, etc.).
- **Ensemble Methods**: Combine models for better performance (bagging, boosting).
- **Data Leakage**: Never let test data influence training.
- **Explainability**: Use SHAP, LIME, or feature importance for transparency.
- **Ethics**: Be aware of bias, fairness, and privacy issues.

---

## Further Reading & Resources
- "Hands-On Machine Learning with Scikit-Learn, Keras, and TensorFlow" by Aurélien Géron
- "Pattern Recognition and Machine Learning" by Christopher Bishop
- "Designing Machine Learning Systems" by Chip Huyen
- Google ML Crash Course: https://developers.google.com/machine-learning/crash-course
- AWS ML Exam Guide: https://d1.awsstatic.com/training-and-certification/docs-ml/AWS-Certified-Machine-Learning-Specialty_Exam-Guide.pdf
- Fast.ai Practical Deep Learning: https://course.fast.ai/

---

*Keep this file as a quick reference for theory and best practices during your MLA-C01 prep and real-world ML projects!*
