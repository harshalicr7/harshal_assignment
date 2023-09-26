import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newassn/application/pages/login/bloc/login_bloc.dart';

import '../../../data/repository/post_repository.dart';
import '../home/home_screen.dart';
import '../signup/authenticationscreen.dart';

final firebase = FirebaseAuth.instance;

class LoginPageWrapperProvider extends StatelessWidget {
  const LoginPageWrapperProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => AuthRepository(),
      child: BlocProvider(
        create: (context) => LoginBloc(
          authRepository: RepositoryProvider.of<AuthRepository>(context),
        ),
        child: const LoginScreen(),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var emailText = '';
  var passwordText = '';

  final _formKey = GlobalKey<FormState>();

  void onSubmit() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Hmm! Are you doing everything right?"),
        ),
      );
      return;
    }

    _formKey.currentState!.save();

    context.read<LoginBloc>().add(
          OnLoginEvent(email: emailText, password: passwordText),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error.toString()),
              ),
            );
          } else if (state is LoginSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.data['message']),
              ),
            );
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                  builder: (context) => const HomesScreenWrapper()),
            );
          }
        },
        builder: (context, state) {
          if (state is LoginLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/whatsapp.png",
                height: 200,
                width: 200,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 25),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          icon: Icon(Icons.email),
                          labelText: 'Email',
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty ||
                              !value.contains('@')) {
                            return 'Enter a valid Email Address';
                          }

                          return null;
                        },
                        onSaved: (value) {
                          emailText = value!;
                        },
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          icon: Icon(Icons.lock),
                          labelText: 'Password',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().length < 6) {
                            return 'Please Enter a strong password';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          passwordText = value!;
                        },
                        obscureText: true,
                        textInputAction: TextInputAction.done,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        style: const ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(
                          Color(0xFF1DB954),
                        )),
                        onPressed: onSubmit,
                        child: const Text('Login'),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const AuthPageWrapperProvider()),
                            );
                          },
                          child: RichText(
                            text: const TextSpan(
                                text: "New User?",
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                                children: <TextSpan>[
                                  TextSpan(text: "    "),
                                  TextSpan(
                                    text: 'Create Account!',
                                    style: TextStyle(
                                        color: Color(0xFF1DB954),
                                        fontSize: 19,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ]),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    ));
  }
}
