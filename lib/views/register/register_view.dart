import 'package:bloc_fairebase_auth/bloc/app_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class RegisterView extends HookWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 64),
            Text(
              'Sign Up',
              style: Theme.of(context)
                  .textTheme
                  .headline3
                  ?.copyWith(color: Colors.black54),
            ),
            const SizedBox(height: 64),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration:
                  const InputDecoration(hintText: 'Enter your email here..'),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'Enter your password here..',
              ),
            ),
            const SizedBox(height: 64),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  final email = emailController.text;
                  final password = passwordController.text;
                  context.read<AppBloc>().add(
                        AppEventRegister(email: email, password: password),
                      );
                },
                child: const Text('Register'),
              ),
            ),
            TextButton(
              onPressed: () {
                context.read<AppBloc>().add(
                      const AppEventGoToLogIn(),
                    );
              },
              child: const Text('Already registered ? Log in here!'),
            )
          ],
        ),
      ),
    );
  }
}
