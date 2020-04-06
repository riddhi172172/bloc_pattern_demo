import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:pet/screens/add_pet_name.dart';

import '../helper/res.dart';
import '../helper/utils.dart';

class AddPet extends StatefulWidget {
  @override
  _AddPetState createState() => _AddPetState();
}

class _AddPetState extends State<AddPet> {
  String imagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Pet"),
      ),
      body: Column(
        children: <Widget>[
          InkResponse(
            child: Stack(
              children: <Widget>[
                Container(
                  margin:
                      EdgeInsets.only(top: 30, left: 30, right: 10, bottom: 10),
                  height: 140,
                  width: 140,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: imageShow(), fit: BoxFit.cover)),
                ),
                Positioned(
                  right: 10,
                  bottom: 20,
                  child: InkResponse(
                    child: Icon(Icons.add_a_photo),
                    onTap: () {
                      getImage();
                    },
                  ),
                )
              ],
            ),
            onTap: () {
              getImage();
            },
          ),
          Container(
            height: 35,
            width: 100,
            margin: EdgeInsets.only(top: 20.0),
            padding: EdgeInsets.only(top: 8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: ColorRes.black,
            ),
            child: InkResponse(
              child: Text(
                "NEXT",
                style: TextStyle(color: ColorRes.white),
                textAlign: TextAlign.center,
              ),
              onTap: () {

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddPetName()),
                );

//                  updateProfile();
              },
            ),
          )
        ],

//        ),
      ),
    );
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      imagePath = image.path.toString();
    }
    setState(() {});
  }

  imageShow() {
    return imagePath != null && imagePath.isNotEmpty
        ? imagePath.contains("http")
            ? NetworkImage(imagePath)
            : FileImage(File(imagePath))
        : AssetImage(Utils.getAssetsImg("profile"));
  }
}
