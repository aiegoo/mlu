# This script loads your Naver review data and is ready for streaming simulation in a notebook.
import pandas as pd

data_path = '02_ml_basics/data/ratings_train.txt'  # Change if needed

try:
    df = pd.read_csv(data_path, sep='\t')
except Exception:
    df = pd.read_csv(data_path, sep=',')

print(f'Data shape: {df.shape}')
print(df.head())
