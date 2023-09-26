import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newassn/application/pages/chat/chatscreen.dart';
import 'package:newassn/data/repository/user_repository.dart';

import 'bloc/home_bloc.dart';

class HomesScreenWrapper extends StatelessWidget {
  const HomesScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(),
      child: const HomesScreen(),
    );
  }
}

class HomesScreen extends StatefulWidget {
  const HomesScreen({super.key});

  @override
  State<HomesScreen> createState() => _HomesScreenState();
}

class _HomesScreenState extends State<HomesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(LoadUserEvent());
  }

  final currentUser = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeLoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is HomeErrorState) {
          return Center(
            child: Text(state.error.toString()),
          );
        } else if (state is HomeSuccessState) {
          return Scaffold(
              appBar: AppBar(
                actions: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.search,
                      size: 30,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.more_vert,
                      size: 30,
                    ),
                  ),
                ],
                title: Text("Welcome ${state.username['username']}"),
                backgroundColor: const Color(0xFF1DB954),
                toolbarHeight: 65,
              ),
              body: ListView.builder(
                itemCount: state.userList.length,
                itemBuilder: (context, index) {
                  final userData = state.userList[index];
                  return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 5),
                      child: Card(
                          child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => ChatScreen(
                                            name: userData['username'],
                                          )),
                                );
                              },
                              child: StreamBuilder<dynamic>(
                                  stream: UserRepository().getOtherUser(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    }
                                    if (snapshot.hasError) {
                                      return const Text(
                                          "Something has gone wrong");
                                    }
                                    var userStreamData =
                                        (snapshot.data as dynamic)
                                            .docs
                                            .where((e) =>
                                                e.data()['email'] !=
                                                currentUser.email)
                                            .toList()
                                            .map((e) => e.data())
                                            .toList()[0];

                                    return ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                          userData['image_url'],
                                        ),
                                        radius: 23,
                                      ),
                                      title: Text(userData['username']),
                                      trailing: Container(
                                        height: 10,
                                        width: 10,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: userStreamData['status']
                                              ? Colors.green
                                              : Colors.red,
                                        ),
                                      ),
                                    );
                                  }))));
                },
              ));
        }
        return const Scaffold(
          body: Center(
            child: Text("fail"),
          ),
        );
      },
    );
  }
}
