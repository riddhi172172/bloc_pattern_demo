import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet/helper/prefkeys.dart';
import 'package:pet/helper/res.dart';
import 'package:pet/injection/dependency_injection.dart';
import 'package:pet/model/get_pet.dart';
import 'package:pet/screens/home.dart';
import 'package:pet/webapi/web_api.dart';

class AddPetName extends StatefulWidget {
  final String photo;

  AddPetName({this.photo}) : super();

  @override
  _AddPetNameState createState() => _AddPetNameState();
}

class _AddPetNameState extends State<AddPetName> {
  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text("Add pet"),
      ),
      body: Column(
        children: <Widget>[
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
                      .addPetData(WebApi.addPet, File(widget.photo),
                          nameController.value.text.toString())
                      .then((data) async {
                    if (data != null) {
                      PetData petData = PetData.fromJson(data);

                      await Injector.prefs.setString(
                          PrefKeys.petData, jsonEncode(petData.toJson()));

                      Injector.petData = petData;

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
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
}
