function briefPrompt(topic) {
    return `
Generate 5 short answer questions and answers about ${topic}.

Return ONLY valid JSON.

[
 {
   "question":"...",
   "answer":"..."
 }
]
`;
}

function flashcardPrompt(topic) {
    return `
Generate 10 flashcards about ${topic}.

Return ONLY valid JSON.

[
 {
   "front":"...",
   "back":"..."
 }
]
`;
}

module.exports = {
    briefPrompt,
    flashcardPrompt
};