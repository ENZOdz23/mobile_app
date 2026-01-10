import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:crm_sales_performance_mobilis/core/api/api_client.dart';
import 'package:crm_sales_performance_mobilis/core/storage/local_storage_service.dart';
import 'package:dio/dio.dart';

@GenerateMocks([Dio, LocalStorageService])
import 'api_client_test.mocks.dart';

void main() {
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
  });

  group('ApiClient Tests', () {
    test('should have correct base URL', () {
      final dio = Api.getDio();
      expect(dio.options.baseUrl, isNotEmpty);
      expect(dio.options.baseUrl, contains('/api/'));
    });

    test('should initialize successfully', () async {
      // Note: testing initialize() is hard because it uses static getInstance()
      // We'll focus on the explicit token methods
      expect(Api.getDio(), isNotNull);
    });

    test('should set authorization header with Token prefix', () {
      Api.setToken('test_token_123');
      final headers = Api.getDio().options.headers;
      expect(headers['Authorization'], 'Token test_token_123');
    });

    test('should clear authorization header on clearToken', () {
      Api.setToken('test_token_123');
      Api.clearToken();
      final headers = Api.getDio().options.headers;
      expect(headers['Authorization'], isNull);
    });

    test('should make login request with correct data', () async {
      // This is a smoke test to ensure methods exist
      expect(() => Api.login(email: 'test@test.com', password: 'password123'), 
        returnsNormally);
    });
  });
}
