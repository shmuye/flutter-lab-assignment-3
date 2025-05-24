import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:album_app/data/models/album_model.dart';
import 'package:album_app/domain/repositories/album_repository.dart';
import 'package:album_app/data/services/cache_service.dart';
import 'package:album_app/data/services/connectivity_service.dart';

// Custom Exceptions
class NoInternetException implements Exception {
  final String message;
  NoInternetException([this.message = 'No internet connection']);
  @override
  String toString() => message;
}

class NotFoundException implements Exception {
  final String message;
  NotFoundException([this.message = 'Resource not found']);
  @override
  String toString() => message;
}

class ServerException implements Exception {
  final String message;
  ServerException([this.message = 'Server error']);
  @override
  String toString() => message;
}

class AlbumRepositoryImpl implements AlbumRepository {
  final http.Client _client;
  final String _baseUrl = 'https://jsonplaceholder.typicode.com';
  final CacheService _cacheService = CacheService();
  final ConnectivityService _connectivityService = ConnectivityService();

  AlbumRepositoryImpl(this._client);

  @override
  Future<List<AlbumModel>> getAlbums() async {
    // Check if we have valid cached data
    if (_cacheService.hasValidCache) {
      return _cacheService.cachedAlbums!;
    }

    // Check connectivity
    final isConnected = await _connectivityService.isConnected();
    if (!isConnected) {
      // If offline and we have cached data, return it
      if (_cacheService.cachedAlbums != null) {
        return _cacheService.cachedAlbums!;
      }
      throw NoInternetException();
    }

    try {
      // Fetch albums
      final albumsResponse = await _client.get(Uri.parse('$_baseUrl/albums'));

      if (albumsResponse.statusCode == 200) {
        final List<dynamic> albumsJson = json.decode(albumsResponse.body);
        final albums = albumsJson.map((json) => AlbumModel.fromJson(json)).toList();

        // Fetch photos for each album
        final photosResponse = await _client.get(Uri.parse('$_baseUrl/photos'));
        if (photosResponse.statusCode == 200) {
          final List<dynamic> photosJson = json.decode(photosResponse.body);

          // Create a map of albumId to photo
          final Map<int, Map<String, dynamic>> albumPhotos = {};
          for (var photo in photosJson) {
            final albumId = photo['albumId'] as int;
            if (!albumPhotos.containsKey(albumId)) {
              albumPhotos[albumId] = photo;
            }
          }

          // Update albums with photo information
          for (var album in albums) {
            if (albumPhotos.containsKey(album.id)) {
              final photo = albumPhotos[album.id]!;
              album = AlbumModel(
                id: album.id,
                userId: album.userId,
                title: album.title,
                thumbnailUrl: photo['thumbnailUrl'] as String,
                url: photo['url'] as String,
              );
            }
          }
        }

        // Cache the fetched data
        _cacheService.cacheAlbums(albums);

        return albums;
      } else if (albumsResponse.statusCode == 404) {
        throw NotFoundException();
      } else if (albumsResponse.statusCode >= 500) {
        throw ServerException('Server error: ${albumsResponse.statusCode}');
      } else {
        throw Exception('Failed to load albums: ${albumsResponse.statusCode}');
      }
    } catch (e) {
      if (e is NoInternetException || e is NotFoundException || e is ServerException) {
        rethrow;
      }
      // If network request fails and we have cached data, return it
      if (_cacheService.cachedAlbums != null) {
        return _cacheService.cachedAlbums!;
      }
      throw Exception('Failed to load albums: $e');
    }
  }

  // Method to force refresh the cache
  @override
  Future<List<AlbumModel>> refreshAlbums() async {
    final isConnected = await _connectivityService.isConnected();
    if (!isConnected) {
      throw NoInternetException();
    }

    _cacheService.clearCache();
    return getAlbums();
  }
}