import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:album_app/data/models/album_model.dart';

class AlbumCard extends StatelessWidget {
  final AlbumModel album;

  const AlbumCard({
    super.key,
    required this.album,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: InkWell(
        onTap: () => context.push('/album/${album.id}', extra: album),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              if (album.thumbnailUrl != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    album.thumbnailUrl!,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.errorContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
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
                )
              else
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      color: Theme.of(context).colorScheme.onErrorContainer,
                      size: 32,
                    ),
                  ),
                ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  album.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}