import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:musicplay/core/theme/app_color.dart';
import 'package:musicplay/features/auth/view/pages/signup_page.dart';
import 'package:musicplay/features/auth/view/widget/custom_button.dart';
import 'package:musicplay/features/auth/view/widget/custome_text_form_field.dart';
import 'package:musicplay/features/auth/viewmodel/auth_provide.dart';
import 'package:musicplay/features/home/pages/home_page.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final formKey = GlobalKey<FormState>();

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
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
                "Sign In",
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
                          type: TextInputType.emailAddress,
                          obscure: true,
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

                              bool success = await auth.login(
                                name.text.trim(),
                                email.text.trim(),
                                password.text.trim(),
                              );

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
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Don't have an Account?",
                                style: TextStyle(color: AppColor.bg)),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (c) => SignupPage()));
                              },
                              child: Text("Sign Up",
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
