// lib/features/contacts/data/datasources/contacts_remote_data_source.dart

import 'package:dio/dio.dart';
import '../../models/contact.dart';
import '../../../../core/api/api_client.dart';

abstract class IContactsRemoteDataSource {
  Future<List<Contact>> fetchContacts();
  Future<Contact> createContact(Contact contact);
  Future<Contact> updateContact(Contact contact);
  Future<void> deleteContact(String id);
}

class ContactsRemoteDataSource implements IContactsRemoteDataSource {
  final Dio _dio;
  static const String _endpoint = 'contacts';

  ContactsRemoteDataSource({Dio? dio}) : _dio = dio ?? Api.getDio();

  @override
  Future<List<Contact>> fetchContacts() async {
    try {
      final response = await _dio.get('/$_endpoint/');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> data = response.data is List
            ? response.data
            : (response.data as Map)['results'] ?? [];

        return data
            .map((item) => Contact.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to fetch contacts: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Remote: Failed to fetch contacts - $e');
    }
  }

  @override
  Future<Contact> createContact(Contact contact) async {
    try {
      final response = await _dio.post('/$_endpoint/', data: contact.toJson());

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Contact.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('Failed to create contact: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Remote: Failed to create contact - $e');
    }
  }

  @override
  Future<Contact> updateContact(Contact contact) async {
    try {
      final response = await _dio.put(
        '/$_endpoint/${contact.id}/',
        data: contact.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Contact.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('Failed to update contact: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Remote: Failed to update contact - $e');
    }
  }

  @override
  Future<void> deleteContact(String id) async {
    try {
      final response = await _dio.delete('/$_endpoint/$id/');

      if (response.statusCode != 204 && response.statusCode != 200) {
        throw Exception('Failed to delete contact: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Remote: Failed to delete contact - $e');
    }
  }
}
