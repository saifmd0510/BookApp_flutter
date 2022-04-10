import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../models/BookModel.dart';
import 'BookDetails.dart';

class CloudFirestoreSearch extends StatefulWidget {
  const CloudFirestoreSearch({Key? key}) : super(key: key);

  @override
  _CloudFirestoreSearchState createState() => _CloudFirestoreSearchState();
}

class _CloudFirestoreSearchState extends State<CloudFirestoreSearch> {
  String title = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Card(
          child: TextField(
            // ignore: prefer_const_constructors
            decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search), hintText: 'Search.. '),
            onChanged: (val) {
              setState(() {
                title = val;
              });
            },
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: (title != "" && title != null)
              ? FirebaseFirestore.instance
                  .collection("books")
                  .where("title", isGreaterThanOrEqualTo: title.toLowerCase())
                  .where("title", isLessThan: title.toLowerCase() + 'z')
                  .snapshots()
              : FirebaseFirestore.instance.collection("books").snapshots(),
          builder: (context, snapshot) {
            return (snapshot.connectionState == ConnectionState.waiting)
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) =>
                        buildBookCard(context, snapshot.data!.docs[index]));
          }),
    );
  }

  @override
  Widget buildBookCard(BuildContext context, DocumentSnapshot document) {
    final books = Books.fromSnapshot(document);
    // body:StreamBuilder<QuerySnapshot>(
    //     stream: (title != "" && title != null)
    //         ? FirebaseFirestore.instance
    //         .collection("books")
    //         .where("title", isGreaterThanOrEqualTo: title.toLowerCase())
    //         .snapshots()
    //         : FirebaseFirestore.instance.collection("books").snapshots(),
    //     builder: (context, snapshot) {
    //       return (snapshot.connectionState == ConnectionState.waiting)
    //           ? const Center(child: CircularProgressIndicator())
    //           : ListView.builder(
    //         itemCount: snapshot.data!.docs.length,
    //         itemBuilder: (context, index) {
    //           DocumentSnapshot data = snapshot.data!.docs[index];
    return Container(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        children: [
          ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BookDetails(books: books)),
              );
            },
            title: Text(books.title),
            //     style: const TextStyle(
            //         fontSize: 20, fontWeight: FontWeight.bold)),
            // trailing: const Icon(
            //   Icons.shopping_basket,
            //   color: Colors.red,
            //   size: 60,
            // ),
          ),
          const Divider(
            thickness: 2,
          )
        ],
      ),
    );
  }
}
