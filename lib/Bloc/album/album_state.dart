import 'package:equatable/equatable.dart';
import 'package:album_app/data/models/album_model.dart';

abstract class AlbumState extends Equatable {
  const AlbumState();

  @override
  List<Object?> get props => [];
  T when<T>({
    required T Function() initial,
    required T Function() loading,
    required T Function(List<AlbumModel> albums) loaded,
    required T Function(String message, bool isNoInternet, bool isNotFound, bool isServerError) error,
  }) {
    if (this is AlbumInitial) {
      return initial();
    } else if (this is AlbumLoading) {
      return loading();
    } else if (this is AlbumLoaded) {
      return loaded((this as AlbumLoaded).albums);
    } else if (this is AlbumError) {
      final errorState = this as AlbumError;
      return error(
        errorState.message,
        errorState.isNoInternet,
        errorState.isNotFound,
        errorState.isServerError,
      );
    }
    throw Exception('Unknown state: $this');
  }
}

class AlbumInitial extends AlbumState {}

class AlbumLoading extends AlbumState {}

class AlbumLoaded extends AlbumState {
  final List<AlbumModel> albums;
  final bool isOffline;

  const AlbumLoaded({
    required this.albums,
    this.isOffline = false,
  });

  @override
  List<Object?> get props => [albums, isOffline];
}

class AlbumError extends AlbumState {
  final String message;
  final bool isNoInternet;
  final bool isNotFound;
  final bool isServerError;

  const AlbumError({
    required this.message,
    this.isNoInternet = false,
    this.isNotFound = false,
    this.isServerError = false,
  });

  @override
  List<Object?> get props => [message, isNoInternet, isNotFound, isServerError];
}