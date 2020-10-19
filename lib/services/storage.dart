import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class Storage {

  StorageReference reference = FirebaseStorage.instance.ref();
  StorageReference publicrefmetadata = FirebaseStorage.instance.ref().child("Public_Files/metadata.txt");
  // List all public files ..
  Future<List<String>> listPublicFiles () async {
    HttpClient httpClient = new HttpClient();
    List<String> Token;
    try {
      var myUrl = await publicrefmetadata.getDownloadURL();
      print(myUrl);
      var request = await httpClient.getUrl(Uri.parse(myUrl.toString()));
      var response = await request.close();
      if(response.statusCode == 200) {
        var bytes = await consolidateHttpClientResponseBytes(response);
        Token = utf8.decode(bytes).split("\n");
      }
    }
    catch(ex){
      print(ex);
    }
    return Token;
  }

  Future uploadFileToPublic (String File_Name, String path) async {
    HttpClient httpClient = new HttpClient();
    var newbytes;
    try {
      var myUrl = await publicrefmetadata.getDownloadURL();
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
    StorageReference publicuploadref = reference.child("Public_Files/" + File_Name);
    StorageUploadTask task1 = publicrefmetadata.putData(newbytes);
    StorageUploadTask task2 = publicuploadref.putFile(File(path));
  }

}