import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/models/question.dart';
import 'package:flutter_application_1/services/api_service.dart';

void main(List<String> args) 
{
  runApp(const MyApp());
}

class MyApp extends StatelessWidget 
{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) 
  {
    return MaterialApp
    (
      debugShowCheckedModeBanner: false,
      home: const ilkSayfa(),
    );
  }
}

class ilkSayfa extends StatelessWidget 
{
  const ilkSayfa({super.key});

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 238, 247, 232),
      appBar: AppBar
      (
        title: const Text("Mini Quiz Oyunu"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 201, 223, 245),
      ),
      body: Center
      (
        child: Column
        (
          children: 
          [
            const SizedBox(height: 100),
            const Text
            (
              "HOŞGELDİNİZ",
              style: TextStyle
              (
                fontSize: 30,
                color: Color.fromARGB(255, 129, 134, 139),
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 150),
            textButton
            (
              "Başla",
              () {
                Navigator.push
                (
                  context,
                  MaterialPageRoute
                  (
                    builder: (context) => const ikinciSayfa(),
                  ),
                );
              },
            ),
            const SizedBox(height: 50),
            textButton
            (
              "Çıkış",
              () async {
                final bool? exitConfirmed = await showDialog<bool>
                (
                  context: context,
                  builder: (context) => AlertDialog
                  (
                    title: const Text('Uygulamadan Çık'),
                    content: const Text('Uygulamadan çıkmak istediğinizden emin misiniz?'),
                    actions: 
                    [
                      TextButton
                      (
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('Hayır'),
                      ),
                      TextButton
                      (
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text('Evet'),
                      ),
                    ],
                  ),
                );

                if (exitConfirmed == true) 
                {
                  SystemNavigator.pop();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ikinciSayfa extends StatelessWidget 
{
  const ikinciSayfa({super.key});

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold
    (
      backgroundColor: const Color.fromARGB(255, 238, 247, 232),
      appBar: AppBar
      (
        title: const Text("Kategori Seçimi"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 201, 223, 245),
      ),
      body: Center
      (
        child: Column
        (
          mainAxisAlignment: MainAxisAlignment.center,
          children: 
          [
            const Text
            (
              "Lütfen bir kategori seçiniz",
              style: TextStyle
              (
                fontSize: 30,
                color: Color.fromARGB(255, 129, 134, 139),
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 100),
            textButton
            (
              "Genel Kültür",
              () {
                Navigator.push
                (
                  context,
                  MaterialPageRoute
                  (
                    builder: (context) => const QuizSayfasi(kategori: "Genel Kültür"),
                  ),
                );
              },
            ),
            const SizedBox(height: 30),
            textButton
            (
              "Matematik",
              () {
                Navigator.push
                (
                  context,
                  MaterialPageRoute
                  (
                    builder: (context) => const QuizSayfasi(kategori: "Matematik"),
                  ),
                );
              },
            ),
            const SizedBox(height: 30),
            textButton
            (
              "Sinema",
              () {
                Navigator.push
                (
                  context,
                  MaterialPageRoute
                  (
                    builder: (context) => const QuizSayfasi(kategori: "Sinema"),
                  ),
                );
              },
            ),
            const SizedBox(height: 30),
            textButton
            (
              "Bilim",
              () {
                Navigator.push
                (
                  context,
                  MaterialPageRoute
                  (
                    builder: (context) => const QuizSayfasi(kategori: "Bilim"),
                  ),
                );
              },
            ),
            const SizedBox(height: 30),
            textButton
            (
              "Tarih",
              () {
                Navigator.push
                (
                  context,
                  MaterialPageRoute
                  (
                    builder: (context) => const QuizSayfasi(kategori : "Tarih"),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

 

class QuizSayfasi extends StatefulWidget 
{
  final String kategori;
  const QuizSayfasi({super.key, required this.kategori});

  @override
  _QuizSayfasiState createState() => _QuizSayfasiState();
}

class _QuizSayfasiState extends State<QuizSayfasi> 
{
  final ApiService apiService = ApiService();
  List<Question> questions = [];
  int currentQuestionIndex = 0;
  int score = 0;
  bool isLoading = true;
  String? errorMessage;

  // Kategoriye göre OpenTDB categoryId eşleştirmesi
  int getCategoryId(String kategori) 
  {
    switch (kategori) {
      case 'Genel Kültür':
        return 9; // General Knowledge
      case 'Matematik':
        return 19; // Science: Mathematics
      case 'Sinema':
        return 11; // Entertainment: Film
      case 'Bilim':
        return 17; // Science & Nature
      case 'Tarih':
        return 23; // History
      default:
        return 9;
    }
  }

  @override
  void initState()
   {
    super.initState();
    fetchQuestions();
  }

  Future<void> fetchQuestions() async
   {
    try
     {
      final fetchedQuestions = await apiService.fetchQuestions
      (
        categoryId: getCategoryId(widget.kategori),
        amount: 10,
        difficulty: 'easy',
      );
      setState(() 
      {
        questions = fetchedQuestions;
        isLoading = false;
      });
    } 
    catch (e) 
    {
      setState(() 
      {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  void checkAnswer(String selectedAnswer)
   {
    if (selectedAnswer == questions[currentQuestionIndex].correctAnswer) 
    {
      setState(() 
      {
        score += 10;
      });
    }
    if (currentQuestionIndex < questions.length - 1) 
    {
      setState(()
       {
        currentQuestionIndex++;
      });
    } 
    else
    {
      showDialog
      (
        context: context,
        builder: (context) => AlertDialog
        (
          title: const Text('Quiz Bitti!'),
          content: Text('Puanınız: $score'),
          actions: 
          [
            TextButton
            (
              onPressed: ()
               {
                Navigator.pop(context);
                setState(()
              {
                  currentQuestionIndex = 0;
                  score = 0;
                  isLoading = true;
                  fetchQuestions();
                });
              },
              child: const Text('Tekrar Oyna'),
            ),
            TextButton(
              onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
              child: const Text('Ana Menü'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 238, 247, 232),
      appBar: AppBar(
        title: Text('${widget.kategori} Kategorisi'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 201, 223, 245),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text('Hata: $errorMessage'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        questions[currentQuestionIndex].question,
                        style: const TextStyle(
                          fontSize: 24,
                          color: Color.fromARGB(255, 129, 134, 139),
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 30),
                      ...questions[currentQuestionIndex].options.map(
                        (option) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: textButton(
                            option,
                            () => checkAnswer(option),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Text(
                        'Puan: $score',
                        style: const TextStyle(
                          fontSize: 20,
                          color: Color.fromARGB(255, 129, 134, 139),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}

TextButton textButton(String text, Function() onPressed) 
{
  return TextButton
  (
    onPressed: onPressed,
    style: TextButton.styleFrom
    (
      backgroundColor: const Color.fromARGB(255, 201, 223, 245),
      padding: const EdgeInsets.symmetric
      (
        horizontal: 50,
        vertical: 20,
      ),
      shape: RoundedRectangleBorder
      (
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    child: Text
    (
      text,
      style: const TextStyle
      (
        fontSize: 20,
        color: Colors.black,
      ),
    ),
  );
}