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

print ' [*] Waiting for messages. To exit press CTRL+C'

def callback(ch, method, properties, body):
    print " [x] Received %r" % (body,)

channel.basic_consume('hello', callback, auto_ack=True)

channel.start_consuming()
