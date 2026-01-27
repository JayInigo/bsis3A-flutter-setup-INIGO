import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      ),
      home: const QuizWidget(),
    );
  }
}

class QuizWidget extends StatefulWidget {
  const QuizWidget({super.key});

  @override
  State<QuizWidget> createState() => _QuizWidgetState();
}

class _QuizWidgetState extends State<QuizWidget> with SingleTickerProviderStateMixin {
  bool quizStarted = false;
  int currentQuestionIndex = 0;
  int score = 0;
  bool answerSelected = false;
  int? selectedAnswerIndex;
  List<Map<String, dynamic>> shuffledQuestions = [];
  List<int> userAnswers = [];
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<Map<String, dynamic>> questions = [
    {
      'question':
          'Which feature would help BIGGS branches in Naga City manage customer flow during peak hours?',
      'answers': [
        'Digital queue number system with estimated wait time',
        'Pre-order and scheduled pickup system',
        'Table reservation with real-time availability',
        'Customer feedback and rating system'
      ],
      'correctAnswer': 0,
      'explanation': 'A digital queue number system helps manage crowds by letting customers see their position in line and estimated wait time on their phones, reducing congestion at the counter.',
    },
    {
      'question':
          "What mobile app feature would most benefit Mercury Drug stores in Quezon City?",
      'answers': [
        'Prescription refill reminders and online ordering',
        'Medicine inventory checker across branches',
        'Senior citizen discount card registration',
        'Pharmacist consultation booking system'
      ],
      'correctAnswer': 1,
      'explanation':
          'An inventory checker lets customers find out which branch has their needed medicine in stock before traveling, saving time and effort.',
    },
    {
      'question':
          'Which feature would help Tropical Hut Hamburger in Cubao, Quezon City improve their service?',
      'answers': [
        'Loyalty points and digital stamp card',
        'Advance ordering for takeout/delivery',
        'Menu item availability updates',
        'Group order and party reservation system'
      ],
      'correctAnswer': 1,
      'explanation': 'Advance ordering allows customers to place orders ahead of time and pick up their food ready, reducing wait time during busy hours.',
    },
    {
      'question':
          'What would help barangay health centers in Quezon City serve residents better?',
      'answers': [
        'Vaccination appointment scheduling', 
        'Health record access and document requests', 
        'Medicine availability notifications', 
        'Online health consultation queue system'
      ],
      'correctAnswer': 0,
      'explanation':
          'An appointment scheduling system prevents long queues and overcrowding by organizing vaccination schedules, especially important during health campaigns.',
    },
    {
      'question':
          'Which feature would benefit LBC Express branches in Quezon City the most?',
      'answers': [
        'Real-time package tracking with GPS', 
        'Pickup request scheduling from home', 
        'Branch queue number and estimated service time', 
        'Shipping rate calculator and comparison tool'
      ],
      'correctAnswer': 2,
      'explanation': 'A queue number system with wait time helps customers avoid long lines at the branch by checking how busy it is before going there.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void startQuiz() {
    setState(() {
      shuffledQuestions = List.from(questions)..shuffle(Random());
      quizStarted = true;
      currentQuestionIndex = 0;
      score = 0;
      answerSelected = false;
      selectedAnswerIndex = null;
      userAnswers = [];
    });
    _animationController.forward(from: 0.0);
  }

  void selectAnswer(int answerIndex) {
    setState(() {
      selectedAnswerIndex = answerIndex;
      answerSelected = true;
      userAnswers.add(answerIndex);

      if (answerIndex == shuffledQuestions[currentQuestionIndex]['correctAnswer']) {
        score++;
      }
    });
  }

  void nextQuestion() {
    if (currentQuestionIndex < shuffledQuestions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        answerSelected = false;
        selectedAnswerIndex = null;
      });
      _animationController.forward(from: 0.0);
    } else {
      setState(() {
        quizStarted = false;
      });
    }
  }

  void restartQuiz() {
    setState(() {
      quizStarted = false;
      currentQuestionIndex = 0;
      score = 0;
      answerSelected = false;
      selectedAnswerIndex = null;
      userAnswers = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.deepPurple.shade400,
              Colors.deepPurple.shade800,
            ],
          ),
        ),
        child: SafeArea(
          child: !quizStarted && currentQuestionIndex == 0 && score == 0
              ? buildStartView()
              : quizStarted
                  ? buildQuizView()
                  : buildEndView(),
        ),
      ),
    );
  }

  Widget buildStartView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.lightbulb,
                size: 100,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              'Quiz Time!',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Test your knowledge with this\n${questions.length} business questions',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: startQuiz,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.deepPurple,
                padding:
                    const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 5,
              ),
              child: const Text(
                'Start Quiz',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildQuizView() {
    final currentQuestion = shuffledQuestions[currentQuestionIndex];

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Question ${currentQuestionIndex + 1}/${shuffledQuestions.length}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.stars, color: Colors.amber, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Score: $score',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: (currentQuestionIndex + 1) / shuffledQuestions.length,
                backgroundColor: Colors.white.withOpacity(0.3),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              currentQuestion['question'],
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 40),
                            ...List.generate(
                              4,
                              (index) => Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Material(
                                  elevation:
                                      answerSelected && selectedAnswerIndex == index
                                          ? 8
                                          : 2,
                                  borderRadius: BorderRadius.circular(15),
                                  child: InkWell(
                                    onTap:
                                        answerSelected ? null : () => selectAnswer(index),
                                    borderRadius: BorderRadius.circular(15),
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: selectedAnswerIndex == index
                                            ? (index ==
                                                    currentQuestion['correctAnswer']
                                                ? Colors.green
                                                : Colors.red)
                                            : (answerSelected &&
                                                    index ==
                                                        currentQuestion[
                                                            'correctAnswer']
                                                ? Colors.green.shade100
                                                : Colors.grey.shade100),
                                        border: Border.all(
                                          color: selectedAnswerIndex == index
                                              ? Colors.transparent
                                              : (answerSelected &&
                                                      index ==
                                                          currentQuestion[
                                                              'correctAnswer']
                                                  ? Colors.green
                                                  : Colors.grey.shade300),
                                          width: 2,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 32,
                                            height: 32,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: selectedAnswerIndex == index
                                                  ? Colors.white
                                                  : (answerSelected &&
                                                          index ==
                                                              currentQuestion[
                                                                  'correctAnswer']
                                                      ? Colors.green
                                                      : Colors.deepPurple.shade100),
                                            ),
                                            child: Center(
                                              child: Text(
                                                String.fromCharCode(65 + index),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: selectedAnswerIndex == index
                                                      ? (index ==
                                                              currentQuestion[
                                                                  'correctAnswer']
                                                          ? Colors.green
                                                          : Colors.red)
                                                      : (answerSelected &&
                                                              index ==
                                                                  currentQuestion[
                                                                      'correctAnswer']
                                                          ? Colors.white
                                                          : Colors.deepPurple),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: Text(
                                              currentQuestion['answers'][index],
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: selectedAnswerIndex == index
                                                    ? Colors.white
                                                    : Colors.black87,
                                              ),
                                            ),
                                          ),
                                          if (answerSelected &&
                                              (selectedAnswerIndex == index ||
                                                  index ==
                                                      currentQuestion[
                                                          'correctAnswer']))
                                            Icon(
                                              index == currentQuestion['correctAnswer']
                                                  ? Icons.check_circle
                                                  : Icons.cancel,
                                              color: selectedAnswerIndex == index
                                                  ? Colors.white
                                                  : Colors.green,
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            if (answerSelected)
                              Container(
                                margin: const EdgeInsets.only(top: 20),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.blue.shade200,
                                    width: 2,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.lightbulb_outline,
                                      color: Colors.blue.shade700,
                                      size: 24,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        currentQuestion['explanation'],
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.blue.shade900,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (answerSelected)
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: ElevatedButton(
                  onPressed: nextQuestion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5,
                  ),
                  child: Text(
                    currentQuestionIndex < shuffledQuestions.length - 1
                        ? 'Next Question'
                        : 'See Results',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildEndView() {
    final percentage = (score / shuffledQuestions.length * 100).round();
    final emoji = percentage >= 80
        ? '🎉'
        : percentage >= 60
            ? '😊'
            : percentage >= 40
                ? '😐'
                : '😔';

    String message = percentage >= 80
        ? 'Excellent!'
        : percentage >= 60
            ? 'Good Job!'
            : percentage >= 40
                ? 'Not Bad!'
                : 'Keep Trying!';

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                emoji,
                style: const TextStyle(fontSize: 80),
              ),
              const SizedBox(height: 20),
              Text(
                message,
                style: const TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'Your Score',
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '$score',
                          style: const TextStyle(
                            fontSize: 72,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Text(
                            ' / ${shuffledQuestions.length}',
                            style: TextStyle(
                              fontSize: 32,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.shade50,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '$percentage%',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              ElevatedButton.icon(
                onPressed: restartQuiz,
                icon: const Icon(Icons.refresh, size: 28),
                label: const Text(
                  'Try Again',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40, vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}