from kafka import KafkaProducer, KafkaConsumer


def test_file_open() -> None:
    file = open("test.log")
    assert file.read()


def test_kafka() -> None:

    kafka_topic = 'test'

    producer = KafkaProducer(bootstrap_servers=["localhost:9092"])
    producer.send(kafka_topic, value=b'test')
    producer.close()

    consumer = KafkaConsumer(kafka_topic,
                             group_id='test_group',
                             bootstrap_servers=['localhost:9092'],
                             value_deserializer=bytes.decode,
                             auto_offset_reset='earliest',
                             enable_auto_commit=False)

    for message in consumer:
        assert message.value == 'test'
        consumer.close()
