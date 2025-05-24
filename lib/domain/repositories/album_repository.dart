import 'package:album_app/data/models/album_model.dart';

abstract class AlbumRepository {
  Future<List<AlbumModel>> getAlbums();
  Future<List<AlbumModel>> refreshAlbums();
}