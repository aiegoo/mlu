import os
import boto3
import pandas as pd
import time
import json
import logging

# Config
REGION = 'ap-southeast-2'
STREAM_NAME = 'oreumi-naver-review-stream'
# Use absolute path from workspace root for reliability
DATA_PATH = os.path.join(os.path.dirname(__file__), '../../02_ml_basics/data/ratings_train.txt')
DATA_PATH = os.path.abspath(DATA_PATH)
DELAY = 0.2  # seconds between events
MAX_EVENTS = 100  # limit for cost control

logging.basicConfig(level=logging.INFO, format='%(asctime)s %(levelname)s %(message)s')

# Load data
def load_data(path):
    try:
        df = pd.read_csv(path, sep='\t', encoding='utf-8')
    except Exception:
        df = pd.read_csv(path, sep=',', encoding='utf-8')
    return df

def main():
    if not os.path.exists(DATA_PATH):
        logging.error(f"Data file not found: {DATA_PATH}")
        return
    df = load_data(DATA_PATH)
    kinesis = boto3.client('kinesis', region_name=REGION)
    count = 0
    for idx, row in df.iterrows():
        event = row.to_dict()
        try:
            response = kinesis.put_record(
                StreamName=STREAM_NAME,
                Data=json.dumps(event),
                PartitionKey=str(event.get('id', idx))
            )
            logging.info(f"Sent event {idx}: {event}")
        except Exception as e:
            logging.error(f"Failed to send event {idx}: {e}")
        time.sleep(DELAY)
        count += 1
        if count >= MAX_EVENTS:
            break
    logging.info(f"Done. Sent {count} events.")

if __name__ == "__main__":
    main()
