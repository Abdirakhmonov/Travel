import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:lesson_72/services/location_permission.dart';
import 'dart:io';

class TravelService {
  final _firebaseFireStore = FirebaseFirestore.instance.collection("travels");
  final _firebaseStorage = FirebaseStorage.instance;

  Stream<QuerySnapshot> getTravels() async* {
    yield* _firebaseFireStore.snapshots();
  }

  Future<void> addTravel(
    String title,
    String photoUrl,
  ) async {
    String downloadUrl = await _uploadImage(photoUrl);
    final location = await LocationPermission.getCurrentLocation();

    await _firebaseFireStore.add(
      {
        'title': title,
        'photoUrl': downloadUrl,
        'location': '${location.latitude}, ${location.longitude}'
      },
    );
  }

  Future<void> updateLocation(
    String documentId,
    String title,
    String filePath,
  ) async {
    String downloadUrl =
        filePath.startsWith('http') ? filePath : await _uploadImage(filePath);

    final location = await LocationPermission.getCurrentLocation();

    await _firebaseFireStore.doc(documentId).update(
      {
        'title': title,
        'photoUrl': downloadUrl,
        'location': '${location.latitude}, ${location.longitude}'
      },
    );
  }

  Future<void> deleteLocation(String id) async {
    await _firebaseFireStore.doc(id).delete();
  }

  Future<String> _uploadImage(String photo) async {
    File file = File(photo);
    TaskSnapshot snapshot = await _firebaseStorage
        .ref('locations/${file.uri.pathSegments.last}')
        .putFile(file);
    return await snapshot.ref.getDownloadURL();
  }
}
