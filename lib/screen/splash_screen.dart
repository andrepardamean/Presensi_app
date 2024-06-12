import 'package:flutter/material.dart';
import 'package:cashy_app/screen/login_form.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) {
    // Delay 3 detik untuk menampilkan form login
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    });
    return Scaffold(
      body: Center(
        child: Container(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment
              .center, // Menjadikan gambar dan teks ditengah secara horizontal
          mainAxisAlignment: MainAxisAlignment
              .center, // Menjadikan gambar dan teks ditengah secara vertical
          children: <Widget>[
            Image(
              image: AssetImage("assets/images/POLBENG.png"),
              width: 200,
              height: 200,
            ),
            Padding(padding: EdgeInsets.only(top: 10.0)),
            Text(
              "PresensiApp",
              style: TextStyle(
                  fontSize: 34,
                  color: Color(0xFF12A3DA),
                  fontWeight: FontWeight.w700),
            )
          ],
        )),
      ),
    );
  }
}

