const express = require("express");

const {
    generateFlashcards
} = require("../services/openrouter");

const router = express.Router();

router.post("/", async (req, res) => {

    try {

        const { topic } = req.body;

        const result = await generateFlashcards(topic);

        const parsedResult = JSON.parse(result);

        res.json(parsedResult);

    } catch (error) {

        console.error(error);

        res.status(500).json({
            error: "Failed to generate flashcards"
        });

    }

});

module.exports = router;