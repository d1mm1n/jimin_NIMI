import 'package:flutter/material.dart';

// 길찾기 버튼
class RoadButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        child: const Text('길찾기'),
        onPressed: () {
          showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return Container(
                  child: Center(
                child: Container(
                    height: 200,
                    margin:
                        const EdgeInsets.only(left: 25, right: 25, bottom: 10),
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 123, 163, 131),
                        borderRadius: BorderRadius.all(Radius.circular(40)))),
              ));
            },
            backgroundColor: Colors.transparent,
          );
        },
      ),
    );
  }
}
