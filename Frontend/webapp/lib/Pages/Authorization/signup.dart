import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../main.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cityController = TextEditingController();
  final _countryController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  String _errorMessage = '';
  String _successMessage = '';

  final String baseUrl = 'http://localhost:5000/api/auth';

  Future<void> _register() async {
    setState(() { _errorMessage = ''; _successMessage = ''; _isLoading = true; });

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'first_name': _firstNameController.text.trim(),
          'last_name': _lastNameController.text.trim(),
          'username': _usernameController.text.trim(),
          'email': _emailController.text.trim(),
          'phone': _phoneController.text.trim(),
          'city': _cityController.text.trim(),
          'country': _countryController.text.trim(),
          'password': _passwordController.text,
        }),
      );

      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        setState(() {
          _successMessage = 'Account created! Please login.';
        });
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/login');
        }
      } else {
        setState(() { _errorMessage = data['message'] ?? 'Registration failed'; });
      }
    } catch (e) {
      setState(() { _errorMessage = 'Cannot connect to server. Is it running?'; });
    } finally {
      if (mounted) setState(() { _isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isPhone = screenWidth < 600;
    final containerWidth = isPhone ? screenWidth * 0.9 : screenWidth * 0.6;
    final padding = isPhone ? 16.0 : 20.0;
    final titleSize = isPhone ? 28.0 : 36.0;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('Traveloop'), centerTitle: true),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Container(
            width: containerWidth,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: AppColors.accentLight,
            ),
            padding: EdgeInsets.all(padding),
            child: Container(
              padding: EdgeInsets.all(padding),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: AppColors.card,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Register', style: TextStyle(fontSize: titleSize, fontWeight: FontWeight.bold, color: AppColors.text)),
                  const SizedBox(height: 20),
                  
                  Row(children: [
                    Expanded(child: TextField(controller: _firstNameController, decoration: const InputDecoration(labelText: 'First Name', border: OutlineInputBorder()))),
                    const SizedBox(width: 12),
                    Expanded(child: TextField(controller: _lastNameController, decoration: const InputDecoration(labelText: 'Last Name', border: OutlineInputBorder()))),
                  ]),
                  const SizedBox(height: 12),
                  
                  TextField(controller: _emailController, decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder())),
                  const SizedBox(height: 12),
                  
                  Row(children: [
                    Expanded(child: TextField(controller: _phoneController, decoration: const InputDecoration(labelText: 'Phone', border: OutlineInputBorder()))),
                    const SizedBox(width: 12),
                    Expanded(child: TextField(controller: _usernameController, decoration: const InputDecoration(labelText: 'Username', border: OutlineInputBorder()))),
                  ]),
                  const SizedBox(height: 12),
                  
                  Row(children: [
                    Expanded(child: TextField(controller: _cityController, decoration: const InputDecoration(labelText: 'City', border: OutlineInputBorder()))),
                    const SizedBox(width: 12),
                    Expanded(child: TextField(controller: _countryController, decoration: const InputDecoration(labelText: 'Country', border: OutlineInputBorder()))),
                  ]),
                  const SizedBox(height: 12),
                  
                  TextField(controller: _passwordController, decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder()), obscureText: true),
                  
                  if (_errorMessage.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(_errorMessage, style: const TextStyle(color: Colors.red, fontSize: 13)),
                  ],
                  if (_successMessage.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(_successMessage, style: const TextStyle(color: Colors.green, fontSize: 13)),
                  ],
                  
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent, foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 50)),
                    onPressed: _isLoading ? null : _register,
                    child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Register'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/login'),
                    child: const Text('Already have an account? Login'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}