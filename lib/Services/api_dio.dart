import 'package:dio/dio.dart';
import 'package:my_quiz/models/Questions.dart';

class ApiService {
  final Dio _dio = Dio();

  Future<List<Category>> fetchCategories() async {
    try {
      final response = await _dio.get(
        'https://mocki.io/v1/cd823858-b79d-42aa-ab86-24a2bbc5026b',
        options: Options(
          receiveTimeout: Duration(seconds: 10),
          sendTimeout: Duration(seconds: 5),
        ),
      );

      if (response.statusCode == 200) {
        if (response.data is List) {
          return (response.data as List)
              .map((json) => Category.fromJson(json))
              .toList();
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } on DioException catch (dioError) {
      throw Exception('Network error: ${dioError.message}');
    } catch (e) {
      print(' Error fetching categories: $e');
      throw Exception('Something went wrong');
    }
  }
}
