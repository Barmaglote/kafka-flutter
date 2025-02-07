const express = require('express');
const { Kafka } = require('kafkajs');
const bodyParser = require('body-parser');

const app = express();
const port = 3000;

app.use(bodyParser.json());

const kafka = new Kafka({
  clientId: 'flutter-kafka-app',
  brokers: ['localhost:9092'],
});
const producer = kafka.producer();

app.post('/send', async (req, res) => {
  const { message } = req.body;

  try {
    await producer.connect();
    await producer.send({
      topic: 'test-topic',
      messages: [{ value: message }],
    });

    await producer.disconnect();
    res.status(200).json({ message: 'Message sent to Kafka' });
  } catch (error) {
    console.error('Error sending message to Kafka:', error);
    res.status(500).json({ message: 'Failed to send message' });
  }
});

app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});
