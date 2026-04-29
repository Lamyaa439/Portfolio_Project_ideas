import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const Color offWhite = Color(0xFFF8F8F8);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (context) => CardBloc(),
        child: Scaffold(
          appBar: AppBar(
            title: Text("Card App"),
            backgroundColor: Colors.deepOrange,
          ),
          // The color of the background
          backgroundColor: offWhite,
          body: Center(
            child: Container(
              height: 400,
              width: 300,
              decoration: BoxDecoration(
                color: Colors.deepOrange,
                // curved corners
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.all(25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "I Rook! \nwelcome to Mi-End",
                    style: TextStyle(
                      color: offWhite,
                      fontFamily: "Roboto",
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  ObscureTextFieldSample(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ObscureTextFieldSample extends StatelessWidget {
  const ObscureTextFieldSample({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 250,
      child: TextField(
        obscureText: true,
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelStyle: TextStyle(color: Colors.black),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          labelText: "Password",
        ),
      ),
    );
  }
}
