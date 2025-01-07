import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController UpdatenameController = TextEditingController();
    final TextEditingController UpdatedescriptionController =
        TextEditingController();
    final CollectionReference items =
        FirebaseFirestore.instance.collection('items');

    return Scaffold(
        appBar: AppBar(
          title: Text("ToDo"),
          centerTitle: true,
        ),
        body: Column(
          children: [
            //create

            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(label: Text("Name")),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: descriptionController,
                decoration: InputDecoration(label: Text("Description")),
              ),
            ),
            ElevatedButton(
                onPressed: () async {
                  if (nameController.text.isNotEmpty &&
                      descriptionController.text.isNotEmpty) {
                    await items.add({
                      'name': nameController.text,
                      'description': descriptionController.text
                    });
                  }
                  nameController.clear();
                  descriptionController.clear();
                },
                child: Text("Add")),

            //Read
            Expanded(
              child: StreamBuilder(
                  stream: items.snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return CircularProgressIndicator();
                    return ListView(
                      children: snapshot.data!.docs.map((doc) {
                        return ListTile(
                          title: Text(doc['name']),
                          subtitle: Text(doc['description']),
                          trailing: Row(
                            //Update

                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                              title: Text("Update"),
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  TextField(
                                                    controller:
                                                        UpdatenameController,
                                                    decoration: InputDecoration(
                                                        labelText: 'Name'),
                                                  ),
                                                  TextField(
                                                    controller:
                                                        UpdatedescriptionController,
                                                    decoration: InputDecoration(
                                                        labelText:
                                                            'Description'),
                                                  )
                                                ],
                                              ),
                                              actions: [
                                                TextButton(
                                                    onPressed: () async {
                                                      await items
                                                          .doc(doc.id)
                                                          .update({
                                                        'name':
                                                            UpdatenameController
                                                                .text,
                                                        'description':
                                                            UpdatedescriptionController
                                                                .text
                                                      });
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text("Update"))
                                              ],
                                            ));
                                  },
                                  icon: Icon(Icons.edit)),

                              //delete

                              IconButton(
                                  onPressed: () async {
                                    await items.doc(doc.id).delete();
                                  },
                                  icon: Icon(CupertinoIcons.delete))
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  }),
            ),
          ],
        ));
  }
}
