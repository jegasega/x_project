import os
import sys
import subprocess
import logging
from kafka import KafkaProducer

should_stop = False
producer = None

kafka_topic = os.getenv('KAFKA_TOPIC', 'log-file')
kafka_host = os.getenv('KAFKA_HOST', '127.0.0.1')
kafka_port = os.getenv('KAFKA_PORT', '9092')

read_file = os.getenv('READ_FILE', 'test.log')
log_file = os.getenv('LOG_FILE', 'tailer.log')
log_level = os.getenv('LOG_LEVEL', 'WARNING')

message_batch_size = os.getenv('BATCH_SIZE', '5')

# Logger configuration
# file_handler = logging.FileHandler(filename=log_file)
stdout_handler = logging.StreamHandler(sys.stdout)
handlers = [stdout_handler]

logging.basicConfig(
    level=log_level,
    format='%(levelname)s: %(message)s',
    handlers=handlers
)

new_logger = logging.getLogger('NEW_LOGGER')


def flush_message(producer, kafka_topic, message):
    producer.send(kafka_topic, value=message)


def log_lines_generator(readfile, delay_between_iterations=None):
    cmd = ['tail', '-n', '0', '-F']
    if delay_between_iterations is not None:
        cmd.append('-s')
    cmd.append(delay_between_iterations)
    cmd.append(readfile)
    process = subprocess.Popen(cmd, stdout=subprocess. PIPE, stderr=None)
    while not should_stop:
        line = process.stdout.readline().strip()
        yield line


def file_tailer():

    try:
        producer = KafkaProducer(bootstrap_servers=[kafka_host + ":" + kafka_port], )

        for line in log_lines_generator(read_file):
            flush_message(producer, kafka_topic, line)

    except Exception as e:
        new_logger.error(f'ERROR: {e}')
