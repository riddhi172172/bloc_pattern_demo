import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet/bloc/get_events_bloc.dart';
import 'package:pet/helper/utils.dart';
import 'package:pet/model/get_event.dart';

class EventPage extends StatefulWidget {
  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  String imagePath = "";
  List<PetEvent> arrEvents = List();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getData();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 30, left: 30, right: 10, bottom: 10),
            height: 140,
            width: 140,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(image: imageShow(), fit: BoxFit.cover)),
          ),
          showItems(context)
        ],
      ),
    );
  }

  Expanded showItems(BuildContext context) {
    return Expanded(
        child: StreamBuilder(
            stream: getEventBloc.getEventsOb,
            builder: (context, AsyncSnapshot<List<PetEvent>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Utils.showShimmer();
              } else if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData)
                  return showData(snapshot?.data);
                else
                  Container();
              } else if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              return Container();
            }));
  }

  showData(List<PetEvent> data) {
    arrEvents = data;

    return ListView.builder(
      itemCount: arrEvents.length,
      itemBuilder: (BuildContext context, int index) {
        return showItem(index);
      },
    );
  }

  imageShow() {
    return imagePath != null && imagePath.isNotEmpty
        ? imagePath.contains("http")
            ? NetworkImage(imagePath)
            : FileImage(File(imagePath))
        : AssetImage(Utils.getAssetsImg("profile"));
  }

  showItem(int index) {
    return Container(
      child: Column(
        children: <Widget>[Text("Hello"), Text("This is the event")],
      ),
    );
  }

  void getData() async{
    await getEventBloc.getEvents();
  }
}
