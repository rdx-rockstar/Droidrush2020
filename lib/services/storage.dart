import 'dart:convert';
import 'dart:io';

import 'package:ShareApp/models/PublicFile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class Storage {

  StorageReference reference = FirebaseStorage.instance.ref();
  StorageReference publicRefMetadata = FirebaseStorage.instance.ref().child("Public_Files/metadata.txt");
  CollectionReference publicCollection = Firestore.instance.collection('Public');

  // List all public files ..
  Future<List<Publicfile>> listPublicFiles () async {
    List<Publicfile> pf;
    HttpClient httpClient = new HttpClient();
    List<String> Token;
    try {
      var myUrl = await publicRefMetadata.getDownloadURL();
      print(myUrl);
      var request = await httpClient.getUrl(Uri.parse(myUrl.toString()));
      var response = await request.close();
      if(response.statusCode == 200) {
        var bytes = await consolidateHttpClientResponseBytes(response);
        Token = utf8.decode(bytes).split("\n");
        print(Token);
      }
    }
    catch(ex){
      print(ex);
    }
    if( Token.length != 0 ) {
      print('Tokens ' + Token[0]);
      var d;
      for( int i=0;i<Token.length ; i++ ){
        if(Token[i] != null){
          Publicfile p = new Publicfile();
          await publicCollection.where('File_Name', isEqualTo: Token[i])
              .snapshots().listen( (data){
                p.File_name = data.documents[0].data['File_Name'];
                //p.tags = data.documents[0].data['Tags'];
                p.LUri = data.documents[0].data['File'];
                print(p.toString());
              }
          );
          //pf[i] = p;

        }
      }
    }
  }

  Future uploadFileToPublic (String File_Name, String path, List<String> tags) async {
    var stamp = DateTime.now().millisecondsSinceEpoch.toString();
    HttpClient httpClient = new HttpClient();
    var newbytes;
    try {
      var myUrl = await publicRefMetadata.getDownloadURL();
      print(myUrl);
      var request = await httpClient.getUrl(Uri.parse(myUrl.toString()));
      var response = await request.close();
      if(response.statusCode == 200) {
        var bytes = await consolidateHttpClientResponseBytes(response);
        String content = utf8.decode(bytes);
        content += '\n' + File_Name;
        print(content);
        newbytes = utf8.encode(content);
        print(newbytes);
      }
    }
    catch(ex){
      print(ex);
    }
    await publicCollection.document(stamp).setData({
      'File_Name': File_Name,
      'File': File_Name + stamp,
      'Tags': tags,
    });
    StorageReference publicUploadRef = reference.child("Public_Files/" + File_Name + stamp);
    StorageUploadTask task1 = await publicRefMetadata.putData(newbytes);   // adding name to metadata.txt
    StorageUploadTask task2 = await publicUploadRef.putFile(File(path));   // adding file to storage
  }

  Future downloadPublicFileWithUrl(String FileName) async {

  }

  Future<List<Publicfile>> searchPublicFilesWithTags(String Tag) async {

  }

}