import 'package:firebase1/bike.dart';
import 'package:firebase1/carr.dart';
import 'package:firebase1/food.dart';
import 'package:firebase1/phone.dart';
import 'package:firebase1/providers.dart';
import 'package:firebase1/review.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase1/firebase/dev/firebase_options.dart' as dev;
import 'package:firebase1/firebase/production/firebase_options.dart'
    as production;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    name: 'dev',
    options: dev.DefaultFirebaseOptions.currentPlatform,
  );

  await Firebase.initializeApp(
    name: 'production',
    options: production.DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ChangeNotifierProvider(
      create: (context) => EnvironmentProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Example',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('dev Production',
            style: TextStyle(
                color: Colors.blue.shade900,
                fontWeight: FontWeight.w500,
                fontSize: 20)),
        actions: [
          EnvironmentToggleButtons(),
          SizedBox(
            width: 10,
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Categories',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Food'),
              onTap: () {
          
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Food()));
      
              },
            ),
            ListTile(
              title: Text('Car'),
              onTap: () {
   Navigator.push(
              context, MaterialPageRoute(builder: (context) => Carr()));
      
                
               },
            ),
            ListTile(
              title: Text('Bike'),
              onTap: () {
                // Implement your action when Bike is tapped
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Bike()));
      
                   },
            ),
            ListTile(
              title: Text('Phone'),
              onTap: () {
                // Implement your action when Phone is tapped
           Navigator.push(
              context, MaterialPageRoute(builder: (context) => Phone()));
      
                   },
            ),
            ListTile(
              title: Text('Review'),
              onTap: () {
            Navigator.push(
              context, MaterialPageRoute(builder: (context) => Review()));
      
                },
            ),
          ],
        ),
      ),
      body: Material(
        child: FirebaseDataScreen(),
      ),
    );
  }
}


class EnvironmentToggleButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final environmentProvider = Provider.of<EnvironmentProvider>(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.0),
        border: Border.all(
          color: environmentProvider.selectedEnvironment == 'dev'
              ? Colors.blueAccent
              : Colors.green,
          width: 2.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5.0,
            spreadRadius: 0.5,
          ),
        ],
      ),
      child: ToggleButtons(
        borderRadius: BorderRadius.circular(16.0),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Text(
              'Dev',
              style: TextStyle(
                color: environmentProvider.selectedEnvironment == 'dev'
                    ? Colors.blue.shade900
                     : Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Text(
              'Production',
              style: TextStyle(
                color: environmentProvider.selectedEnvironment == 'production'
                    ? Colors.green
                    : Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
        isSelected: [
          environmentProvider.selectedEnvironment == 'dev',
          environmentProvider.selectedEnvironment == 'production',
        ],
        onPressed: (index) {
          final selectedEnvironment = index == 0 ? 'dev' : 'production';
          environmentProvider.setSelectedEnvironment(selectedEnvironment);
        },
      ),
    );
  }
}



class FirebaseDataScreen extends StatelessWidget {
  const FirebaseDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final environmentProvider = Provider.of<EnvironmentProvider>(context);
    final String environment = environmentProvider.selectedEnvironment;
    var firestore =
        FirebaseFirestore.instanceFor(app: Firebase.app(environment));

    return Scaffold(
      appBar: AppBar(
        title: Text(' $environment Data'),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: firestore.collection('users').get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CupertinoActivityIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView(
              children: snapshot.data!.docs.map((doc) {
                Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                return ListTile(
                  title: Text(data['title']),
                  subtitle: Text(data['id']),
                );
              }).toList(),
            );
          }
        },
      ),
    );
  }
}
