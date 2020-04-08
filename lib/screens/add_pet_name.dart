import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet/bloc/get_pet_bloc.dart';
import 'package:pet/helper/prefkeys.dart';
import 'package:pet/helper/res.dart';
import 'package:pet/helper/utils.dart';
import 'package:pet/injection/dependency_injection.dart';
import 'package:pet/model/get_pet.dart';
import 'package:pet/screens/home.dart';
import 'package:pet/webapi/web_api.dart';

class AddPetName extends StatefulWidget {
  @override
  _AddPetNameState createState() => _AddPetNameState();
}

class _AddPetNameState extends State<AddPetName> {
  String imagePath;

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();

    return Scaffold(
//      appBar: AppBar(
//        title: Text("Add pet"),
//      ),
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
                      color: Colors.grey,
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
          TextField(
            keyboardType: TextInputType.emailAddress,
            controller: nameController,
            decoration: InputDecoration(
              labelText: "Pet name",
              hintText: "",
            ),
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
                "ADD",
                style: TextStyle(color: ColorRes.white),
                textAlign: TextAlign.center,
              ),
              onTap: () async {
                if (nameController.value != null &&
                    nameController.value.text.toString().isNotEmpty) {
                  await WebApi()
                      .addPetData(WebApi.addPet, File(imagePath),
                          nameController.value.text.toString())
                      .then((data) async {
                    if (data != null) {
                      PetData petData = PetData.fromJson(data);

                      await Injector.prefs.setString(
                          PrefKeys.petData, jsonEncode(petData.toJson()));

                      Injector.petData = petData;

                      getPetBloc.getPet();

                      Utils.showToast("Pet added successfully");
                      nameController.text = "";
                      imagePath = "";
                      setState(() {});
                    }
                  });
                }
              },
            ),
          )
        ],
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

  void navigateToHome(BuildContext context) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
        ModalRoute.withName("/addpet"));
  }
}
