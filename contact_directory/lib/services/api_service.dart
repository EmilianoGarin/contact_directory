import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/contact.dart';

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



