import 'package:flutter/material.dart';
import 'package:hackathon/core/theme.dart';
import 'package:hackathon/providers/app_provider.dart';
import 'package:hackathon/screens/auth/login_screen.dart';
import 'package:hackathon/screens/home_screen.dart';
import 'package:hackathon/services/api_service.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mulkly App',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      home: AuthCheck(),
    );
  }
}

class AuthCheck extends StatefulWidget {
  const AuthCheck({super.key});

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();

    _checkAuth();
  }

  Future _checkAuth() async {
    AppProvider appProvider = context.read();
    final isAuthenticated = await appProvider.checkAuth();

    print('Is Authenticated: $isAuthenticated');

    if (!mounted) return;

    return Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => isAuthenticated ? HomeScreen() : LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
