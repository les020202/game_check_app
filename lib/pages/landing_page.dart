import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBar(
        title:Row(
          children: [
            Text('임시 랜딩 페이지'),
            ElevatedButton(onPressed: (){
              context.go('/game_main_page');
            }, child: Text('메인으로'))
          ],
        )),
    );
  }
}