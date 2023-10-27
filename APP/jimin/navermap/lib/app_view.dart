import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:navermap/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:navermap/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:navermap/screens/auth/welcome_screen.dart';
import 'package:navermap/screens/home/home_screen.dart';

class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Firebase Auth',
        theme: ThemeData(
          //여기서 로그인 화면 효과 색상 설정
          colorScheme: const ColorScheme.light(
              background: Colors.white,
              onBackground: Colors.black,
              primary: Color.fromRGBO(111, 172, 87, 1),
              onPrimary: Colors.black,
              //secondary 색 바꾸면 로그인 아래 바 색도 바뀜
              secondary: Color.fromRGBO(255, 208, 79, 1),
              onSecondary: Colors.white,
              tertiary: Color.fromRGBO(152, 202, 121, 1),
              error: Colors.red,
              outline: Color(0xFF424242)),
        ),
        home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
          if (state.status == AuthenticationStatus.authenticated) {
            return BlocProvider(
              create: (context) => SignInBloc(
                  userRepository:
                      context.read<AuthenticationBloc>().userRepository),
              child: const HomeScreen(),
            );
          } else {
            return const WelcomeScreen();
          }
        }));
  }
}
