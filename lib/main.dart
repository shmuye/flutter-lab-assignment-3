import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:album_app/bloc/album/album_bloc.dart';
import 'package:album_app/data/repositories/album_repository_impl.dart';
import 'package:album_app/config/router.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AlbumBloc(
        albumRepository: AlbumRepositoryImpl(http.Client()),
      ),
      child: MaterialApp.router(
        title: 'Album App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        routerConfig: router,
      ),
    );
  }
}
