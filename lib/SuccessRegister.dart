import 'package:flutter/material.dart';

class SuccessRegisterPage extends StatelessWidget {
  const SuccessRegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Success Register'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo_7.png', height: 150, width: 150),
            const Text(
              "회원가입이 성공적으로 완료되었습니다.",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            }, child: const Text("Login")),
          ],
        ),
      ),
    );
  }
}
