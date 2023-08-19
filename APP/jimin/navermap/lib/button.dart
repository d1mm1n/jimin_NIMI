import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'main.dart';
import 'package:provider/provider.dart';

// 길찾기 버튼
class RoadButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        child: const Text('길찾기'),
        onPressed: () {},
      ),
    );
  }
}
