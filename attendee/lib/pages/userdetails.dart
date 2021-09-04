import 'package:attendee/models/userdeails.dart';
import 'package:attendee/userdetailsTitle.dart';
import 'package:flutter/material.dart';
import 'package:attendee/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class UserDetails extends StatefulWidget {
  @override
  _UserDetailsState createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  @override
  Widget build(BuildContext context) {
    // final users = Provider.of<QuerySnapshot>(context);
    // for(var doc in users.docs){
    //   print(doc.data);
    // }

    final users = Provider.of<List<userdetails>>(context);

    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        return userdetailsTile(userdetail: users[index]);
      },
    );
  }
}
