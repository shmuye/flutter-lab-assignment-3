import 'package:json_annotation/json_annotation.dart';

part 'album_model.g.dart';

@JsonSerializable()
class AlbumModel {
  final int id;
  final int userId;
  final String title;
  @JsonKey(defaultValue: [])
  final List<PhotoModel> photos;

  AlbumModel({
    required this.id,
    required this.userId,
    required this.title,
    List<PhotoModel>? photos,
  }) : photos = photos ?? [];

  factory AlbumModel.fromJson(Map<String, dynamic> json) => _$AlbumModelFromJson(json);
  Map<String, dynamic> toJson() => _$AlbumModelToJson(this);
}

@JsonSerializable()
class PhotoModel {
  final int id;
  final String url;
  final String thumbnailUrl;

  PhotoModel({
    required this.id,
    required this.url,
    required this.thumbnailUrl,
  });

  factory PhotoModel.fromJson(Map<String, dynamic> json) => _$PhotoModelFromJson(json);
  Map<String, dynamic> toJson() => _$PhotoModelToJson(this);
}