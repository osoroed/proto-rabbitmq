package com.example.client;

import com.rabbitmq.client.Channel;
import com.rabbitmq.client.Connection;
import com.rabbitmq.client.ConnectionFactory;
import java.io.IOException;
import java.util.concurrent.TimeoutException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.annotation.Profile;

@Profile("send")
public class Sender {

  static Logger logger = LoggerFactory.getLogger(Sender.class);

  private static final String QUEUE_NAME = "hello";

  public static void main(String[] argv) throws IOException, TimeoutException {
    ConnectionFactory factory = new ConnectionFactory();
    factory.setHost("localhost");
    Connection connection = factory.newConnection();
    Channel channel = connection.createChannel();
    channel.queueDeclare(QUEUE_NAME, false, false, false, null);
    String message = "Welcome to RabbitMQ";
    channel.basicPublish("", QUEUE_NAME, null, message.getBytes("UTF-8"));
    logger.debug("[!] Sent '" + message + "'");
    channel.close();
    connection.close();
  }
}
