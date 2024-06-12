import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cashy_app/screen/dashboard_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() {
    return _Login();
  }
}

class _Login extends State<Login> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscureText = true; // Tambahkan variabel ini

  Future<void> _login() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please enter your username and password')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    const url = 'https://presensi.spilme.id/login';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );
    if (kDebugMode) {
      print(response.statusCode);
    }
    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      final nik = responseBody['nik'];
      final token = responseBody['token'];
      final name = responseBody['nama'];
      final dept = responseBody['departemen'];
      final imgUrl = responseBody['imgUrl'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt', token);
      await prefs.setString('name', name);
      await prefs.setString('dept', dept);
      await prefs.setString('imgProfil', imgUrl);
      await prefs.setString('nik', nik);

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const Dashboard()),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid username or password')),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(
                height: 80,
              ),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //Logo aplikasi
                    Image.asset(
                      'assets/images/POLBENG.png',
                      height: 128,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          text: 'Selamat Datang\ndi ',
                          style: GoogleFonts.manrope(
                            fontSize: 32,
                            color: const Color(0xFF101317),
                            fontWeight: FontWeight.w800,
                          ),
                          children: const [
                            TextSpan(
                                text: 'PresensiApp',
                                style: TextStyle(
                                    color: Color(0xFF12A3DA),
                                    fontWeight: FontWeight.w800))
                          ]),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Halo, silahkan masuk untuk melanjutkan',
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        color: const Color(0xFFACAFB5),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(color: Color(0xFF12A3DA)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(color: Color(0xFF12A3DA)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(color: Color(0xFF12A3DA)),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(color: Color(0xFF12A3DA)),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: _togglePasswordVisibility,
                        ),
                      ),
                      obscureText: _obscureText,
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () {
                        if (kDebugMode) {
                          print('lupa password tapped');
                        }
                      },
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Lupa Password?',
                          style: GoogleFonts.manrope(
                            fontSize: 14,
                            color: const Color(0xFF9B59B6),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: _login,
                            style: ElevatedButton.styleFrom(
                                minimumSize: const Size(
                                    double.infinity, 50), // width and height
                                backgroundColor: const Color(0xFF12A3DA),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                            child: Text(
                              'Masuk',
                              style: GoogleFonts.manrope(
                                fontSize: 20,
                              ),
                            ),
                          ),
                    const SizedBox(height: 16),
                    Text(
                      'Masuk dengan sidik jari?',
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        color: const Color(0xFF101317),
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.fingerprint, size: 48, color: Colors.grey),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {},
                      child: RichText(
                        text: TextSpan(
                          style: GoogleFonts.manrope(
                            fontSize: 14,
                            color: const Color(0xFF101317),
                          ),
                          children: const [
                            TextSpan(text: 'Belum punya akun? '),
                            TextSpan(
                              text: 'Daftar',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF9B59B6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
