import 'package:cloud_firestore/cloud_firestore.dart';

class Travel {
  String id;
  String title;
  String photoUrl;
  String location;

  Travel(
      {required this.id,
      required this.title,
      required this.photoUrl,
      required this.location});

  factory Travel.fromJson(QueryDocumentSnapshot data) {
    return Travel(
        id: data.id,
        title: data["title"],
        photoUrl: data["photoUrl"],
        location: data["location"]);
  }
}
