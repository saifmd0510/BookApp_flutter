import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Books {
  String title;

  String author;

  String edition;

  Books(this.title, this.author, this.edition);

  Books.fromSnapshot(DocumentSnapshot snapshot)
      : title = snapshot['title'],
        author = snapshot['author'],
        edition = snapshot['edition'];
}
