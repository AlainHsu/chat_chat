import 'package:chat_chat/Models/userModel.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chatContentModel.g.dart';

@JsonSerializable()
class ChatContentModel {
  List<UserModel> userIds;
  String lastContent;
  String lastUpdateTime;
  bool isRead;
  ChatContentModel(
      {this.userIds, this.lastContent, this.lastUpdateTime, this.isRead});

  factory ChatContentModel.fromJson(Map<String, dynamic> json) =>
      _$ChatContentModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChatContentModelToJson(this);
}
