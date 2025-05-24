import 'package:album_app/data/models/album_model.dart';
import 'package:album_app/domain/repositories/album_repository.dart';
import 'package:album_app/data/services/connectivity_service.dart';
import 'package:album_app/presentation/viewmodels/base_view_model.dart';
import 'package:album_app/data/repositories/album_repository_impl.dart';

class AlbumViewModel extends BaseViewModel {
  final AlbumRepository _albumRepository;
  final ConnectivityService _connectivityService;

  List<AlbumModel> _albums = [];
  bool _isOffline = false;

  AlbumViewModel({
    required AlbumRepository albumRepository,
    ConnectivityService? connectivityService,
  }) : _albumRepository = albumRepository,
        _connectivityService = connectivityService ?? ConnectivityService();

  List<AlbumModel> get albums => _albums;
  bool get isOffline => _isOffline;

  Future<void> loadAlbums() async {
    setLoading(true);
    setError(null);
    try {
      final isConnected = await _connectivityService.isConnected();
      _albums = await _albumRepository.getAlbums();
      _isOffline = !isConnected;
      notifyListeners();
    } on NoInternetException {
      setError('No internet connection. Please check your network.');
      _isOffline = true;
      notifyListeners();
    } on NotFoundException {
      setError('Albums not found (404).');
      notifyListeners();
    } on ServerException catch (e) {
      setError('Server error: ${e.message}');
      notifyListeners();
    } catch (e) {
      setError('An unexpected error occurred. Please try again.');
      notifyListeners();
    } finally {
      setLoading(false);
    }
  }

  Future<void> refreshAlbums() async {
    setLoading(true);
    setError(null);
    try {
      final isConnected = await _connectivityService.isConnected();
      if (!isConnected) {
        throw NoInternetException();
      }
      _albums = await _albumRepository.refreshAlbums();
      _isOffline = false;
      notifyListeners();
    } on NoInternetException {
      setError('No internet connection. Please check your network.');
      _isOffline = true;
      notifyListeners();
    } on NotFoundException {
      setError('Albums not found (404).');
      notifyListeners();
    } on ServerException catch (e) {
      setError('Server error: ${e.message}');
      notifyListeners();
    } catch (e) {
      setError('An unexpected error occurred. Please try again.');
      notifyListeners();
    } finally {
      setLoading(false);
    }
  }
}