import 'package:flutter/material.dart';
import '../../../main.dart';


class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

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
                          'Login',
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
                          Navigator.pushNamed(context, '/home');
                      },
                      child: Text('Login'),
                    ),
                    TextButton(onPressed: () {
                      Navigator.pushNamed(context, '/signup');
                    }, child: Text('Sign Up')),
                
                
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