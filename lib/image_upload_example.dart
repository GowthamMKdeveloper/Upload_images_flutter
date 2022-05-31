import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:image_upload/Image_upload_ex2.dart';

class Image_Upload extends StatefulWidget {
  const Image_Upload({Key? key}) : super(key: key);

  @override
  State<Image_Upload> createState() => _Image_UploadState();
}

class _Image_UploadState extends State<Image_Upload> {
  bool loading = false;
  File? _image;
  String? filename;

  var filepath;
  List<String> file = [];
  final picker = ImagePicker();

  String? basename;
  // Implementing the image picker
  Future<void> _openImagePicker() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    // final PickedFile? pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      // _image = File(pickedFile);
    });
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        print(_image);
        basename = _image?.path;
        filename = _image?.path.split('/').last;
        print("base name" + basename!);
        print("PATH" + filename!);
        //     path();
      });
    }
  }

  path() {
    for (int i = 0; i < file.length; i++)
      if (i == 0 || file.length == 1)
        filepath = filepath + file[i].split('/').last;
      else
        filepath = filepath + ',' + file[i].split('/').last;
    print("filepath" + filepath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Upload'),
        actions: [
          GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (builder) => const Image_Upload_Example2()));
              },
              child: const Icon(Icons.navigate_next))
        ],
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 32,
          ),
          Center(
            child: GestureDetector(
              onTap: () {
                _showPicker(context);
              },
              child: CircleAvatar(
                radius: 55,
                backgroundColor: Color(0xffFDCF09),
                child: _image != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.file(
                          _image!,
                          width: 100,
                          height: 100,
                          fit: BoxFit.fitHeight,
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(50)),
                        width: 100,
                        height: 100,
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.grey[800],
                        ),
                      ),
              ),
            ),
          )
        ],
      ),
      persistentFooterButtons: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Container(
                height: 40,
                child: FloatingActionButton.extended(
                    elevation: 5,
                    backgroundColor: Colors.redAccent.shade200,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.cancel),
                    label: Text('Cencel'),
                    heroTag: Text("")),
              ),
            ),
            SizedBox(
              width: 4,
            ),
            Expanded(
              child: Container(
                height: 40,
                child: FloatingActionButton.extended(
                    elevation: 5,
                    backgroundColor: Colors.green.shade800,
                    onPressed: () {
                      setState(() {
                        Photoupload();
                      });
                    },
                    icon: Icon(Icons.play_arrow),
                    label: Text('Save'),
                    heroTag: Text("")),
              ),
            ),
          ],
        )
      ],
    );
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _openImagePicker();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      //   _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future Photoupload() async {
    var url;
    url = Uri.parse('http://crynofill.indusnovateur.in:4200/uploadfiles');

    setState(() {
      loading = true;
    });
    // print(file.path);
    try {
      var request = http.MultipartRequest('POST', url);
      await http.MultipartFile.fromPath('files', basename!);
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
              'http://14.98.224.37:2121/' + filename.toString();
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
}
