// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sendMsgTemplate.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SendMsgTemplate _$SendMsgTemplateFromJson(Map<String, dynamic> json) {
  return SendMsgTemplate(
    message: json['message'] as String,
    fromWhom: json['fromWhom'] as String,
    toWhom: json['toWhom'] as String,
  );
}

Map<String, dynamic> _$SendMsgTemplateToJson(SendMsgTemplate instance) =>
    <String, dynamic>{
      'fromWhom': instance.fromWhom,
      'toWhom': instance.toWhom,
      'message': instance.message,
    };
