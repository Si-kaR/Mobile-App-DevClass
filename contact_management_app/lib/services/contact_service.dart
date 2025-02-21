import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/contact.dart';

class ContactService {
  static const String baseUrl = 'https://apps.ashesi.edu.gh/contactmgt/actions';

  // Get a single contact
  Future<Contact?> getContact(int contactId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/get_a_contact_mob?contid=$contactId'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data == false || data.isEmpty) return null;
        return Contact.fromJson(data);
      } else {
        throw Exception('Failed to load contact');
      }
    } catch (e) {
      print('Error fetching contact: $e');
      return null;
    }
  }

  // Get all contacts
  Future<List<Contact>> getAllContacts() async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/get_all_contact_mob'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Contact.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load contacts');
      }
    } catch (e) {
      print('Error fetching contacts: $e');
      return [];
    }
  }

  // Add new contact
  Future<bool> addContact(String fullName, String phoneNumber, int pid) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/add_contact_mob'),
        body: {
          'ufullname': fullName,
          'uphonename': phoneNumber,
        },
      );

      if (response.statusCode == 200) {
        return response.body.trim() == 'success';
      } else {
        throw Exception('Failed to add contact');
      }
    } catch (e) {
      print('Error adding contact: $e');
      return false;
    }
  }

  // Edit contact
  Future<bool> editContact(
      int contactId, String newName, String newNumber) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/update_contact'),
        body: {
          'cid': contactId.toString(),
          'cname': newName,
          'cnum': newNumber,
        },
      );

      if (response.statusCode == 200) {
        return response.body.trim() == 'success';
      } else {
        throw Exception('Failed to update contact');
      }
    } catch (e) {
      print('Error updating contact: $e');
      return false;
    }
  }

  // Delete contact
  Future<bool> deleteContact(int contactId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/delete_contact'),
        body: {
          'cid': contactId.toString(),
        },
      );

      if (response.statusCode == 200) {
        return response.body.trim() == 'true';
      } else {
        throw Exception('Failed to delete contact');
      }
    } catch (e) {
      print('Error deleting contact: $e');
      return false;
    }
  }
}
