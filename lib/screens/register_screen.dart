import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_app/widgets/loading_blur.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class RegisterScreen extends StatefulWidget {
  final VoidCallback showLoginScreen;

  const RegisterScreen({super.key, required this.showLoginScreen});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _namecontroller = TextEditingController();
  final _emailcontroller = TextEditingController();
  final _passwordcontroller = TextEditingController();
  final _confirmpasswordcontroller = TextEditingController();

  String errorText = '';
  String errorAvatar = '';
  XFile? chosenImage;
  String iUrl = '';
  bool loading = false;

  Future pickImage() async {
    final imagefile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 75,
    );
    setState(() => chosenImage = imagefile);
  }

  Future<String> uploadFile() async {
    Reference ref = FirebaseStorage.instance.ref().child("profilepic.jpg");
    await ref.putFile(File(chosenImage!.path));
    return await ref.getDownloadURL();
  }

  Future signUp() async {
    print('signup pressed');
    setState(() => loading = true);
    // await Future.delayed(const Duration(seconds: 10));

    if (!passwordConfirmed()) {
      setState(() => errorText = 'Passwords should be the same');
    } else {
      setState(() => errorText = '');
    }

    if (chosenImage == null) {
      setState(() => errorAvatar = 'Please provide an avatar');
    } else {
      setState(() => errorAvatar = '');

      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailcontroller.text.trim(),
        password: _passwordcontroller.text.trim(),
      );
      iUrl = await uploadFile();
      await addUserDetails(
        _namecontroller.text.trim(),
        _emailcontroller.text.trim(),
        iUrl,
      );
    }

    setState(() => loading = false);
  }

  Future addUserDetails(String name, String email, String avatarUrl) async {
    await FirebaseFirestore.instance.collection('users').add({
      'name': name,
      'email': email,
      'avatar': avatarUrl,
    });
  }

  bool passwordConfirmed() {
    if (_passwordcontroller.text.trim() ==
        _confirmpasswordcontroller.text.trim()) {
      return true;
    }
    return false;
  }

  @override
  void dispose() {
    _namecontroller.dispose();
    _emailcontroller.dispose();
    _passwordcontroller.dispose();
    _confirmpasswordcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
          child: Center(
        child: SingleChildScrollView(
          child: Stack(children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'JOIN US',
                  // style: GoogleFonts.bebasNeue(fontSize: 52),
                  style: TextStyle(fontSize: 52),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'We are happy to have you',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 50),
                GestureDetector(
                  onTap: pickImage,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (chosenImage != null) ...[
                        // FileImage(chosenImage),

                        CircleAvatar(
                          radius: 80,
                          backgroundImage: FileImage(
                            File(chosenImage!.path),
                          ),
                        ),
                      ] else ...[
                        const CircleAvatar(
                          radius: 80,
                          child: Icon(
                            Icons.person_2_outlined,
                            size: 100,
                            color: Colors.black,
                          ),
                        )
                      ]
                    ],
                  ),
                ),
                Text(
                  errorAvatar,
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextField(
                    controller: _namecontroller,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.deepPurple),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'Full name',
                      fillColor: Colors.grey[200],
                      filled: true,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextField(
                    controller: _emailcontroller,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.deepPurple),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'Email',
                      fillColor: Colors.grey[200],
                      filled: true,
                    ),
                  ),
                ),

                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextField(
                    controller: _passwordcontroller,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.deepPurple),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'Password',
                      fillColor: Colors.grey[200],
                      filled: true,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextField(
                    controller: _confirmpasswordcontroller,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.deepPurple),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'Confirm Password',
                      fillColor: Colors.grey[200],
                      filled: true,
                    ),
                  ),
                ),
                // errorText != '' ? Text(errorText, style: TextStyle(color: Colors.redAccent),) : null,
                Text(
                  errorText,
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: GestureDetector(
                    onTap: () => signUp(),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.deepOrange,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'I am a member?',
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(width: 10.0),
                    GestureDetector(
                      onTap: widget.showLoginScreen,
                      child: const Text(
                        'Login now',
                        style:
                            TextStyle(fontSize: 18, color: Colors.deepOrange),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (loading) ...[LoadingBlur(size: size)],
          ]),
        ),
      )),
    );
  }
}
