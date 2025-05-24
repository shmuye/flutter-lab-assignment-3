import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:album_app/bloc/album/album_bloc.dart';
import 'package:album_app/bloc/album/album_event.dart';
import 'package:album_app/bloc/album/album_state.dart';
import 'package:album_app/presentation/widgets/album_card.dart';
import 'package:album_app/presentation/widgets/error_view.dart';
import 'package:album_app/presentation/widgets/loading_view.dart';

class AlbumListScreen extends StatelessWidget {
  const AlbumListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Albums'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
      ),
      body: BlocBuilder<AlbumBloc, AlbumState>(
        builder: (context, state) {
          return state.when(
            initial: () => const LoadingView(),
            loading: () => const LoadingView(),
            loaded: (albums) => ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: albums.length,
              itemBuilder: (context, index) {
                final album = albums[index];
                return AlbumCard(album: album);
              },
            ),
            error: (message, isNoInternet, isNotFound, isServerError) => ErrorView(
              message: message,
              isNoInternet: isNoInternet,
              isNotFound: isNotFound,
              isServerError: isServerError,
              onRetry: () {
                context.read<AlbumBloc>().add(const FetchAlbums());
              },
            ),
          );
        },
      ),
    );
  }
}