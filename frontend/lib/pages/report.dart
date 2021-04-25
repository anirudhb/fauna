import 'dart:io';

import 'package:fauna_frontend/pages/desc.dart';
import 'package:fauna_frontend/pages/welcome.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({Key key}) : super(key: key);

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final picker = ImagePicker();

  Future getImage(bool camera) async {
    final pickedFile = await picker.getImage(
        source: camera ? ImageSource.camera : ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DescriptionPage(image: pickedFile,),
          ),
        );
      } else {
        print('No image selected.');
      }
    });
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
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () async {
                  getImage(false);
                },
                child: Container(
                  width: 200,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Color(0xFFE2D7FA),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: Icon(
                          Icons.image_outlined,
                          color: Colors.black,
                          size: 90,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: Text(
                          'Upload Picture',
                          style: GoogleFonts.getFont(
                            'IBM Plex Sans',
                            color: Color(0xFF606060),
                            fontWeight: FontWeight.w500,
                            fontSize: 22,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Text(
                'OR',
                style: GoogleFonts.getFont(
                  'IBM Plex Sans',
                  color: Color(0xFF606060),
                  fontWeight: FontWeight.normal,
                  fontSize: 18,
                ),
              ),
              InkWell(
                  onTap: () async {
                    getImage(false);
                  },
                  child: Container(
                    width: 200,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Color(0xFFE2D7FA),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.black,
                            size: 90,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: Text(
                            'Take Picture',
                            style: GoogleFonts.getFont(
                              'IBM Plex Sans',
                              color: Color(0xFF606060),
                              fontWeight: FontWeight.w500,
                              fontSize: 22,
                            ),
                          ),
                        )
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
