import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddDataScreen extends StatefulWidget {
  @override
  _AddDataScreenState createState() => _AddDataScreenState();
}

class _AddDataScreenState extends State<AddDataScreen> {
  String _selectedCategory = 'Food';
  String _title = '';
  String _id = '';

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _idController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Data'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButton<String>(
              value: _selectedCategory,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCategory = newValue!;
                });
              },
              items: <String>['Food', 'Car', 'Phone', 'Bike', 'Review']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
              onChanged: (value) {
                setState(() {
                  _title = value;
                });
              },
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _idController,
              decoration: InputDecoration(labelText: 'ID'),
              onChanged: (value) {
                setState(() {
                  _id = value;
                });
              },
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                _addData();
              },
              child: Text('Add Data'),
            ),
          ],
        ),
      ),
    );
  }

  void _addData() async {
    try {
      await FirebaseFirestore.instance.collection(_selectedCategory).add({
        'title': _title,
        'id': _id,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Data added successfully.'),
        ),
      );
      _titleController.clear();
      _idController.clear();
    } catch (e) {
      print('Error adding document: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add data.'),
        ),
      );
    }
  }
}
