const express = require("express");
const { generateBriefQuestions } = require("../services/openrouter");

const router = express.Router();

router.post("/", async (req, res) => {

    try {

        const { topic } = req.body;

        const result = await generateBriefQuestions(topic);

        res.json({
            data: result
        });

    } catch (error) {

        console.error(error);

        res.status(500).json({
          error: error.response?.data || error.message
        });

    }

});

module.exports = router;