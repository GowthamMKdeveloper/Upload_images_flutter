import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class Image_Upload_Example2 extends StatefulWidget {
  const Image_Upload_Example2({Key? key}) : super(key: key);

  @override
  State<Image_Upload_Example2> createState() => _Image_Upload_Example2State();
}

class _Image_Upload_Example2State extends State<Image_Upload_Example2> {
  bool loading = false;
  File? image;
  String? path_Name;
  String? filename;
  int imgsize = 0;
  bool buttonenable = false;

  Future pickImagefromGallery() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      // final imageTemp = File(image.path);
      final imageTemp = File(image.path);
      path_Name = imageTemp.path;
      filename = imageTemp.path.split('/').last;
      imgsize = 1;
      buttonenable == true;
      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future pickimagefromCamera() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;
      // final imageTemp = File(image.path);
      final imageTemp = File(image.path);
      path_Name = imageTemp.path;
      filename = imageTemp.path.split('/').last;
      imgsize = 1;
      buttonenable == true;
      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future Uploadfile_in_server() async {
    var url;
    url = Uri.parse('http://crynofill.indusnovateur.in:4200/uploadfiles');

    setState(() {
      loading = true;
    });
    // print(file.path);
    try {
      var request = http.MultipartRequest('POST', url);
      // print("Url : " + url);
      await http.MultipartFile.fromPath('files', path_Name!);
      print(request.files);
      print("files${request.files.length}");
      http.StreamedResponse response = await request.send();
      response.stream.transform(utf8.decoder).listen((value) {
        print(response.statusCode);
        print(value);
        if (response.statusCode == 200) {
          // Fluttertoast.showToast(
          //     msg: "Image upload successfully",
          //     toastLength: Toast.LENGTH_SHORT,
          //     gravity: ToastGravity.SNACKBAR,
          //     timeInSecForIosWeb: 1,
          //     backgroundColor: Colors.green,
          //     textColor: Colors.white,
          //     fontSize: 16.0);

          //li6 = FileUploadList.fromJson(jsonDecode(value));

          // print(li6.fieldname.toString());

          // for (int i = 0; i < li6.details.length; i++){
          //   print('Filename'+li6.details[i].filename);
          var uploadfilename =
              'http://crynofill.indusnovateur.in:4200/' + filename.toString();
          //
          // }

          print('uploadfilename : ' + uploadfilename);
          print("Success Image Upload");
          // postdataheader();
          Fluttertoast.showToast(
              msg: "Image Updated Succesfully", backgroundColor: Colors.green);
        }
        print(value);
      });
    } on PlatformException catch (e) {
      print("Exception Throw : $e");
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Image Picker Example_2"),
          actions: [
            GestureDetector(
                onTap: () {
                  Uploadfile_in_server();
                },
                child: Icon(Icons.save))
          ],
        ),
        body: Center(
          child: Column(
            children: [
              MaterialButton(
                  color: Colors.blue,
                  child: const Text("Pick Image from Gallery",
                      style: TextStyle(
                          color: Colors.white70, fontWeight: FontWeight.bold)),
                  onPressed: () {
                    pickImagefromGallery();
                  }),
              MaterialButton(
                  color: Colors.blue,
                  child: const Text("Pick Image from Camera",
                      style: TextStyle(
                          color: Colors.white70, fontWeight: FontWeight.bold)),
                  onPressed: () {
                    pickimagefromCamera();
                  }),
            ],
          ),
        ));
  }
}
