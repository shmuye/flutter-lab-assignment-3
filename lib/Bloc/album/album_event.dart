import 'package:equatable/equatable.dart';

abstract class AlbumEvent extends Equatable {
  const AlbumEvent();

  @override
  List<Object?> get props => [];
}

class LoadAlbums extends AlbumEvent {
  const LoadAlbums();
}

class RefreshAlbums extends AlbumEvent {
  const RefreshAlbums();
}

class FetchAlbums extends AlbumEvent {
  const FetchAlbums();
}