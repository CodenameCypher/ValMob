import 'package:flutter/material.dart';

void main() {
  runApp(const ValMob());
}

class ValMob extends StatelessWidget {
  const ValMob({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ValMob Beta',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF262626),
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              "vAlmob",
              style: TextStyle(
                  fontFamily: 'ValFont'
              ),
            ),
            Text(
              "Beta",
              style: TextStyle(
                fontSize: 10,
              ),
            ),
          ],
        ),
        backgroundColor: Color(0xFF710000),
        elevation: 2,
      ),
      body: Text(
          "Nothing RN",
        style: TextStyle(
          color: Colors.white,
          fontSize: 50,
        ),
      ),
    );
  }
}
