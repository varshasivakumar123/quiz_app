import 'package:flutter/material.dart';
import 'services/api_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AI Questionnaire Builder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const QuestionScreen(),
    );
  }
}

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({super.key});

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  final TextEditingController controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  
  List<dynamic> briefQuestions = [];
  List<dynamic> flashcards = [];

  bool isLoading = false;
  String? errorMessage;

  int selectedTab = 0;

  Future<void> generateQuestions() async {
    if (controller.text.trim().isEmpty) {
      setState(() {
        errorMessage = "Please enter a topic";
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
      briefQuestions  = [];
    });

    try {
      final result = await ApiService().generateBriefQuestions(controller.text.trim());
      
      setState(() {
        briefQuestions = result;
        isLoading = false;
      });

      await generateFlashcards();
      
      // Clear focus after generation
      _focusNode.unfocus();
    } catch (e) {
      setState(() {
        errorMessage = "Failed to generate questions: ${e.toString()}";
        isLoading = false;
      });
    }
  }
  Future<void> generateFlashcards() async {
  try {
    final result = await ApiService()
        .generateFlashcards(controller.text.trim());

    setState(() {
      flashcards = result;
      selectedTab = 1;
    });
  } catch (e) {
    print(e);
  }
}
  @override
  void dispose() {
    controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "📚 AI Study Assistant",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              "Enter any topic and instantly generate questions",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Enter any topic and instantly generate questions",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: controller,
              focusNode: _focusNode,
              decoration: InputDecoration(
                hintText: "Enter Topic",
                prefixIcon: const Icon(Icons.school),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                errorText: errorMessage,
              ),
              onSubmitted: (_) => generateQuestions(),
            ),
            const SizedBox(height: 20),
            const Text(
  "OR",
  style: TextStyle(
    fontWeight: FontWeight.bold,
  ),
),

const SizedBox(height: 20),

OutlinedButton.icon(
  onPressed: () {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("PDF Upload Coming Soon"),
      ),
    );
  },
  icon: const Icon(Icons.upload_file),
  label: const Text("Upload PDF"),
),

const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: isLoading ? null : generateQuestions,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text(
                        "Generate Questions",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedTab = 0;
                      });
                    },
                    child: const Text("Brief Answers"),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedTab = 1;
                      });
                    },
                    child: const Text("Flashcards"),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
            if (briefQuestions.isEmpty && !isLoading)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.question_answer_outlined,
                        size: 80,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "No questions yet",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Enter a topic and click generate",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else if (briefQuestions.isNotEmpty)
              Expanded(
              child: ListView.builder(
                itemCount: selectedTab == 0
                    ? briefQuestions.length
                    : flashcards.length,
                itemBuilder: (context, index) {

                  if (selectedTab == 0) {

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Q${index + 1}: ${briefQuestions[index]["question"]}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 8),

                            Text(
                              "Answer: ${briefQuestions[index]["answer"]}",
                              style: const TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );

                  } else {

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Front: ${flashcards[index]["front"]}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 8),

                            Text(
                              "Back: ${flashcards[index]["back"]}",
                              style: const TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );

                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}