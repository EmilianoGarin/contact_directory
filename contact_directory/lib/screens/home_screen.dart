import 'package:contact_directory/models/contact.dart';
import 'package:contact_directory/screens/detail_screen.dart';
import 'package:flutter/material.dart';
import '../services/api_service.dart';


class HomeScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback toggleTheme;

  HomeScreen({required this.isDarkMode, required this.toggleTheme});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Contact>> futureContacts;
  List<Contact> contacts = [];
  List<Contact> filteredContacts = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    futureContacts = fetchContacts();
    futureContacts.then((data) {
      setState(() {
        contacts = data;
        filteredContacts = data;
      });
    });
    searchController.addListener(() {
      filterContacts();
    });
  }

  void filterContacts() {
    List<Contact> listContacts = [];
    listContacts.addAll(contacts);
    if (searchController.text.isNotEmpty) {
      listContacts.retainWhere((contact) {
        String searchTerm = searchController.text.toLowerCase();
        String contactName = contact.name.toLowerCase();
        return contactName.contains(searchTerm);
      });
    }
    setState(() {
      filteredContacts = listContacts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(        
        title: Text('Contacts'),
        actions: [
          Switch(
            key: Key('themeSwitch'),
            value: widget.isDarkMode, // Usa el valor del parámetro
            onChanged: (value) {
              widget.toggleTheme(); // Llama a la función pasada por parámetro
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              key: Key('searchField'),
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search by name',
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Contact>>(
              future: futureContacts,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: \${snapshot.error}'));
                } else if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: filteredContacts.length,
                    itemBuilder: (context, index) {
                      Contact contact = filteredContacts[index];
                      return ListTile(
                        key: Key('contactTile_\${contact.id}'),
                        title: Text(contact.name),
                        subtitle: Text(contact.email),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailScreen(contact: contact),
                            ),
                          );
                        },
                      );
                    },
                  );
                } else {
                  return Center(child: Text('No contacts found'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}