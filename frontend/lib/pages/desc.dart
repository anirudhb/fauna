import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:fauna_frontend/pages/map.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class DescriptionPage extends StatefulWidget {
  final PickedFile image;
  
  const DescriptionPage({Key key, this.image}) : super(key: key);

  @override
  _DescriptionPageState createState() => _DescriptionPageState();
}

class _DescriptionPageState extends State<DescriptionPage> {
    TextEditingController textController;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 1,
          decoration: BoxDecoration(
            color: Color(0xFFEEEEEE),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                child: Text(
                  'Detected: ' + processImage(),
                  style: GoogleFonts.getFont(
                    'Poppins',
                    color: Color(0xFF606060),
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                child: Image.file(
                  File(widget.image.path),
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 60, 0, 0),
                child: Text(
                  'Description',
                  style: GoogleFonts.getFont(
                    'Poppins',
                    color: Color(0xFF606060),
                    fontWeight: FontWeight.w600,
                    fontSize: 25,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                child: Container(
                  width: 300,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Color(0xFFEEEEEE),
                  ),
                  child: Card(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    color: Color(0xFFF5F5F5),
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      controller: textController,
                      obscureText: false,
                      decoration: InputDecoration(
                        hintText: 'Type a description here (optional)',
                        hintStyle: GoogleFonts.getFont(
                          'Poppins',
                          color: Color(0xFF606060),
                          fontWeight: FontWeight.normal,
                          fontSize: 18,
                        ),
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      ),
                      style: GoogleFonts.getFont(
                        'Poppins',
                        color: Color(0xFF606060),
                        fontWeight: FontWeight.normal,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Container(
                  height: 44,
                  width: 230,
                  child: RaisedButton.icon(
                    icon: Padding(
                      padding: EdgeInsets.zero,
                      child: FaIcon(
                        Icons.add,
                        size: 20,
                        color: Colors.transparent,
                      ),
                    ),
                    label: AutoSizeText(
                      'Confirm',
                      style: GoogleFonts.getFont(
                        'IBM Plex Sans',
                        color: Color(0xFF606060),
                        fontWeight: FontWeight.w500,
                        fontSize: 17,
                      ),
                      maxLines: 1,
                    ),
                    onPressed: () async {
                      await postNewSighting();
                      // await Navigator.pushAndRemoveUntil(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => MapScreen(),
                      //   ),
                      //   (r) => false,
                      // );
                      // TODO PUSH TO MAP HERE AFTER PROCESSING THE POST REQUEST (depends on whether you want 'postNewSighting()' above to be async) (ani/soham)
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                        color: Colors.transparent,
                        width: 0,
                      ),
                    ),
                    color: Colors.white,
                    textColor: Color(0xFF606060),
                    elevation: 4,
                  ),
                )
              )
            ],
          ),
        ),
      ),
    );
  }

  void postNewSighting() async {
    //TODO post image/sighting here
  }

  String processImage() {
    //TODO process image ML here, return string of detected animal
    // the image is in the form of a file stream
    File image = File(widget.image.path);
  }
}