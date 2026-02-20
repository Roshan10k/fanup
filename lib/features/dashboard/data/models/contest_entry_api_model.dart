import 'package:json_annotation/json_annotation.dart';

part 'contest_entry_api_model.g.dart';

@JsonSerializable()
class ContestEntryApiModel {
  @JsonKey(defaultValue: '')
  final String matchId;

  const ContestEntryApiModel({required this.matchId});

  factory ContestEntryApiModel.fromJson(Map<String, dynamic> json) =>
      _$ContestEntryApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$ContestEntryApiModelToJson(this);
}
