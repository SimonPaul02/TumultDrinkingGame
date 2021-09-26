import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class More extends StatefulWidget {
  @override
  _MoreState createState() => _MoreState();
}

class _MoreState extends State<More> {
  final String iconFlag = "img/";

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("img/backgroundTriangle.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 60,
                  ),
                  Text(
                    "Programmiert von Simon Paul",
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Image.asset(
                            iconFlag + "instagram.png",
                          ),
                          iconSize: 70.0,
                          onPressed: () {
                            openUrl("https://www.instagram.com/simon._paul/");
                            //openUrl("https://www.medium.com");
                          },
                        ),
                        IconButton(
                            icon: Image.asset(iconFlag + "linkedin.png"),
                            iconSize: 70.0,
                            onPressed: () {
                              openUrl(
                                  "https://de.linkedin.com/in/simon-paul1/de");
                            }),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: OutlinedButton(
                        style: OutlinedButton.styleFrom(side: BorderSide.none),
                        child: Image.asset(
                          iconFlag + "review.png",
                        ),
                        onPressed: () {}),
                  ),
                  Text(
                    "Ich würde mich mega über gute Bewertungen freuen!!! (Einfach aufs obige Bild klicken)",
                    style: TextStyle(color: Colors.black, fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: IconButton(
                      icon: Image.asset(iconFlag + "donateButton.png"),
                      iconSize: 140.0,
                      onPressed: () {
                        openUrl(
                            "https://www.paypal.com/donate?hosted_button_id=RJVWS9WSKN4Y6");
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      "Ich freue mich über eure Spenden!!\n Wird selbstverständlich in die App gesteckt oder versoffen ;)",
                      style: TextStyle(color: Colors.yellow, fontSize: 15),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 9.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            icon: Image.asset(iconFlag + "GitHub.png"),
                            iconSize: 30,
                            onPressed: () {
                              openUrl(
                                  "https://github.com/SimonPaul02/TumultDrinkingGame/");
                            }),
                        TextButton(
                          onPressed: () {
                            openUrl(
                                "https://github.com/SimonPaul02/TumultDrinkingGame/");
                          },
                          child: Text(
                            "Hier findet ihr das Git-Repo",
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
          ),
        ),
      ),
    );
  }

  void openUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url
          //universalLinksOnly: true,
          );
    } else {
      throw ("Couldn't open URL");
    }
  }
}
