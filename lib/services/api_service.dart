import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

class ApiService {
  ApiService(this._auth);

  final FirebaseAuth _auth;

  static const String _baseUrl =
      'http://10.0.2.2:8080'; // your backend API base URL

  Future<String> _token() async =>
      (await _auth.currentUser?.getIdToken()) ?? '';

  Future<Map<String, String>> _headers() async => {
        'Authorization': 'Bearer ${await _token()}',
        'Content-Type': 'application/json',
      };

  Future<http.Response> _get(String path) async => http.get(
        Uri.parse('$_baseUrl$path'),
        headers: await _headers(),
      );

  Future<http.Response> _post(
    String path, {
    Object? body,
    int expected = 200,
  }) async {
    final res = await http.post(
      Uri.parse('$_baseUrl$path'),
      headers: await _headers(),
      body: body,
    );
    if (res.statusCode != expected) {
      throw Exception('API ${res.statusCode}: ${res.body}');
    }
    return res;
  }



    


  }

