import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:fauna_frontend/auth/models.dart';
import 'package:fauna_frontend/pages/main_screen.dart';
import 'package:fauna_frontend/pages/map.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class DescriptionPage extends StatefulWidget {
  final PickedFile image;

  const DescriptionPage({Key? key, required this.image}) : super(key: key);

  @override
  _DescriptionPageState createState() => _DescriptionPageState();
}

class _DescriptionPageState extends State<DescriptionPage> {
  TextEditingController textController = TextEditingController();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _loading = true;
  String imageID = "";
  List<String> animals = [];

  @override
  void initState() {
    super.initState();
    (() async {
      imageID = await postImage(widget.image);
      animals = await processImage(imageID);
      setState(() => _loading = false);
    })();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        child: _loading
            ? Center(
                child: CircularProgressIndicator(value: null),
              )
            : Container(
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
                        'Detected: ' + animals.join(", "),
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
                              contentPadding:
                                  EdgeInsets.fromLTRB(10, 10, 10, 10),
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
                                Icons.location_pin,
                                size: 20,
                                color: Colors.black,
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
                              // going to exit anyways
                              setState(() => _loading = true);
                              // print("creating image");
                              // final imageID = await postImage(widget.image);
                              // print("image id = $imageID");
                              // final animals = await processImage(imageID);
                              // print("animals = $animals");
                              final id =
                                  await createSighting([imageID], animals);
                              print("sighting id = $id");
                              await Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MainScreenWidget(
                                    selectedIndex: 0,
                                  ),
                                ),
                                (r) => false,
                              );
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
                        ))
                  ],
                ),
              ),
      ),
    );
  }

  Future<String> postImage(PickedFile image) async {
    final r = await http.post(
      Uri.parse("https://decisive-router-311716.uc.r.appspot.com/upload"),
      body: await image.readAsBytes(),
    );
    final r2 = jsonDecode(r.body);
    return r2["blob"];
  }

  Future<List<String>> processImage(String imageID) async {
    final imageUrl = "gs://fauna-images/$imageID";
    final r = await http.get(Uri.parse(
        "https://decisive-router-311716.uc.r.appspot.com/identifyall?url=" +
            Uri.encodeQueryComponent(imageUrl)));
    final r2 = jsonDecode(r.body);
    return (r2["animals"] as List<dynamic>).cast<String>();
  }

  Future<String> createSighting(
      List<String> imageIDs, List<String> animals) async {
    final r = await http.post(
      Uri.parse(
          "https://decisive-router-311716.uc.r.appspot.com/animalsighting"),
      body: jsonEncode({
        // TODO location stuff
        "location": "San Jose, CA",
        "coordinates": [23.4, 52.3],
        "animals": animals,
        "images": imageIDs,
        "poster": currentUser!.user!.uid,
      }),
      headers: {"Content-Type": "application/json"},
    );
    return jsonDecode(r.body)["id"];
  }
}
