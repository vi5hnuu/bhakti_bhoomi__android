import 'dart:io';

import 'package:bhakti_bhoomi/routing/routes.dart';
import 'package:bhakti_bhoomi/state/auth/auth_state_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>(debugLabel: 'registerForm');
  final ImagePicker imagePicker = ImagePicker();
  XFile? profileImage = null;
  XFile? coverImage = null;
  final TextEditingController firstNameCntrl = TextEditingController(text: '');
  final TextEditingController lastNameCntrl = TextEditingController(text: '');
  final TextEditingController usernameControllerCntrl = TextEditingController(text: '');
  final TextEditingController emailCntrl = TextEditingController(text: '');
  final TextEditingController passwordCntrl = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthStateBloc, AuthState>(
      listener: (ctx, state) {
        if (!state.isLogedIn) return;
        context.goNamed(Routing.home);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Registration'),
          centerTitle: true,
          elevation: 10,
          backgroundColor: Colors.orangeAccent,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18.5),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Stack(
                    alignment: Alignment.bottomCenter,
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 4.5),
                        padding: EdgeInsets.all(5.5),
                        constraints: BoxConstraints(maxHeight: 150, minHeight: 150, minWidth: double.infinity),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            image: coverImage?.path != null
                                ? DecorationImage(
                                    image: FileImage(File(coverImage!.path)),
                                    fit: BoxFit.fitWidth,
                                    alignment: Alignment.topCenter,
                                    repeat: ImageRepeat.noRepeat,
                                  )
                                : DecorationImage(
                                    image: AssetImage("assets/images/ram_poster_sm.jpg"),
                                    fit: BoxFit.fitWidth,
                                    alignment: Alignment.topCenter,
                                    repeat: ImageRepeat.noRepeat,
                                  )),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: CameraIconButton(onPressed: () async {
                            var posterImage = await imagePicker.pickImage(source: ImageSource.gallery);
                            setState(() {
                              coverImage = posterImage;
                            });
                          }),
                        ),
                      ),
                      Positioned(
                          top: 98.5,
                          child: Card(
                            shape: CircleBorder(side: BorderSide(color: Colors.black26)),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: CircleAvatar(
                                radius: 45.6,
                                backgroundImage: (profileImage?.path != null
                                    ? FileImage(File(profileImage!.path))
                                    : AssetImage("assets/images/ram_dp_sm.jpg")) as ImageProvider,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: CameraIconButton(onPressed: () async {
                                    var profileImage = await imagePicker.pickImage(source: ImageSource.gallery);
                                    setState(() {
                                      this.profileImage = profileImage;
                                    });
                                  }),
                                ),
                              ),
                            ),
                          ))
                    ],
                  ),
                  SizedBox(
                    height: 65,
                  ),
                  CustomInputField(
                      controller: firstNameCntrl,
                      hintText: "vishnu",
                      labelText: "First Name",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter first name';
                        }
                        return null;
                      }),
                  SizedBox(
                    height: 7,
                  ),
                  CustomInputField(
                      controller: lastNameCntrl,
                      hintText: "kumar",
                      labelText: "Last Name",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter last name';
                        }
                        return null;
                      }),
                  SizedBox(
                    height: 7,
                  ),
                  CustomInputField(
                      controller: usernameControllerCntrl,
                      hintText: "vi5hnu",
                      labelText: "Username",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter username';
                        }
                        return null;
                      }),
                  SizedBox(
                    height: 7,
                  ),
                  CustomInputField(
                      controller: emailCntrl,
                      hintText: "xyz@gmail.com",
                      labelText: "Email",
                      suffixIcon: Icon(Icons.email_outlined),
                      validator: (value) {
                        if (value == null || !value.contains("@gmail.com")) {
                          return 'Please enter valid email id';
                        }
                        return null;
                      }),
                  SizedBox(
                    height: 7,
                  ),
                  CustomInputField(
                      controller: passwordCntrl,
                      obscureText: true,
                      hintText: "as4c45a65s",
                      labelText: "password",
                      suffixIcon: Icon(Icons.password),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter valid password';
                        }
                        return null;
                      }),
                  SizedBox(
                    height: 18,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState?.validate() == false) {
                        return;
                      }
                    },
                    child: Text(
                      'Register',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orangeAccent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                        padding: EdgeInsets.all(12)),
                  ),
                  TextButton(
                      onPressed: () {
                        GoRouter.of(context).goNamed(Routing.login);
                      },
                      child: Text('Sign-in instead'))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomInputField extends StatelessWidget {
  const CustomInputField(
      {super.key,
      required this.controller,
      required this.labelText,
      required this.hintText,
      this.autoCorrect = true,
      this.autofocus = false,
      this.keyboardType = TextInputType.text,
      this.validator,
      this.obscureText = false,
      this.obscureCharacter = '*',
      this.suffixIcon});

  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final bool autoCorrect;
  final bool autofocus;
  final TextInputType keyboardType;
  final FormFieldValidator<String>? validator;
  final bool obscureText;
  final String obscureCharacter;
  final Icon? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.deepOrange),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.orangeAccent),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.redAccent),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
          suffixIconColor: Colors.orangeAccent,
          suffixIcon: suffixIcon,
          alignLabelWithHint: true,
          hintText: hintText,
          labelText: labelText,
          contentPadding: EdgeInsets.all(18)),
      controller: controller,
      autocorrect: autoCorrect,
      autofocus: autofocus,
      keyboardType: keyboardType,
      maxLines: 1,
      validator: validator,
      obscureText: obscureText,
      obscuringCharacter: obscureCharacter,
    );
  }
}

class CameraIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  CameraIconButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      color: Colors.red,
      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.black.withOpacity(0.3))),
      icon: Icon(
        Icons.camera_alt_outlined,
        size: 25,
        color: Colors.white,
      ),
      highlightColor: Colors.white.withOpacity(0.3),
      onPressed: onPressed,
    );
  }
}
