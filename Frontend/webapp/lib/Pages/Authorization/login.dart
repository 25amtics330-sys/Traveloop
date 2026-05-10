import 'package:flutter/material.dart';
import '../../../main.dart';


class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isPhone = screenWidth < 600;
    final containerWidth = isPhone ? screenWidth * 0.9 : screenWidth * 0.5;
    final containerHeight = isPhone ? null : screenHeight * 0.85;
    final padding = isPhone ? 16.0 : 20.0;
    final titleSize = isPhone ? 28.0 : 36.0;

    return MaterialApp(
      title: 'My',
      home: Scaffold(
        backgroundColor: AppColors.bg,
        body: 
        Center(
          child: Container(
            width: containerWidth,
            constraints: BoxConstraints(
              minWidth: isPhone ? 200 : 600,
              minHeight: isPhone ? 300 : 500,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: AppColors.accentLight,
            ),
            padding: EdgeInsets.all(padding),
            child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(padding),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppColors.card,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text( 
                          'Login',
                          style: TextStyle(
                            fontSize: titleSize,
                            fontWeight: FontWeight.bold,
                            color: AppColors.text,
                          ),
                        ),
                        Container(
                          width: isPhone ? 50 : 60,
                          height: isPhone ? 50 : 60,
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color.fromARGB(137, 157, 0, 0)),
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: isPhone ? 8 : 12),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                        fillColor: AppColors.card,
                        filled: true,
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      ),
                    ),
                    SizedBox(height: isPhone ? 8 : 12),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                        fillColor: AppColors.card,
                        filled: true,
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      ),
                      obscureText: true,
                    ),
                
                    SizedBox(height: isPhone ? 8 : 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: AppColors.card,
                        minimumSize: Size(double.infinity, 45),
                        padding: EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () {
                          Navigator.pushNamed(context, '/home');
                      },
                      child: const Text('Login'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/signup');
                      },
                      child: const Text('Sign Up'),
                    ),
                    TextButton(
                      onPressed: () {
                        // Handle forgot password logic here
                      },
                      child: const Text('Forgot Password?'),
                    ),
                  ]
                ),
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