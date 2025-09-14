import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:musicplay/core/theme/app_color.dart';
import 'package:musicplay/features/auth/view/pages/signin_page.dart';
import 'package:musicplay/features/auth/view/widget/custom_button.dart';
import 'package:musicplay/features/auth/view/widget/custome_text_form_field.dart';
import 'package:musicplay/features/auth/viewmodel/auth_provide.dart';
import 'package:musicplay/features/auth/viewmodel/database_helper.dart';
import 'package:musicplay/features/home/pages/home_page.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  GlobalKey<State> key = GlobalKey<State>();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.background,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Sign Up",
                style: TextStyle(
                    color: AppColor.light,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      CustomeTextFormField(
                          hintText: "Username",
                          obscure: false,
                          type: TextInputType.name,
                          controller: name,
                          placeholder: "enter a name"),
                      SizedBox(
                        height: 15,
                      ),
                      CustomeTextFormField(
                          hintText: "email",
                          obscure: false,
                          type: TextInputType.emailAddress,
                          controller: email,
                          placeholder: "enter a email"),
                      SizedBox(
                        height: 15,
                      ),
                      CustomeTextFormField(
                          hintText: "password",
                          type: TextInputType.text,
                          obscure: true,
                          controller: password,
                          placeholder: "enter a password"),
                      SizedBox(
                        height: 15,
                      ),
                      Consumer(
                        builder: (BuildContext context, WidgetRef ref,
                            Widget? child) {
                          return InkWell(
                            onTap: () async {

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (c) => HomePage()));
                              final auth = ref.read(authControlProvider);

                              if (name.text.trim().isEmpty ||
                                  email.text.trim().isEmpty ||
                                  password.text.trim().isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Please enter all fields")),
                                );
                                return; // stop execution
                              }

                              bool success = await auth.signup(
                                name.text.trim(),
                                email.text.trim(),
                                password.text.trim(),
                              );
                              await DatabaseHelper().exportDbToProjectFolder();
                              print(
                                  "✅ DB copied into your project folder (db/auth_copy.db)");
                              if (success) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Signup success!")),
                                );
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (c) => HomePage()));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text("Signup failed (email exists)")),
                                );
                              }
                            },
                            child: CustomButton(text: "Signup"),
                          );
                        },
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final dbHelper = DatabaseHelper();
                          final path = await dbHelper.getDbPath();
                          print("📂 Database Path: $path");

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("DB Path: $path")),
                          );

                          final users = await dbHelper.getAllUsers();

                          // print in console
                          print("📌 Users in DB: $users");

                          // also show in snackbar
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Users: $users")),
                          );

                          Future<void> exportDb() async {
                            final dbPath = await getDatabasesPath();
                            final dbFile = File(join(dbPath, 'auth.db'));

                            final downloadsDir = await getDownloadsDirectory();
                            final newPath =
                                join(downloadsDir!.path, 'auth_copy.db');
                            await dbHelper.exportDbToProjectFolder();
                            print(
                                "✅ DB copied into your project folder (db/auth_copy.db)");
                            await dbFile.copy(newPath);
                            print("📂 Database copied to: $newPath");
                          }
                        },
                        child: const Text("Show Users"),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Already have an Account?",
                                style: TextStyle(color: AppColor.bg)),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (c) => SigninPage()));
                              },
                              child: Text("Sign In",
                                  style: TextStyle(fontSize: 17)),
                            ),
                          ]),
                    ],
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
