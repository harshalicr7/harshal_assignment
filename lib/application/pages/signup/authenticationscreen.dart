import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newassn/application/pages/signup/widgets/image_picker.dart';
import 'package:newassn/data/repository/post_repository.dart';

import '../login/login_screen.dart';
import 'bloc/signup_bloc.dart';

final firebase = FirebaseAuth.instance;

class AuthPageWrapperProvider extends StatelessWidget {
  const AuthPageWrapperProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => AuthRepository(),
      child: BlocProvider(
        create: (context) => SignupBloc(
          authRepository: RepositoryProvider.of<AuthRepository>(context),
        ),
        child: const SignupScreen(),
      ),
    );
  }
}

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  var emailText = '';
  var passwordText = '';
  var userName = '';
  File? selectedImage;

  final _formKey = GlobalKey<FormState>();

  void onSubmit() async {
    final isValid = _formKey.currentState!.validate();

    if (!isValid || selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: !isValid
              ? const Text("There seems like some issue")
              : const Text("Kindly choose an image"),
        ),
      );
    }

    _formKey.currentState!.save();

    context.read<SignupBloc>().add(
          OnSignupEvent(
              email: emailText,
              password: passwordText,
              userName: userName,
              profileImage: selectedImage!),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: BlocConsumer<SignupBloc, SignupState>(
        listener: (ctx, state) {
          if (state is SignupErrorState) {
            ScaffoldMessenger.of(ctx).showSnackBar(
              SnackBar(
                content: Text(state.error.toString()),
              ),
            );
          } else if (state is SignupSuccessState) {
            ScaffoldMessenger.of(ctx).showSnackBar(
              SnackBar(
                content: Text(state.data!['message']),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is SignupLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/whatsapp.png",
                  height: 200,
                  width: 200,
                ),
                UserImagePicker(onPickImage: (p) => selectedImage = p),
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 25),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: "Username",
                            icon: Icon(Icons.people),
                          ),
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty ||
                                value.length < 4) {
                              return "Please input a valid username";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            userName = value!;
                          },
                        ),
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
                          child: const Text("Signup"),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const LoginPageWrapperProvider()),
                            );
                          },
                          child: RichText(
                            text: const TextSpan(
                                text: "Already have an account?",
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500),
                                children: <TextSpan>[
                                  TextSpan(text: "  "),
                                  TextSpan(
                                    text: 'Login',
                                    style: TextStyle(
                                        color: Color(0xFF1DB954),
                                        fontSize: 19,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ));
  }
}
