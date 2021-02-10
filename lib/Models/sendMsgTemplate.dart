import 'package:json_annotation/json_annotation.dart';

part 'sendMsgTemplate.g.dart';

@JsonSerializable()
class SendMsgTemplate {
  String fromWhom;
  String toWhom;
  String message;
  SendMsgTemplate({this.message, this.fromWhom, this.toWhom});

  factory SendMsgTemplate.fromJson(Map<String, dynamic> json) =>
      _$SendMsgTemplateFromJson(json);

  Map<String, dynamic> toJson() => _$SendMsgTemplateToJson(this);
}
