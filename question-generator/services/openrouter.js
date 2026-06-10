const axios = require("axios");

async function generateBriefQuestions(topic) {
    console.log("Calling OpenRouter...");
    const response = await axios.post(
        "https://openrouter.ai/api/v1/chat/completions",
        {
            model: "openai/gpt-oss-120b:free",

            messages: [
                {
                    role: "user",
                    content:
                        `Generate 5 short answer questions and answers about ${topic}.
                        
                        Return ONLY valid JSON in this format:

                        [
                          {
                            "question":"...",
                            "answer":"..."
                          }
                        ]`
                }
            ]
        },
        {
            headers: {
                Authorization: `Bearer ${process.env.OPENROUTER_API_KEY}`,
                "Content-Type": "application/json"
            }
        }
    );

    return response.data.choices[0].message.content;
}



async function generateFlashcards(topic) {

    const response = await axios.post(
        "https://openrouter.ai/api/v1/chat/completions",
        {
            model: "openai/gpt-oss-120b:free",

            messages: [
                {
                    role: "user",
                    content: `
Generate 10 flashcards about ${topic}.

Return ONLY valid JSON.

Format:

[
  {
    "front":"Question here",
    "back":"Answer here"
  }
]
`
                }
            ]
        },
        {
            headers: {
                Authorization: `Bearer ${process.env.OPENROUTER_API_KEY}`,
                "Content-Type": "application/json"
            }
        }
    );

    return response.data.choices[0].message.content;
}

module.exports = {
    generateBriefQuestions,
    generateFlashcards
};