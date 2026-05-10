import 'package:flutter/material.dart';
import '../../../main.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My',
      home: Scaffold(
        backgroundColor: AppColors.bg,
        body: 
        Center(
          child: Container(
            
            height: 600,
            width: 700,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: AppColors.card,
            ),
            
            padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text( 
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                    ),
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                      fillColor: AppColors.card,
                      filled: true,
                    ),
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                      fillColor: AppColors.card,
                      filled: true,
                    ),
                    obscureText: true,
                  ),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      foregroundColor: AppColors.card,
                      minimumSize: Size(double.infinity, 0),
                      padding: EdgeInsets.symmetric(vertical: 15),
                    ),
                    onPressed: () {
                      // Handle sign up logic here
                    },
                    child: Text('Sign Up'),
                  ),
                  TextButton(onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  }, child: Text('Already have an account? Login')),

                  TextButton(
                    onPressed: () {
                      // Handle forgot password logic here
                    },
                    child: Text('Forgot Password?'),
                  ),
                ]
              )
          ),
        ),
        appBar: AppBar(
          title: const Text('MyApp'),
          leading: Icon(Icons.home),
          centerTitle: true,
        ),
      ),
    );
  }
}