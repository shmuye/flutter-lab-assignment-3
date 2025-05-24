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
        centerTitle: true,
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
          // Album Information Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    album.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
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
          ),
          const SizedBox(height: 24),
          // Photos Grid
          if (album.photos.isNotEmpty) ...[
            Text(
              'Photos',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1,
              ),
              itemCount: album.photos.length,
              itemBuilder: (context, index) {
                final photo = album.photos[index];
                return Card(
                  clipBehavior: Clip.antiAlias,
                  child: Image.network(
                    photo.thumbnailUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Theme.of(context).colorScheme.errorContainer,
                        child: Center(
                          child: Icon(
                            Icons.image_not_supported_outlined,
                            color: Theme.of(context).colorScheme.onErrorContainer,
                            size: 32,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}