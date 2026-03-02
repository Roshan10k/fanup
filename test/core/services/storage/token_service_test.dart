import 'package:flutter_test/flutter_test.dart';
import 'package:fanup/core/services/storage/token_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mocktail/mocktail.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late TokenService tokenService;
  late MockFlutterSecureStorage mockStorage;

  setUp(() {
    mockStorage = MockFlutterSecureStorage();
    tokenService = TokenService(storage: mockStorage);
  });

  group('TokenService', () {
    group('init', () {
      test('should load token from secure storage into memory cache', () async {
        when(() => mockStorage.read(key: 'auth_token'))
            .thenAnswer((_) async => 'cached-jwt-token');

        await tokenService.init();

        expect(tokenService.getToken(), 'cached-jwt-token');
        verify(() => mockStorage.read(key: 'auth_token')).called(1);
      });

      test('should set null when no token exists in storage', () async {
        when(() => mockStorage.read(key: 'auth_token'))
            .thenAnswer((_) async => null);

        await tokenService.init();

        expect(tokenService.getToken(), null);
      });
    });

    group('saveToken', () {
      test('should write token to secure storage and update cache', () async {
        when(() =>
                mockStorage.write(key: 'auth_token', value: 'new-jwt-token'))
            .thenAnswer((_) async {});

        await tokenService.saveToken('new-jwt-token');

        expect(tokenService.getToken(), 'new-jwt-token');
        verify(() =>
                mockStorage.write(key: 'auth_token', value: 'new-jwt-token'))
            .called(1);
      });
    });

    group('getToken', () {
      test('should return null before init or saveToken', () {
        expect(tokenService.getToken(), null);
      });

      test('should return cached token after saveToken', () async {
        when(() => mockStorage.write(key: any(named: 'key'), value: any(named: 'value')))
            .thenAnswer((_) async {});

        await tokenService.saveToken('my-token');

        expect(tokenService.getToken(), 'my-token');
      });
    });

    group('deleteToken', () {
      test('should clear token from secure storage and cache', () async {
        when(() => mockStorage.write(key: any(named: 'key'), value: any(named: 'value')))
            .thenAnswer((_) async {});
        when(() => mockStorage.delete(key: 'auth_token'))
            .thenAnswer((_) async {});

        await tokenService.saveToken('token-to-delete');
        expect(tokenService.getToken(), 'token-to-delete');

        await tokenService.deleteToken();

        expect(tokenService.getToken(), null);
        verify(() => mockStorage.delete(key: 'auth_token')).called(1);
      });
    });
  });
}
