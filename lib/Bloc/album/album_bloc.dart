import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:album_app/domain/repositories/album_repository.dart';
import 'package:album_app/data/services/connectivity_service.dart';
import 'package:album_app/data/repositories/album_repository_impl.dart';
import 'album_event.dart';
import 'album_state.dart';

class AlbumBloc extends Bloc<AlbumEvent, AlbumState> {
  final AlbumRepository _albumRepository;
  final ConnectivityService _connectivityService;

  AlbumBloc({
    required AlbumRepository albumRepository,
    ConnectivityService? connectivityService,
  }) : _albumRepository = albumRepository,
        _connectivityService = connectivityService ?? ConnectivityService(),
        super(AlbumInitial()) {
    on<LoadAlbums>(_onLoadAlbums);
    on<RefreshAlbums>(_onRefreshAlbums);
    on<FetchAlbums>(_onFetchAlbums);

    // Add initial event
    add(const LoadAlbums());
  }

  Future<void> _onLoadAlbums(LoadAlbums event, Emitter<AlbumState> emit) async {
    emit(AlbumLoading());
    try {
      final isConnected = await _connectivityService.isConnected();
      final albums = await _albumRepository.getAlbums();
      emit(AlbumLoaded(albums: albums, isOffline: !isConnected));
    } on NoInternetException {
      emit(AlbumError(
        message: 'No internet connection. Please check your network.',
        isNoInternet: true,
      ));
    } on NotFoundException {
      emit(AlbumError(
        message: 'Albums not found (404).',
        isNotFound: true,
      ));
    } on ServerException catch (e) {
      emit(AlbumError(
        message: 'Server error: ${e.message}',
        isServerError: true,
      ));
    } catch (e) {
      emit(AlbumError(
        message: 'An unexpected error occurred. Please try again.',
      ));
    }
  }

  Future<void> _onRefreshAlbums(RefreshAlbums event, Emitter<AlbumState> emit) async {
    try {
      final isConnected = await _connectivityService.isConnected();
      if (!isConnected) {
        emit(AlbumError(
          message: 'No internet connection. Please check your network.',
          isNoInternet: true,
        ));
        return;
      }

      final albums = await _albumRepository.refreshAlbums();
      emit(AlbumLoaded(albums: albums, isOffline: false));
    } on NoInternetException {
      emit(AlbumError(
        message: 'No internet connection. Please check your network.',
        isNoInternet: true,
      ));
    } on NotFoundException {
      emit(AlbumError(
        message: 'Albums not found (404).',
        isNotFound: true,
      ));
    } on ServerException catch (e) {
      emit(AlbumError(
        message: 'Server error: ${e.message}',
        isServerError: true,
      ));
    } catch (e) {
      emit(AlbumError(
        message: 'An unexpected error occurred. Please try again.',
      ));
    }
  }

  Future<void> _onFetchAlbums(FetchAlbums event, Emitter<AlbumState> emit) async {
    emit(AlbumLoading());
    try {
      final isConnected = await _connectivityService.isConnected();
      if (!isConnected) {
        emit(AlbumError(
          message: 'No internet connection. Please check your network.',
          isNoInternet: true,
        ));
        return;
      }

      final albums = await _albumRepository.refreshAlbums();
      emit(AlbumLoaded(albums: albums, isOffline: false));
    } on NoInternetException {
      emit(AlbumError(
        message: 'No internet connection. Please check your network.',
        isNoInternet: true,
      ));
    } on NotFoundException {
      emit(AlbumError(
        message: 'Albums not found (404).',
        isNotFound: true,
      ));
    } on ServerException catch (e) {
      emit(AlbumError(
        message: 'Server error: ${e.message}',
        isServerError: true,
      ));
    } catch (e) {
      emit(AlbumError(
        message: 'An unexpected error occurred. Please try again.',
      ));
    }
  }
}