import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:album_app/bloc/album/album_bloc.dart';
import 'package:album_app/bloc/album/album_event.dart';
import 'package:album_app/bloc/album/album_state.dart';
import 'package:album_app/data/models/album_model.dart';
import 'package:album_app/presentation/widgets/error_view.dart';
import 'package:album_app/presentation/widgets/loading_view.dart';

class AlbumDetailScreen extends StatelessWidget {
  final AlbumModel album;

  const AlbumDetailScreen({
    super.key,
    required this.album,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Album Details'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: BlocBuilder<AlbumBloc, AlbumState>(
        builder: (context, state) {
          return state.when(
            initial: () => const SizedBox.shrink(),
            loading: () => const LoadingView(),
            loaded: (albums) => _buildAlbumDetails(context),
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

  Widget _buildAlbumDetails(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (album.url != null)
            Card(
              clipBehavior: Clip.antiAlias,
              child: Image.network(
                album.url!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    color: Theme.of(context).colorScheme.errorContainer,
                    child: Center(
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        color: Theme.of(context).colorScheme.onErrorContainer,
                        size: 64,
                      ),
                    ),
                  );
                },
              ),
            ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.errorContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.image_not_supported_outlined,
                            color: Theme.of(context).colorScheme.onErrorContainer,
                            size: 24,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Album ID: ${album.id}',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'User ID: ${album.userId}',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Title',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    album.title,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}