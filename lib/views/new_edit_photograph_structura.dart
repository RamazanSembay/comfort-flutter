import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comfort/services/crud.dart';
import 'package:comfort/views/register_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';
import 'package:xfile/xfile.dart';

class NewEditPhotographStructura extends StatefulWidget {
  @override
  State<NewEditPhotographStructura> createState() =>
      _NewEditPhotographStructuraState();
}

class _NewEditPhotographStructuraState
    extends State<NewEditPhotographStructura> {
  File selectedImage;
  bool _isLoading = false;
  // CrudMethods crudMethods = new CrudMethods();

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      selectedImage = image;
    });
  }

  UserCredential userCredential;

  uploadBlog() async {
    if (selectedImage != null) {
      setState(() {
        _isLoading = true;
      });

      /// uploading image to firebase storage
      StorageReference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child("blogImages")
          .child("${randomAlphaNumeric(9)}.jpg");

      final StorageUploadTask task = firebaseStorageRef.putFile(selectedImage);

      var downloadUrl = await (await task.onComplete).ref.getDownloadURL();
      print("this is url $downloadUrl");

      // Map<String, String> blogMap = {
      //   "imgUrl": downloadUrl,
      // };

      // crudMethods.addData(blogMap).then((result) {
      //   Navigator.pop(context);
      // });

      FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser.uid)
          .set(
        {
          "Id": FirebaseAuth.instance.currentUser.uid,
          "FullName": fullName.text,
          "Email": email.text,
          "Password": password.text,
          "Phone": phone.text,
          "Img": downloadUrl,
          "Date": DateTime.now(),
        },
      ).then(
        (value) => {
          Navigator.pop(context),
        },
      );

      Navigator.pop(context);

      // crudMethods.addUserData(data: {
      //   'img': downloadUrl,
      //   'date': DateTime.now(),
      // }).then(
      //   (value) => {
      //     Navigator.pop(context),
      //   },
      // );
    } else {}
  }

  User user = FirebaseAuth.instance.currentUser;
  DocumentSnapshot vendorData;

  @override
  void initState() {
    getVendorData();
    super.initState();
  }

  Future<DocumentSnapshot> getVendorData() async {
    var result = await FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .get();
    setState(() {
      vendorData = result;
    });
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Container(
        color: Colors.white,
        height: 120,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                uploadBlog();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Icon(
                      Icons.edit,
                      size: 24,
                      color: Color(0xff444444),
                    ),
                  ),
                  Text(
                    'Сақтау',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff444444),
                      fontFamily: 'OpenSans',
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 35),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Icon(
                      Icons.arrow_back,
                      size: 24,
                      color: Color(0xff444444),
                    ),
                  ),
                  Text(
                    'Артқа қайту',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff444444),
                      fontFamily: 'OpenSans',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Container(
        child: ListView(
          children: [
            Padding(
              padding:
                  EdgeInsets.only(left: 20, right: 20, top: 40, bottom: 30),
              child: Container(
                height: 60,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xff444444).withOpacity(0.5),
                      blurRadius: 10,
                      spreadRadius: 0,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Icon(
                                Icons.edit,
                                size: 24,
                                color: Color(0xff444444),
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Фотосуретті Өзгерту',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Color(0xff444444),
                                fontFamily: 'OpenSans',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 150),
              child: _isLoading
                  ? Container(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(),
                    )
                  : Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            getImage();
                          },
                          child: selectedImage != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(25.0),
                                  child: Image.file(
                                    selectedImage,
                                    fit: BoxFit.cover,
                                    height: 150,
                                    width: 150,
                                  ),
                                )
                              : Container(
                                  height: 150,
                                  width: 150,
                                  decoration: BoxDecoration(
                                    color: Color(0xff444444),
                                    borderRadius: BorderRadius.circular(500),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.photo_camera,
                                        size: 50,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                      ],
                    ),
            ),
            Visibility(
              visible: false,
              child: Column(
                children: [
                  Text(
                    vendorData != null ? vendorData.data()['Id'] : '',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff222222),
                      fontFamily: 'OpenSans',
                    ),
                  ),
                  Text(
                    vendorData != null ? vendorData.data()['FullName'] : '',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff222222),
                      fontFamily: 'OpenSans',
                    ),
                  ),
                  Text(
                    vendorData != null ? vendorData.data()['Email'] : '',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff222222),
                      fontFamily: 'OpenSans',
                    ),
                  ),
                  Text(
                    vendorData != null ? vendorData.data()['Password'] : '',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff222222),
                      fontFamily: 'OpenSans',
                    ),
                  ),
                  Text(
                    vendorData != null ? vendorData.data()['Phone'] : '',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff222222),
                      fontFamily: 'OpenSans',
                    ),
                  ),
                  Text(
                    vendorData != null ? vendorData.data()['Img'] : '',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff222222),
                      fontFamily: 'OpenSans',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
