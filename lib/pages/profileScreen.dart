import 'dart:io';

import 'package:bhakti_bhoomi/routing/routes.dart';
import 'package:bhakti_bhoomi/state/auth/auth_bloc.dart';
import 'package:bhakti_bhoomi/state/httpStates.dart';
import 'package:bhakti_bhoomi/widgets/CameraIconButton.dart';
import 'package:bhakti_bhoomi/widgets/CustomInputField.dart';
import 'package:bhakti_bhoomi/widgets/CustomTextButton.dart';
import 'package:bhakti_bhoomi/widgets/notificationSnackbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  CancelToken infoToken = CancelToken();
  CancelToken profileToken = CancelToken();
  CancelToken posterToken = CancelToken();
  CancelToken deleteMeToken = CancelToken();

  final formKey = GlobalKey<FormState>(debugLabel: 'registerForm');
  final ImagePicker imagePicker = ImagePicker();
  XFile? profileImage = null;
  XFile? coverImage = null;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listenWhen: (previous, current) => previous != current,
        listener: (context, state) {
          if(!state.isAuthtenticated) GoRouter.of(context).replaceNamed(Routing.login);
          if(state.anyError(forr: [Httpstates.LOG_OUT])){
            ScaffoldMessenger.of(context).showSnackBar(notificationSnackbar(text: "Feature will available in next update...", color: Colors.orange));
          }
        },
        buildWhen: (previous, current) => previous != current,
        builder: (context, state){
          final isAnyLoading=state.anyLoading(forr: [Httpstates.USER_INFO,Httpstates.LOG_OUT,Httpstates.DELETE_ME,Httpstates.UPDATE_PROFILE_PIC,Httpstates.UPDATE_POSTER_PIC]);
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Profile',
                style: TextStyle(color: Colors.white, fontFamily: "Kalam", fontSize: 32, fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
              elevation: 10,
              backgroundColor: Theme.of(context).primaryColor,
              iconTheme: const IconThemeData(color: Colors.white),
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
                            margin: const EdgeInsets.symmetric(horizontal: 4.5),
                            padding: const EdgeInsets.all(5.5),
                            constraints: const BoxConstraints(maxHeight: 150, minHeight: 150, minWidth: double.infinity),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                image: DecorationImage(
                                  image: (coverImage != null ? FileImage(File(coverImage!.path)) : NetworkImage(state.userInfo!.posterMeta!.secure_url)) as ImageProvider,
                                  fit: BoxFit.fitWidth,
                                  alignment: Alignment.topCenter,
                                  repeat: ImageRepeat.noRepeat,
                                )),
                            child: Align(
                              alignment: Alignment.topRight,
                              child: CameraIconButton(
                                  onPressed: state.isLoading(forr: Httpstates.USER_INFO)
                                      ? null
                                      : () async {
                                    var posterImage = await imagePicker.pickImage(source: ImageSource.gallery);
                                    setState(() {
                                      if (!mounted) return;
                                      coverImage = posterImage;
                                    });
                                  }),
                            ),
                          ),
                          Positioned(
                              top: 98.5,
                              child: Card(
                                shape: const CircleBorder(side: BorderSide(color: Colors.black26)),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: CircleAvatar(
                                    radius: 45.6,
                                    backgroundImage: profileImage != null ? FileImage(File(profileImage!.path)) : NetworkImage(state.userInfo!.profileMeta!.secure_url) as ImageProvider,
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: CameraIconButton(
                                          onPressed: state.isLoading(forr: Httpstates.USER_INFO)
                                              ? null
                                              : () async {
                                            var profileImage = await imagePicker.pickImage(source: ImageSource.gallery);
                                            setState(() {
                                              if (!mounted) return;
                                              this.profileImage = profileImage;
                                            });
                                          }),
                                    ),
                                  ),
                                ),
                              ))
                        ],
                      ),
                      const SizedBox(height: 64),
                      CustomInputField(labelText: "Active Since", initialValue: DateFormat("dd MMM yyyy").format(state.userInfo!.createdAt), enabled: false),
                      const SizedBox(height: 7),
                      CustomInputField(labelText: "First Name", initialValue: state.userInfo!.firstName, enabled: false),
                      const SizedBox(height: 7),
                      CustomInputField(labelText: "Last Name", initialValue: state.userInfo!.lastName, enabled: false),
                      const SizedBox(height: 7),
                      CustomInputField(labelText: "Username", initialValue: state.userInfo!.username, enabled: false),
                      const SizedBox(height: 7),
                      CustomInputField(labelText: "Email", initialValue: state.userInfo!.email, enabled: false),
                      const SizedBox(height: 7),
                      CustomTextButton(
                          onPressed:isAnyLoading || (profileImage == null && coverImage == null)
                              ? null
                              : () {
                            this.updateProfile();
                            this.updatePoster();
                          },
                          child: const Text('Update Images')),
                      const SizedBox(height: 12),
                      CustomTextButton(
                          onPressed: isAnyLoading
                              ? null
                              : () {
                            GoRouter.of(context).pushNamed(Routing.updatePassword);
                          },
                          child: const Text('Update Password')),
                      CustomTextButton(
                          onPressed: isAnyLoading
                              ? null
                              : () {
                            BlocProvider.of<AuthBloc>(context).add(LogoutEvent(cancelToken: deleteMeToken));
                          },
                          child: const Text('log out')),
                      const SizedBox(height: 64),
                      CustomTextButton(
                          onPressed: isAnyLoading
                              ? null
                              : () {
                            BlocProvider.of<AuthBloc>(context).add(DeleteMeEvent(cancelToken: deleteMeToken));
                          },
                          child: const Text('delete Account'))
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  updateProfile() async {
    if (this.profileImage == null) return;
    BlocProvider.of<AuthBloc>(context).add(UpdateProfilePic(profileImage: await MultipartFile.fromFile(this.profileImage!.path), cancelToken: profileToken));
  }

  updatePoster() async {
    if (this.coverImage == null) return;
    BlocProvider.of<AuthBloc>(context).add(UpdatePosterPicEvent(posterImage: await MultipartFile.fromFile(this.coverImage!.path), cancelToken: posterToken));
  }

  @override
  void dispose() {
    infoToken.cancel("cancelled");
    profileToken.cancel("cancelled");
    posterToken.cancel("cancelled");
    deleteMeToken.cancel("cancelled");
    super.dispose();
  }
}
