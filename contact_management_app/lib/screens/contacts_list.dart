import 'package:flutter/material.dart';
import '../models/contact.dart';
import '../services/contact_service.dart';
import 'edit_contact.dart';

class ContactsListScreen extends StatefulWidget {
  @override
  _ContactsListScreenState createState() => _ContactsListScreenState();
}

class _ContactsListScreenState extends State<ContactsListScreen> {
  final ContactService _contactService = ContactService();
  late Future<List<Contact>> _contactsFuture;

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  // Load contacts
  void _loadContacts() {
    setState(() {
      _contactsFuture = _contactService.getAllContacts();
    });
  }

  // Delete contact
  void _deleteContact(int contactId) async {
    bool success = await _contactService.deleteContact(contactId);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Contact deleted successfully!')),
      );
      _loadContacts(); // Refresh list
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete contact')),
      );
    }
  }

  // Pull-to-refresh
  Future<void> _refreshContacts() async {
    _loadContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Contacts List')),
      body: RefreshIndicator(
        onRefresh: _refreshContacts,
        child: FutureBuilder<List<Contact>>(
          future: _contactsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error loading contacts'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No contacts found'));
            }

            final contacts = snapshot.data!;

            return ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                final contact = contacts[index];

                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    title: Text(contact.pname),
                    subtitle: Text(contact.pphone),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Edit button
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () async {
                            final updated = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditContactScreen(contactId: contact.pid),
                              ),
                            );
                            if (updated == true) {
                              _loadContacts(); // Refresh after editing
                            }
                          },
                        ),
                        // Delete button
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteContact(contact.pid),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
