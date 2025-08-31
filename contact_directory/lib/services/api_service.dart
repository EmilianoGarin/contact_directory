import 'package:http/http.dart' as http;
import 'dart:convert';

class Contact {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String website;

  Contact(this.id, this.name, this.email, this.phone, this.website);

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      json['id'],
      json['name'],
      json['email'],
      json['phone'],
      json['website'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'website': website,
    };
  }
}

Future<List<Contact>> fetchContacts() async {
  Uri url = Uri.parse('https://jsonplaceholder.typicode.com/users');

  try{
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Contact.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load contacts');
    }
  } catch (e) {
    throw Exception('Failed to load contacts: $e');
  }
}

void main() async {
    List<Contact> contacts = await fetchContacts();
    if (contacts.isNotEmpty) {
      print('Successfully fetched ${contacts.length} contacts.');
      // You can add more checks here, e.g., check the structure of the first contact
      print('First contact: ${contacts[0].name}');
    } else {
      print('Successfully fetched contacts, but the list is empty.');
    }
}



