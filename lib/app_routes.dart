
import 'package:flutter/material.dart';
import '../screens/auth/auth_checker.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/deckDetail/deck_details_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/nav/main_screen.dart';
import '../screens/test/test_mode_screen.dart';
import 'models/deck_model.dart';
import 'screens/add/add_screen.dart';
import 'screens/decks/decks_screen.dart';
import 'screens/flashcard/flashcards_screen.dart';
import 'screens/profile/feedback_screen.dart';
import 'screens/profile/help_screen.dart';
import 'screens/study/random_mix_screen.dart';
import 'screens/study/spaced_repetition_screen.dart';
import 'screens/study/study_screen.dart';
import 'screens/test/quiz_mode_screen.dart';
import 'screens/test/random_mix_mode_screen.dart';
import 'screens/test/timed_mode_screen.dart';
import 'screens/test/true_false_mode_screen.dart';

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const DecksScreen());
      case '/study':
        return MaterialPageRoute(builder: (_) => const StudyScreen());
      case '/test':
        return MaterialPageRoute(builder: (_) => const TestModeScreen());
      case '/main_screen':
        return MaterialPageRoute(builder: (_) => const MainScreen());
      case '/register':
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case '/forgot-password':
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      case '/auth':
        return MaterialPageRoute(builder: (_) => const AuthChecker());
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      // case '/notifications':
      //   return MaterialPageRoute(builder: (_) => const NotificationScreen());
      case '/feedback':
        return MaterialPageRoute(builder: (_) => const FeedbackScreen());
      case '/help':
        return MaterialPageRoute(builder: (_) => const HelpScreen());
      case '/add':
        return MaterialPageRoute(builder: (_) => const AddScreen());
      case '/quiz':{
  final deck = settings.arguments as Deck;  // get deck from args
  return MaterialPageRoute(
    builder: (_) => QuizModeScreen(deck: deck),  // pass deck here
  );}


      case '/truefalse':{
        final deck = settings.arguments as Deck; 
        return MaterialPageRoute(
          builder: (_) => TrueFalseModeScreen(deck: deck),
        );}

      case '/timed':{
        final deck = settings.arguments as Deck;
        return MaterialPageRoute(
          builder: (_) => TimedModeScreen(deck: deck),
        );}

      case '/randommix':
        return MaterialPageRoute(builder: (_) => const RandomMixScreen());

      
      case '/random_mix':
        {
          return MaterialPageRoute(
            builder: (_) => const RandomMixStudyScreen(),
          );
        }

      

      

      case '/spaced_repetition':
        {
          final deckId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (_) => SpacedRepetitionScreen(deckId: deckId),
          );
        }

      case '/flashcards':{
  final deck = settings.arguments as Deck;
  return MaterialPageRoute(
    builder: (_) => FlashcardsScreen(deck: deck),
  );}


      case '/deck-details':
        final deckId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => DeckDetailsScreen(deckId: deckId),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
