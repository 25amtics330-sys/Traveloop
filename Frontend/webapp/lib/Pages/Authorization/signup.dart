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
              color: AppColors.accentLight,
            ),
            padding: EdgeInsets.all(20),
            constraints:
              BoxConstraints(minWidth: 700, minHeight: 600),   
              child: Container( 
                height: 570,
                width: 670,
                padding: EdgeInsets.all(20),
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
                            border: Border.all(color: const Color.fromARGB(137, 157, 0, 0)),
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                      ],
                    ),
                   Row(
                  children: const [
                    Expanded(child: TextField(decoration: InputDecoration(labelText: 'First Name', isDense: true))),
                    SizedBox(width: 16),
                    Expanded(child: TextField(decoration: InputDecoration(labelText: 'Last Name', isDense: true))),
                  ],
                ),
                  Row(
                  children: const [
                    Expanded(child: TextField(decoration: InputDecoration(labelText: 'Email', isDense: true))),
                    SizedBox(width: 16),
                    Expanded(child: TextField(decoration: InputDecoration(labelText: 'Phone Number', isDense: true))),
                  ],
                ),
                  Row(
                  children: const [
                    Expanded(child: TextField(decoration: InputDecoration(labelText: 'Address', isDense: true))),
                  ],
                ),
                Row(
                  children: const [
                    Expanded(child: TextField(decoration: InputDecoration(labelText: 'Username', isDense: true))),
                    SizedBox(width: 16),
                    Expanded(child: TextField(decoration: InputDecoration(labelText: 'Password', isDense: true))),
                  ],
                ),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Additional Info (Optional)',
                        border: OutlineInputBorder(),
                        fillColor: AppColors.card,
                        filled: true,
                      ),
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
                      child: Text('Register'),
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