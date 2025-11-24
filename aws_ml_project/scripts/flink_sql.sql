-- Flink SQL for Kinesis Data Analytics (oreumi-naver-review-flink-app)
-- Reads from Kinesis, writes to S3 and DynamoDB

CREATE TABLE source_stream (
  review_id STRING,
  review_text STRING,
  label STRING,
  ts TIMESTAMP(3),
  WATERMARK FOR ts AS ts - INTERVAL '5' SECOND
) WITH (
  'connector' = 'kinesis',
  'stream' = 'oreumi-naver-review-stream',
  'aws.region' = 'ap-southeast-2',
  'format' = 'json',
  'scan.stream.initpos' = 'LATEST'
);

CREATE TABLE s3_sink (
  review_id STRING,
  label STRING,
  ts TIMESTAMP(3)
) WITH (
  'connector' = 'filesystem',
  'path' = 's3a://oreumi-streaming-lab/processed/',
  'format' = 'json'
);

CREATE TABLE dynamodb_sink (
  pk STRING,
  sk STRING,
  label STRING,
  ttl BIGINT
) WITH (
  'connector' = 'dynamodb',
  'table-name' = 'oreumi-naver-review-agg',
  'aws.region' = 'ap-southeast-2'
);

INSERT INTO s3_sink SELECT review_id, label, ts FROM source_stream;
INSERT INTO dynamodb_sink SELECT review_id, CAST(ts AS STRING), label, UNIX_TIMESTAMP(ts) + 2592000 FROM source_stream;

