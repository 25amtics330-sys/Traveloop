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
  // Controllers to capture what the user types
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Loading state for the button
  bool _isLoading = false;
  String _errorMessage = '';
  String _successMessage = '';

  // Your backend API URL
  // Change this to your server's IP if testing on a real phone
  final String baseUrl = 'http://localhost:5000/api/auth';

  // ---- REGISTER FUNCTION ----
  // This sends all user data to your backend
  Future<void> _register() async {
    // Clear previous messages
    setState(() {
      _errorMessage = '';
      _successMessage = '';
    });

    // Validate required fields
    if (_firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _usernameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please fill in all required fields';
      });
      return;
    }

    // Show loading spinner
    setState(() {
      _isLoading = true;
    });

    try {
      // Send POST request to backend
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
        // Registration successful! Show success message and navigate to login
        setState(() {
          _successMessage = data['message'] ?? 'Registered successfully!';
        });

        // Wait 1.5 seconds so user can see success message, then go to login
        await Future.delayed(const Duration(milliseconds: 1500));

        if (mounted) {
          Navigator.pushReplacementNamed(context, '/login');
        }
      } else {
        // Registration failed — show error message from backend
        setState(() {
          _errorMessage = data['message'] ?? 'Registration failed';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Cannot connect to server. Is it running?';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            height: 700,
            width: 700,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: AppColors.accentLight,
            ),
            padding: const EdgeInsets.all(20),
            child: Container(
              height: 670,
              width: 670,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: AppColors.card,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Register',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text,
                        ),
                      ),
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color.fromARGB(137, 157, 0, 0)),
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                    ],
                  ),

                  // First Name & Last Name
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _firstNameController,
                          decoration: InputDecoration(
                            labelText: 'First Name',
                            isDense: true,
                            border: const OutlineInputBorder(),
                            fillColor: AppColors.card,
                            filled: true,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: _lastNameController,
                          decoration: InputDecoration(
                            labelText: 'Last Name',
                            isDense: true,
                            border: const OutlineInputBorder(),
                            fillColor: AppColors.card,
                            filled: true,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Email & Phone Number
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            isDense: true,
                            border: const OutlineInputBorder(),
                            fillColor: AppColors.card,
                            filled: true,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: 'Phone Number',
                            isDense: true,
                            border: const OutlineInputBorder(),
                            fillColor: AppColors.card,
                            filled: true,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // City & Country (matches backend fields)
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _cityController,
                          decoration: InputDecoration(
                            labelText: 'City',
                            isDense: true,
                            border: const OutlineInputBorder(),
                            fillColor: AppColors.card,
                            filled: true,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: _countryController,
                          decoration: InputDecoration(
                            labelText: 'Country',
                            isDense: true,
                            border: const OutlineInputBorder(),
                            fillColor: AppColors.card,
                            filled: true,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Username & Password
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            labelText: 'Username',
                            isDense: true,
                            border: const OutlineInputBorder(),
                            fillColor: AppColors.card,
                            filled: true,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            isDense: true,
                            border: const OutlineInputBorder(),
                            fillColor: AppColors.card,
                            filled: true,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Error message
                  if (_errorMessage.isNotEmpty)
                    Text(
                      _errorMessage,
                      style: TextStyle(color: AppColors.danger, fontSize: 14),
                    ),

                  // Success message
                  if (_successMessage.isNotEmpty)
                    Text(
                      _successMessage,
                      style: const TextStyle(
                          color: Color(0xFF2EC4B6), fontSize: 14),
                    ),

                  // Register button with loading state
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      foregroundColor: AppColors.card,
                      minimumSize: const Size(double.infinity, 0),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    onPressed: _isLoading ? null : _register,
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('Register'),
                  ),

                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    child: const Text('Already have an account? Login'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      appBar: AppBar(
        title: const Text('Traveloop'),
        leading: const Icon(Icons.travel_explore),
        centerTitle: true,
      ),
    );
  }
}