import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import '../constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool addFlag = false;
  bool addFlag2 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Weedy"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {},
          )
        ],
      ),
      body: LayoutBuilder(builder: (context, c) {
        double itemHeight = c.maxHeight / 8;
        if (itemHeight > 70) itemHeight = 70;
        double spacing = c.maxHeight / 24;
        return Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Image.asset("assets/landingimg.png"),
                ],
              ),
            ),
            buildAddButton(spacing, itemHeight)
          ],
        );
      }),
    );
  }

  File file;

  Future<Null> _choose() async {
    file = await ImagePicker.pickImage(source: ImageSource.camera);
// file = await ImagePicker.pickImage(source: ImageSource.gallery);
  }

  void _upload() async {
    var request = new http.MultipartRequest(
      "POST",
      Uri.http("Ashwinddd03030.pythonanywhere.com", "/"),
    );
    request.fields['class'] = 'brinjal';
    request.files.add(await http.MultipartFile.fromPath(
      'image',
      file.path,
      contentType: MediaType('image', 'jpg'),
    ));
    request.send().then((response) async {
      if (response.statusCode == 200) print("Uploaded!");
      print(await response.stream.bytesToString());
      // Map<String, dynamic> user = jsonDecode(response.toString());
    });
    // if (file == null) return;
    // String base64Image = base64Encode(file.readAsBytesSync());
    // String fileName = file.path.split("/").last;

    // http.post("Ashwinddd03030.pythonanywhere.com/asdf").then((res) {
    //   print(res.statusCode);
    // }).catchError((err) {
    //   print(err);
    // });
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
  }

  Future<File> _cropImage(File imageFile) async {
    print("cropImage()");
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: imageFile.path,
      ratioX: 1.0,
      ratioY: 1.0,
    );
    print("cropImage()1");
    print(croppedFile.path);
    return croppedFile;
  }

  Widget buildAddButton(double spacing, double itemHeight) {
    double s = spacing / 2;
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        margin: EdgeInsets.only(right: spacing / 2),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            AnimatedOpacity(
              duration: Duration(milliseconds: 150),
              opacity: addFlag ? 1.0 : 0.0,
              child: GestureDetector(
                onTap: () {
                  // _upload();
                  _choose().then((_) {
                    _upload();
                  });
                },
                child: addFlag2
                    ? Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: secondaryColor,
                        ),
                        padding: EdgeInsets.all(s),
                        margin: EdgeInsets.only(bottom: spacing / 2),
                        child: Image.asset(
                          "assets/eggplant.png",
                          height: 24,
                        ),
                      )
                    : Container(),
              ),
            ),
            SizedBox(width: s),
            AnimatedOpacity(
              duration: Duration(milliseconds: 100),
              opacity: addFlag ? 1.0 : 0.0,
              child: GestureDetector(
                onTap: () {},
                child: addFlag2
                    ? Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: secondaryColor,
                        ),
                        padding: EdgeInsets.all(s),
                        margin: EdgeInsets.only(bottom: spacing / 2),
                        child: Image.asset(
                          "assets/lf.png",
                          height: 24,
                        ),
                      )
                    : Container(),
              ),
            ),
            SizedBox(width: s),
            Container(
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: BorderRadius.circular(100),
              ),
              padding: EdgeInsets.all(s),
              margin: EdgeInsets.only(bottom: s),
              child: GestureDetector(
                onTap: () async {
                  if (!addFlag) {
                    setState(() {
                      addFlag2 = true;
                      addFlag = true;
                    });
                  } else {
                    setState(() {
                      addFlag = false;
                    });
                    Future.delayed(Duration(milliseconds: 150),
                        () => setState(() => addFlag2 = false));
                  }
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    SizedBox(width: spacing / 4),
                    Text(
                      "Add",
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(width: spacing / 4),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
