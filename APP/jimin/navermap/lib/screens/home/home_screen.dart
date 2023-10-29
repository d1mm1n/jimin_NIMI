import 'package:flutter/material.dart';
import 'package:navermap/screens/home/bottom_menu.dart'; // TestView 클래스가 정의된 파일을 import

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      body: Stack(
        children: <Widget>[
          //아래 네비게이션 바
          TestView(),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: 400,
              height: 80,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(70.0),
                  bottomRight: Radius.circular(70.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
