import 'package:flutter/material.dart';
import '../../../main.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isPhone = screenWidth < 600;
    final containerWidth = isPhone ? screenWidth * 0.9 : screenWidth * 0.5;
    final padding = isPhone ? 16.0 : 20.0;
    final titleSize = isPhone ? 28.0 : 36.0;

    return MaterialApp(
      title: 'My',
      home: Scaffold(
        backgroundColor: AppColors.bg,
        body: 
        Center(
          child: SingleChildScrollView(
            child: Container(
              width: containerWidth,
              constraints: BoxConstraints(
                minWidth: isPhone ? 200 : 600,
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text( 
                          'Register',
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
                    isPhone
                        ? Column(
                            children: const [
                              TextField(decoration: InputDecoration(labelText: 'First Name', isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10))),
                              SizedBox(height: 8),
                              TextField(decoration: InputDecoration(labelText: 'Last Name', isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10))),
                              SizedBox(height: 8),
                              TextField(decoration: InputDecoration(labelText: 'Email', isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10))),
                              SizedBox(height: 8),
                              TextField(decoration: InputDecoration(labelText: 'Phone Number', isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10))),
                              SizedBox(height: 8),
                              TextField(decoration: InputDecoration(labelText: 'Address', isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10))),
                              SizedBox(height: 8),
                              TextField(decoration: InputDecoration(labelText: 'Username', isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10))),
                              SizedBox(height: 8),
                              TextField(decoration: InputDecoration(labelText: 'Password', isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10))),
                            ],
                          )
                        : Column(
                            children: const [
                              Row(children: [
                                Expanded(child: TextField(decoration: InputDecoration(labelText: 'First Name', isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10)))),
                                SizedBox(width: 16),
                                Expanded(child: TextField(decoration: InputDecoration(labelText: 'Last Name', isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10)))),
                              ]),
                              SizedBox(height: 12),
                              Row(children: [
                                Expanded(child: TextField(decoration: InputDecoration(labelText: 'Email', isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10)))),
                                SizedBox(width: 16),
                                Expanded(child: TextField(decoration: InputDecoration(labelText: 'Phone Number', isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10)))),
                              ]),
                              SizedBox(height: 12),
                              Row(children: [
                                Expanded(child: TextField(decoration: InputDecoration(labelText: 'Address', isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10)))),
                              ]),
                              SizedBox(height: 12),
                              Row(children: [
                                Expanded(child: TextField(decoration: InputDecoration(labelText: 'Username', isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10)))),
                                SizedBox(width: 16),
                                Expanded(child: TextField(decoration: InputDecoration(labelText: 'Password', isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10)))),
                              ]),
                            ],
                          ),
                    SizedBox(height: isPhone ? 8 : 12),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Additional Info (Optional)',
                        border: OutlineInputBorder(),
                        fillColor: AppColors.card,
                        filled: true,
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      ),
                    ),
                    SizedBox(height: isPhone ? 8 : 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: AppColors.card,
                        minimumSize: const Size(double.infinity, 45),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () {
                        // Handle sign up logic here
                      },
                      child: const Text('Register'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: const Text('Already have an account? Login'),
                    ),
                    TextButton(
                      onPressed: () {
                        // Handle forgot password logic here
                      },
                      child: const Text('Forgot Password?'),
                    ),
                  ]
                ),
              ),
            ),
          ),
        ),
        appBar: AppBar(
          title: const Text('MyApp'),
          leading: const Icon(Icons.home),
          centerTitle: true,
        ),
      ),
    );
  }
}