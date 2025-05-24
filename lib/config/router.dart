import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:album_app/data/models/album_model.dart';
import 'package:album_app/presentation/screens/album_list_screen.dart';
import 'package:album_app/presentation/screens/album_detail_screen.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const AlbumListScreen(),
    ),
    GoRoute(
      path: '/album/:id',
      builder: (context, state) {
        final album = state.extra as AlbumModel;
        return AlbumDetailScreen(album: album);
      },
    ),
  ],
);