import "package:flutter/material.dart";

class Walkthrough {
  IconData icon;
  String title;
  String description;
  Widget extraWidget;
  String image;

  Walkthrough({this.icon, this.title, this.description, this.extraWidget, this.image}) {
    if (extraWidget == null) {
      extraWidget = new Container();
    }
  }
}