// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthApiModel _$AuthApiModelFromJson(Map<String, dynamic> json) => AuthApiModel(
      authId: AuthApiModel._toNullableString(
          AuthApiModel._readUserValue(json, '_id')),
      fullName: AuthApiModel._toNullableString(
          AuthApiModel._readUserValue(json, 'fullName')),
      email: AuthApiModel._toNullableString(
          AuthApiModel._readUserValue(json, 'email')),
      password: json['password'] == null
          ? ''
          : AuthApiModel._toRequiredString(json['password']),
      token: AuthApiModel._toNullableString(
          AuthApiModel._readTokenValue(json, 'token')),
      profilePicture: AuthApiModel._toNullableString(
          AuthApiModel._readUserValue(json, 'profilePicture')),
    );
