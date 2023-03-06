import os
import sys
import subprocess
import logging
from kafka import KafkaProducer
from sh import tail

should_stop = False
producer = None

kafka_topic = os.getenv('KAFKA_TOPIC', 'log-file')
kafka_host = os.getenv('KAFKA_HOST', '127.0.0.1')
producer_kafka_port = os.getenv('PRODUCER_KAFKA_PORT', '9092')

read_file = os.getenv('READ_FILE', './test.log')
log_file = os.getenv('LOG_FILE', 'tailer.log')
log_level = os.getenv('LOG_LEVEL', 'WARNING')

message_batch_size = os.getenv('BATCH_SIZE', '5')

# Logger configuration
stdout_handler = logging.StreamHandler(sys.stdout)
handlers = [stdout_handler]

logging.basicConfig(
    level=log_level,
    format='%(levelname)s: %(message)s',
    handlers=handlers
)

new_logger = logging.getLogger('NEW_LOGGER')


def flush_message(producer, kafka_topic, message):

    message_bytes = bytes(message, 'ascii')
    producer.send(kafka_topic, value=message_bytes)


def log_lines_generator(readfile):
    while True:
        for line in tail("-f", readfile, _iter=True):
            yield str(line)

def file_tailer():

    try:
        bootstrap_server = f"{ kafka_host }:{ producer_kafka_port }"
        producer = KafkaProducer(bootstrap_servers=[bootstrap_server])
       
        for line in log_lines_generator(read_file):
            print(line)
            flush_message(producer, kafka_topic, str(line))

    except Exception as e:

        print(e)
        new_logger.error(f'ERROR: {e}')
