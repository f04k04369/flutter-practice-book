import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(
    MaterialApp.router(
      routerConfig: _router,
    ),
  );
}

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const FirstScreen(),
    ),
    GoRoute(
      path: '/second',
      builder: (context, state) => const SecondScreen(),
    ),
    GoRoute(
      path: '/third',
      builder: (context, state) => const ThirdScreen(),
    ),
  ],
);

class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FirstScreen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text('FirstからSecontへ'),
              onPressed: ( ) {
                GoRouter.of(context).go('/second');
              }, 
            ),
             ElevatedButton(
              child: const Text('FirstからThirdへ'),
              onPressed: ( ) {
                GoRouter.of(context).go('/third');
              }, 
            ),
         ],
        ),
      ),
    );
  }
}

class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SecondtScreen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text('SecondからThirdへ'),
              onPressed: ( ) {
                GoRouter.of(context).go('/third');
              }, 
            ),
             ElevatedButton(
              child: const Text('戻る'),
              onPressed: ( ) {
                Navigator.of(context).pop();
              }, 
            ),
         ],
        ),
      ),
    );
  }
}

class ThirdScreen extends StatelessWidget {
  const ThirdScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ThirdScreen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text('ThirdからFirstへ'),
              onPressed: ( ) {
                GoRouter.of(context).go('/');
              }, 
            ),
             ElevatedButton(
              child: const Text('戻る'),
              onPressed: ( ) {
                Navigator.of(context).pop();
              }, 
            ),
         ],
        ),
      ),
    );
  }
}