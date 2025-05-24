import 'package:album_app/data/models/album_model.dart';

class CacheService {
  static final CacheService _instance = CacheService._internal();
  factory CacheService() => _instance;
  CacheService._internal();

  List<AlbumModel>? _cachedAlbums;
  DateTime? _lastFetchTime;
  static const Duration _cacheDuration = Duration(minutes: 5);

  bool get hasValidCache {
    if (_cachedAlbums == null || _lastFetchTime == null) return false;
    return DateTime.now().difference(_lastFetchTime!) < _cacheDuration;
  }

  List<AlbumModel>? get cachedAlbums => _cachedAlbums;

  void cacheAlbums(List<AlbumModel> albums) {
    _cachedAlbums = albums;
    _lastFetchTime = DateTime.now();
  }

  void clearCache() {
    _cachedAlbums = null;
    _lastFetchTime = null;
  }
}