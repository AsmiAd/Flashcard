// import 'dart:convert'; // <-- Add this
// import 'package:google_generative_ai/google_generative_ai.dart';

// class GeminiService {
//   final GenerativeModel _model;

//   GeminiService(String apiKey)
//       : _model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);

//   Future<List<Map<String, String>>> generateFlashcards(String topic) async {
//     final prompt = """
//     Create 5 beginner-friendly flashcards about "$topic".
//     Return only JSON in this format:
//     [
//       {"question": "What is ...?", "answer": "It is ..."},
//       {"question": "...", "answer": "..."}
//     ]
//     """;

//     final response = await _model.generateContent([
//       Content.text(prompt),
//     ]);

//     final text = response.text ?? '[]';
//     try {
//       final List<dynamic> json = List<dynamic>.from(jsonDecode(text)); // now works
//       return json
//           .map((e) => {
//                 "question": e["question"].toString(),
//                 "answer": e["answer"].toString(),
//               })
//           .toList();
//     } catch (_) {
//       return [];
//     }
//   }
// }
