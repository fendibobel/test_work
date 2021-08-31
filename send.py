#!/usr/bin/env python
import pika

host_haproxy = "46.161.52.50"

credentials = pika.PlainCredentials('test', 'test1234')

connection = pika.BlockingConnection(
               pika.ConnectionParameters(port=5672,
               host=host_haproxy,
               retry_delay=10,
               virtual_host= 'test',
               credentials=credentials))  

channel = connection.channel()

channel.queue_declare(queue='hello')

i=0
while True:
    channel.basic_publish(exchange='',routing_key='hello',body='Test message {}'.format(i))
    i=i+1
    print i
connection.close()
