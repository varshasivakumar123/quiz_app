const express = require("express");
const cors = require("cors");

const app = express();

app.use(cors());
app.use(express.json());

app.post("/generate", (req, res) => {
  const { topic } = req.body;

  const questions = [
    `What is ${topic}?`,
    `Explain ${topic} with an example.`,
    `Why is ${topic} important?`,
    `What are the advantages of ${topic}?`,
    `Write a short note on ${topic}.`
  ];

  res.json({ questions });
});

app.listen(5000, () => {
  console.log("Server running on port 5000");
});