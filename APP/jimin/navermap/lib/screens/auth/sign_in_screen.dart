import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:navermap/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:navermap/screens/auth/components/my_text_field.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

//여기 클래스에서 로그인 입력에 이메일, 비밀번호 텍스트 바를 관리한다.
class _SignInScreenState extends State<SignInScreen> {
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool signInRequired = false;
  IconData iconPassWord = CupertinoIcons.eye_fill;
  bool obscurePassword = true;
  String? _errorMsg;

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            //로그인 회원가입 텍스트와 이메일 입력란 사이간격을 조정하기 위해서 아래의 SizedBox 사용
            const SizedBox(height: 25),
            SizedBox(
                //이메일 텍스트 바 크기 설정
                width: MediaQuery.of(context).size.width * 0.9,
                child: MyTextField(
                    controller: emailController,
                    hintText: '이메일',
                    obscureText: false,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: const Icon(CupertinoIcons.mail_solid),
                    errorMsg: _errorMsg,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return '입력란을 채워주세요.';
                        //이메일 양식대로 작성하도록 정규식 조건 부여
                      } else if (!RegExp(r'^[\w-\.]+@([\w-]+.)+[\w-]{2,4}$')
                          .hasMatch(val)) {
                        return '유효한 이메일을 입력해주세요.';
                      }
                      return null;
                    })),
            const SizedBox(height: 10),
            SizedBox(
                //이메일 텍스트 바 크기 설정
                width: MediaQuery.of(context).size.width * 0.9,
                child: MyTextField(
                  controller: passwordController,
                  hintText: '비밀번호',
                  obscureText: obscurePassword,
                  keyboardType: TextInputType.visiblePassword,
                  prefixIcon: const Icon(CupertinoIcons.lock_fill),
                  errorMsg: _errorMsg,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return '입력란을 채워주세요.';
                      //이메일 양식대로 작성하도록 정규식 조건 부여
                    } else if (!RegExp(r'^[\w-\.]+@([\w-]+.)+[\w-]{2,4}$')
                        .hasMatch(val)) {
                      return '유효한 이메일을 입력해주세요.';
                    }
                    return null;
                  },
                  //비밀번호 숨김 해제 아이콘과 숨김, 보여짐 관리
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obscurePassword = !obscurePassword;
                        if (obscurePassword) {
                          iconPassWord = CupertinoIcons.eye_fill;
                        } else {
                          iconPassWord = CupertinoIcons.eye_slash_fill;
                        }
                      });
                    },
                    icon: Icon(iconPassWord),
                  ),
                )),
            //비밀번호 입력란과 버튼 사이의 간격 조정
            const SizedBox(
              height: 20,
            ),
            //로그인 버튼
            !signInRequired
                ? SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: TextButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<SignInBloc>().add(SignInRequired(
                              emailController.text, passwordController.text));
                        }
                      },
                      style: TextButton.styleFrom(
                          elevation: 3.0,
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(60))),
                      child: const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 25, vertical: 20),
                          child: Text(
                            'Sing In',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600),
                          )),
                    ),
                  )
                : const CircularProgressIndicator(),
          ],
        ));
  }
}
