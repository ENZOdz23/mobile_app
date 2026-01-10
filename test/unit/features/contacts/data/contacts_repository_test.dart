import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:crm_sales_performance_mobilis/features/contacts/data/contacts_repository_impl.dart';
import 'package:crm_sales_performance_mobilis/features/contacts/data/datasources/contacts_remote_data_source.dart';
import 'package:crm_sales_performance_mobilis/features/contacts/models/contact.dart';

@GenerateMocks([IContactsRemoteDataSource])
import 'contacts_repository_test.mocks.dart';

void main() {
  late ContactsRepositoryImpl repository;
  late MockIContactsRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockIContactsRemoteDataSource();
    repository = ContactsRepositoryImpl(remoteDataSource: mockRemoteDataSource);
  });

  group('ContactsRepositoryImpl Tests', () {
    final tContact = Contact(
      id: '1',
      name: 'Test Contact',
      phoneNumber: '0555123456',
      email: 'test@example.com',
    );

    test('should return list of contacts from remote data source', () async {
      // Arrange
      when(
        mockRemoteDataSource.fetchContacts(),
      ).thenAnswer((_) async => [tContact]);

      // Act
      final result = await repository.getContacts();

      // Assert
      expect(result, [tContact]);
      verify(mockRemoteDataSource.fetchContacts()).called(1);
    });

    test('should successfully add contact', () async {
      // Arrange
      when(
        mockRemoteDataSource.createContact(any),
      ).thenAnswer((_) async => tContact);

      // Act
      await repository.addContact(tContact);

      // Assert
      verify(mockRemoteDataSource.createContact(tContact)).called(1);
    });

    test('should throw exception when remote call fails', () async {
      // Arrange
      when(
        mockRemoteDataSource.fetchContacts(),
      ).thenThrow(Exception('Remote Error'));

      // Act
      final call = repository.getContacts;

      // Assert
      expect(() => call(), throwsA(isA<Exception>()));
    });
  });
}
