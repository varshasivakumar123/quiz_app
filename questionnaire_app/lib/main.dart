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
  
  List<String> questions = [];
  bool isLoading = false;
  String? errorMessage;

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
      questions = [];
    });

    try {
      final result = await ApiService().generateQuestions(controller.text.trim());
      
      setState(() {
        questions = result.cast<String>();
        isLoading = false;
      });
      
      // Clear focus after generation
      _focusNode.unfocus();
    } catch (e) {
      setState(() {
        errorMessage = "Failed to generate questions: ${e.toString()}";
        isLoading = false;
      });
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
          "📚 AI Questionnaire Builder",
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
              "Generate Smart Questions",
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
            if (questions.isEmpty && !isLoading)
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
            else if (questions.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: questions.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          "${index + 1}. ${questions[index]}",
                          style: const TextStyle(
                            fontSize: 16,
                            height: 1.4,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}