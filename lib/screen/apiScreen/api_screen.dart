import 'package:chat_vendor/model/user_model.dart';
import 'package:chat_vendor/provider/chat_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/provider.dart';

class ContactDetailsScreen extends StatefulWidget {
  @override
  _ContactDetailsScreenState createState() => _ContactDetailsScreenState();
}

class _ContactDetailsScreenState extends State<ContactDetailsScreen> {
  List<String> names = [];

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserChatProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Details'),
      ),
      body: FutureBuilder<List<userModel>>(
        future: provider.fetchContactDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data![index].name),
                  subtitle: Text(snapshot.data![index].email),
                );
              },
            );
          }
        },
      ),
    );
  }
}
