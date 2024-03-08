import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ContactDetailsScreen extends StatefulWidget {
  @override
  _ContactDetailsScreenState createState() => _ContactDetailsScreenState();
}

class _ContactDetailsScreenState extends State<ContactDetailsScreen> {
  List<String> names = [];
  Future<List<String>> fetchContactDetails() async {
    print("https://itsolutionsguides.com/api/contact_details");
    final response = await http
        .get(Uri.parse('https://itsolutionsguides.com/api/contact_details'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      // print(jsonResponse['data']);
       names = json.decode(jsonResponse["data"]).cast<String>();
      print(names);
      // for (var i = 0; i < jsonResponse["data"].length; i++) {
      //   print(jsonResponse["data"]);
      //   names.add(jsonResponse["data"][i]);
      // }

      // final List<String> names = jsonResponse['data'];
      // print(jsonResponse['data']);
      return List<String>.from(names);
    } else {
      throw Exception('Failed to load contact details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Details'),
      ),
      body: FutureBuilder<List<String>>(
        future: fetchContactDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.builder(
              itemCount: names.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(names[index].toString()),
                );
              },
            );
          }
        },
      ),
    );
  }
}
