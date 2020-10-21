import 'dart:convert';
import 'dart:io';

import 'package:ShareApp/models/Cloudfile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class Storage {
  StorageReference reference = FirebaseStorage.instance.ref();
  StorageReference publicRefMetadata =
      FirebaseStorage.instance.ref().child("Public_Files/metadata.txt");
  CollectionReference publicCollection =
      Firestore.instance.collection('Public');

  // List all public files ..
  Future<List<Cloudfile>> listPublicFiles() async {
    List<Cloudfile> pf = new List();
    HttpClient httpClient = new HttpClient();
    List<String> Token;
    try {
      var myUrl = await publicRefMetadata.getDownloadURL();
      print(myUrl);
      var request = await httpClient.getUrl(Uri.parse(myUrl.toString()));
      var response = await request.close();
      if (response.statusCode == 200) {
        var bytes = await consolidateHttpClientResponseBytes(response);
        Token = utf8.decode(bytes).split("\n");
        print(Token);
      }
    } catch (ex) {
      print(ex);
    }
    if (Token.length != 0) {
      print('Tokens ' + Token[0]);
      for (int i = 0; i < Token.length; i++) {
        if (Token[i] != null) {
          Cloudfile p = new Cloudfile();
          await publicCollection
              .where('File_Name', isEqualTo: Token[i])
              .snapshots()
              .listen((data) {
            p.File_name = data.documents[0].data['File_Name'];
            p.LUri = data.documents[0].data['File'];
            print(p.toString());
            pf.add(p);
          });
        }
      }
    }
    return pf;
  }

  Future uploadFileToPublic(
      String File_Name, String path, List<String> tags) async {
    var stamp = DateTime.now().millisecondsSinceEpoch.toString();
    HttpClient httpClient = new HttpClient();
    var newbytes;
    try {
      var myUrl = await publicRefMetadata.getDownloadURL();
      print(myUrl);
      var request = await httpClient.getUrl(Uri.parse(myUrl.toString()));
      var response = await request.close();
      if (response.statusCode == 200) {
        var bytes = await consolidateHttpClientResponseBytes(response);
        String content = utf8.decode(bytes);
        content += '\n' + File_Name;
        print(content);
        newbytes = utf8.encode(content);
        print(newbytes);
      }
    } catch (ex) {
      print(ex);
    }
    await publicCollection.document(stamp).setData({
      'File_Name': File_Name,
      'File': File_Name + stamp,
      'Tags': tags,
    });
    StorageReference publicUploadRef =
        reference.child("Public_Files/" + File_Name + stamp);
    StorageUploadTask task1 = await publicRefMetadata
        .putData(newbytes); // adding name to metadata.txt
    StorageUploadTask task2 =
        await publicUploadRef.putFile(File(path)); // adding file to storage
  }

  Future<String> downloadPublicFileWithUrl(String uri) async {
    StorageReference publicDownloadRef = reference.child("Public_Files/" + uri);
    var url = publicDownloadRef.getDownloadURL();
    return url.toString();
  }

  Future<List<Cloudfile>> searchPublicFilesWithTags(String Tag) async {
    List<Cloudfile> pf = new List();
    await publicCollection
        .where("Tags", arrayContains: Tag)
        .snapshots()
        .listen((data) {
      print(data.documents.length);
      for (int i = 0; i < data.documents.length; i++) {
        Cloudfile p = new Cloudfile(
            File_name: data.documents[i].data['File_Name'],
            LUri: data.documents[i].data['File']);
        print(p.toString());
        pf.add(p);
      }
    });
    return pf;
  }

  //  for private files ..
  CollectionReference privateCollection =
      Firestore.instance.collection('Private');

  Future createMetadata(String uid) {
    StorageReference privateRefMetadata = FirebaseStorage.instance
        .ref()
        .child("Private_Files/" + uid + "/metadata");
    var bytes = utf8.encode(uid);
    privateRefMetadata.putData(bytes);
  }

  Future<List<Cloudfile>> listPrivateFiles(String uid) async {
    StorageReference privateRefMetadata = FirebaseStorage.instance
        .ref()
        .child("Private_Files/" + uid + "/metadata");
    List<Cloudfile> pf = [];
    HttpClient httpClient = new HttpClient();
    List<String> Token;
    try {
      var myUrl = await privateRefMetadata.getDownloadURL();
      // print(myUrl);
      var request = await httpClient.getUrl(Uri.parse(myUrl.toString()));
      var response = await request.close();
      if (response.statusCode == 200) {
        var bytes = await consolidateHttpClientResponseBytes(response);
        Token = utf8.decode(bytes).split("\n");
        // print(Token);
      }
    } catch (ex) {
      print(ex);
    }
    if (Token.length != 0) {
      for (int i = 0; i < Token.length; i++) {
        print(Token[i]);
        if (Token[i] != null || Token[i] != uid + "\n") {
          Cloudfile p = new Cloudfile();
          await privateCollection
              .where('File_Name', isEqualTo: Token[i])
              .where('uid', isEqualTo: uid)
              .snapshots()
              .listen((data) {
            p.File_name = data.documents[0].data['File_Name'];
            p.LUri = data.documents[0].data['File'];
            print("IN Storage for private files :: ");
            print(p.toString());
            pf.add(p);
          });
        }
      }
    }
    return pf;
  }

  Future uploadFileToPrivate(String File_Name, String path, String uid) async {
    StorageReference privateRefMetadata = FirebaseStorage.instance
        .ref()
        .child("Private_Files/" + uid + "/metadata");

    var stamp = DateTime.now().millisecondsSinceEpoch.toString();
    HttpClient httpClient = new HttpClient();
    var newbytes;
    try {
      var myUrl = await privateRefMetadata.getDownloadURL();
      print(myUrl);
      var request = await httpClient.getUrl(Uri.parse(myUrl.toString()));
      var response = await request.close();
      if (response.statusCode == 200) {
        var bytes = await consolidateHttpClientResponseBytes(response);
        String content = utf8.decode(bytes);
        content += '\n' + File_Name;
        print(content);
        newbytes = utf8.encode(content);
        print(newbytes);
      }
    } catch (ex) {
      print(ex);
    }
    await privateCollection.document(stamp).setData({
      'uid': uid,
      'File_Name': File_Name,
      'File': File_Name + stamp,
      'Key': uid + ":" + stamp,
    });
    StorageReference privateUploadRef =
        reference.child("Private_Files/" + uid + "/" + File_Name + stamp);
    StorageUploadTask task1 = await privateRefMetadata
        .putData(newbytes); // adding name to metadata.txt
    StorageUploadTask task2 =
        await privateUploadRef.putFile(File(path)); // adding file to sto
  }

  Future<dynamic> downloadPrivateFileWithUrl(String uri, String uid) async {
    StorageReference publicDownloadRef = FirebaseStorage.instance
        .ref()
        .child("Private_Files/" + uid + "/" + uri);
    var url = await publicDownloadRef.getDownloadURL();
    //print(url);
    return url;
  }

  String getUid(String key) {
    return key.split(":")[0];
  }

  Future<dynamic> fetchFileFromKey(String key) async {
    String uid = getUid(key);
    String f;
    var url;
    print(uid);
    await privateCollection
        .where("Key", isEqualTo: key)
        .snapshots()
        .listen((data) {
      print("Key is valid");
      print(data.documents.length);
      f = data.documents[0].data['File'];
      print(f);
      StorageReference publicDownloadRef =
          reference.child("Private_Files/" + uid + "/" + f);
      url = publicDownloadRef.getDownloadURL();
    });
    print(url);
    return url;
  }
}
