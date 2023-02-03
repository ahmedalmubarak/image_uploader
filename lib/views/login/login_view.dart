import 'package:bloc_fairebase_auth/bloc/app_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class LoginView extends HookWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 64),
              Text(
                'Welcome Back !',
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
                          AppEventLogIn(email: email, password: password),
                        );
                  },
                  child: const Text('Log in'),
                ),
              ),
              TextButton(
                onPressed: () {
                  context.read<AppBloc>().add(
                        const AppEventGoToRegistration(),
                      );
                },
                child: const Text('Not register yet? Register here!'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
