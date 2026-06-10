require("dotenv").config();

const express = require("express");
const cors = require("cors");

const uploadRoutes = require("./routes/uploadRoutes");
const briefRoutes = require("./routes/briefRoutes");
const flashcardRoutes = require("./routes/flashcardRoutes");

const app = express();

app.use(cors());
app.use(express.json());

app.use("/api/upload", uploadRoutes);
app.use("/generate-brief", briefRoutes);
app.use("/generate-flashcards", flashcardRoutes);

app.get("/", (req, res) => {
    res.send("Backend Running");
});

app.listen(5000, () => {
    console.log("Server running on port 5000");
});