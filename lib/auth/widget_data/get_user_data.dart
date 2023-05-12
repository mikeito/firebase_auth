import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GetUserData extends StatelessWidget {
  final String documentId;

  const GetUserData({super.key, required this.documentId});

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    // return const Text('data');
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(documentId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;

          return ListTile(
            leading: CircleAvatar(
              child: Image.network(
                '${data['avatar']}',
                width: 200,
                height: 200,
              ),
            ),
            title: Text('${data['name']}'),
            subtitle: Text('${data['email']}'),
          );
        }
        return const Text('Loading...');
      },
    );
  }
}
