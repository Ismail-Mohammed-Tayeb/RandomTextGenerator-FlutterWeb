import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Consuming RESTful API',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? randomGeneratedString;
  bool isLoading = false;
  final TextEditingController textEditingController = TextEditingController();
  int length = 100;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          child: Container(
            width: 700,
            height: 800,
            color: Colors.grey,
            child: SizedBox.expand(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    "This is A Simple Flutter Web App",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                  const Text(
                    "To Consume A RESTful API Built Using .Net Core",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 22, vertical: 22.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        color: Colors.white,
                        width: double.infinity,
                        height: 450,
                        child: Center(child: getSuitableWidgets()),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 400,
                    height: 100,
                    child: TextField(
                      controller: textEditingController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Enter Random Text Length, Defaults To: 100',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 400,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        getRandomString();
                      },
                      child: const Text('Generate Text'),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('Credit To: Ismail Tayeb & Zeinab Barbahan')
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getSuitableWidgets() {
    if (isLoading) {
      return ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 50, maxWidth: 50),
        child: const CircularProgressIndicator(),
      );
    }
    if (randomGeneratedString == null) {
      return const Text(
        "No Text Generated Yet",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: SingleChildScrollView(
          child: SelectableText(
            "Random Text Is: $randomGeneratedString",
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20),
          ),
        ),
      );
    }
  }

  getRandomString() async {
    try {
      if (textEditingController.text.trim().isEmpty) {
        length = 100;
      } else {
        length = int.parse(textEditingController.text.trim());
      }
      setState(() {
        isLoading = true;
      });
      http.Response response = await http.get(
          Uri.parse(
              "https://testing-app-dotnet.herokuapp.com/api/Test/GetRandomString?length=$length"),
          headers: {
            "Access-Control-Allow-Origin":
                "*", // Required for CORS support to work
            "Access-Control-Allow-Credentials":
                'true', // Required for cookies, authorization headers with HTTPS
            "Access-Control-Allow-Headers":
                "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
            "Access-Control-Allow-Methods": "POST, OPTIONS"
          });
      randomGeneratedString = jsonDecode(response.body)["Value"].toString();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      log(e.toString());
    }
  }
}
