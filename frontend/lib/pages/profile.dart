import 'package:auto_size_text/auto_size_text.dart';
import 'package:fauna_frontend/auth/models.dart';
import 'package:fauna_frontend/pages/welcome.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      drawer: Drawer(
        elevation: 16,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
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
                  'Log Out',
                  style: GoogleFonts.getFont(
                    'IBM Plex Sans',
                    color: Color(0xFF606060),
                    fontWeight: FontWeight.w500,
                    fontSize: 17,
                  ),
                  maxLines: 1,
                ),
                onPressed: () async {
                  await signOut();
                  await Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WelcomePageWidget(),
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
            )
          ],
        ),
      ),
      body: SafeArea(
        child: Align(
          alignment: Alignment(0, 0.05),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(0, 15, 0, 10),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment(0, 0),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                        child: InkWell(
                          onTap: () async {
                            scaffoldKey.currentState?.openDrawer();
                          },
                          child: Icon(
                            Icons.keyboard_control,
                            color: Color(0xFF263238),
                            size: 20,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                    child: Container(
                      width: 90,
                      height: 90,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Image.network(
                        currentUser!.user!.photoURL!,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                    child: Text(
                      currentUser!.user!.displayName!,
                      style: GoogleFonts.getFont(
                        'Quicksand',
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 32, 0, 0),
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: Color(0xFFF5F5F5),
                    border: Border.all(
                      color: Color(0xFFD6D6D6),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
