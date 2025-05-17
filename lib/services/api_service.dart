import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/question.dart';

class ApiService 
{
  Future<List<Question>> fetchQuestions
  ({
    required int categoryId,
    int amount = 10,
    String difficulty = 'easy',
  }) 
  async 
  {
    final url = Uri.parse
    (
      'https://opentdb.com/api.php?amount=$amount&category=$categoryId&difficulty=$difficulty&type=multiple',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) 
    {
      final data = jsonDecode(response.body);

      if (data['response_code'] == 0) 
      {
        return (data['results'] as List)
            .map((json) => Question.fromJson(json))
            .toList();
      } 
      else 
      {
        throw Exception('API hata kodu: ${data['response_code']}');
      }
    } 
    else 
    {
      throw Exception('HTTP hata: ${response.statusCode}');
    }
  }
}