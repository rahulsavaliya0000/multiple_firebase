import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase1/providers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Bike extends StatefulWidget {
  const Bike({super.key});

  @override
  State<Bike> createState() => _BikeState();
}
class _BikeState extends State<Bike> {
  @override
  Widget build(BuildContext context) {
    final environmentProvider = Provider.of<EnvironmentProvider>(context);
    final String environment = environmentProvider.selectedEnvironment;

    return Scaffold(
      body: FutureBuilder<QuerySnapshot>(
        future: fetchData(environment),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CupertinoActivityIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
            if (documents.isEmpty) {
              return Center(child: Text('No data available'));
            } else {
              return ListView.builder(
                itemCount: documents.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> data =
                      documents[index].data() as Map<String, dynamic>;
                  return Material( // Wrap with Material widget
                    child: ListTile(
                      title: Text(data['title']),
                      subtitle: Text(data['id']),
                    ),
                  );
                },
              );
            }
          }
        },
      ),
    );
  }

  Future<QuerySnapshot> fetchData(String environment) async {
    FirebaseFirestore firestore = FirebaseFirestore.instanceFor(
      app: environment == 'dev'
          ? Firebase.app('dev')
          : Firebase.app('production'),
    );
    return await firestore.collection('bike').get();
  }
}
