import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'application/pages/home/home_screen.dart';
import 'application/pages/login/login_screen.dart';
import 'firebase_options.dart';

// paste firebase_options.dart file in root of the lib folder

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.

  // epositoryProvider(
  //     create: (context) => AuthRepository(),
  //     child: BlocProvider(
  //       create: (context) => AuthBloc(
  //         authRepository: RepositoryProvider.of<AuthRepository>(context),
  //       ),
  //       child: const AuthenticationScreen(),
  //     ),
  //   );
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, snapshot) {
            if (snapshot.hasData) {
              return const HomesScreenWrapper();
            }
            return const LoginPageWrapperProvider();
          }),
    );
  }
}
