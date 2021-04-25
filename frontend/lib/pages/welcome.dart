import 'package:auto_size_text/auto_size_text.dart';
import 'package:fauna_frontend/auth/models.dart';
import 'package:fauna_frontend/pages/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomePageWidget extends StatefulWidget {
  WelcomePageWidget({Key? key}) : super(key: key);

  @override
  _WelcomePageWidgetState createState() => _WelcomePageWidgetState();
}

class _WelcomePageWidgetState extends State<WelcomePageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        child: Stack(
          children: [
            Align(
              alignment: Alignment(0, 0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 100, 0, 0),
                    child: SvgPicture.asset(
                      'assets/animal.svg',
                      width: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Align(
                    alignment: Alignment(-0.05, -0.75),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Text(
                        'Fauna',
                        style: GoogleFonts.getFont(
                          'Poppins',
                          color: Color(0xFF303030),
                          fontWeight: FontWeight.w600,
                          fontSize: 50,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Text(
                      'Slogan goes here ig',
                      style: GoogleFonts.getFont(
                        'Poppins',
                        color: Color(0xFF303030),
                        fontWeight: FontWeight.normal,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment(0, 0),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 160, 0, 0),
                      child: Container(
                        width: 230,
                        height: 44,
                        child: Stack(
                          children: [
                            Align(
                                alignment: Alignment(0, 0),
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
                                      'Sign in with Google',
                                      style: GoogleFonts.getFont(
                                        'IBM Plex Sans',
                                        color: Color(0xFF606060),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 17,
                                      ),
                                      maxLines: 1,
                                    ),
                                    onPressed: () async {
                                      final user =
                                          await signInWithGoogle(context);
                                      if (user == null) {
                                        return;
                                      }
                                      await Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              MainScreenWidget(),
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
                                )),
                            Align(
                              alignment: Alignment(-0.83, 0),
                              child: Container(
                                width: 22,
                                height: 22,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: Image.network(
                                  'https://i0.wp.com/nanophorm.com/wp-content/uploads/2018/04/google-logo-icon-PNG-Transparent-Background.png?w=1000&ssl=1',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
