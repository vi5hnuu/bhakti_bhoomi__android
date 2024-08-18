import 'dart:io';
import 'dart:ui';

import 'package:bhakti_bhoomi/routing/routes.dart';
import 'package:bhakti_bhoomi/state/auth/auth_bloc.dart';
import 'package:bhakti_bhoomi/state/httpStates.dart';
import 'package:bhakti_bhoomi/widgets/CameraIconButton.dart';
import 'package:bhakti_bhoomi/widgets/CustomInputField.dart';
import 'package:bhakti_bhoomi/widgets/CustomTextButton.dart';
import 'package:bhakti_bhoomi/widgets/notificationSnackbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  CancelToken profileMetaToken = CancelToken();
  CancelToken deleteMeToken = CancelToken();

  final formKey = GlobalKey<FormState>(debugLabel: 'registerForm');
  final ImagePicker imagePicker = ImagePicker();
  XFile? profileImage = null;
  XFile? coverImage = null;
  DateTime? _lastBackPressedAt;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final router=GoRouter.of(context);

    return BlocConsumer<AuthBloc, AuthState>(
        listenWhen: (previous, current) => previous != current,
        listener: (context, state) {
          if (!state.isAuthtenticated)
            GoRouter.of(context).goNamed(Routing.login.name);
          if (state.anyError(forr: [
            Httpstates.LOG_OUT,
            Httpstates.UPDATE_PROFILE_META,
            Httpstates.DELETE_ME
          ])) {
            ScaffoldMessenger.of(context).showSnackBar(notificationSnackbar(
                text: state.getAnyError(forr: [
                  Httpstates.LOG_OUT,
                  Httpstates.UPDATE_PROFILE_META,
                  Httpstates.DELETE_ME
                ])!.message,
                color: Colors.red));
          }
        },
        buildWhen: (previous, current) =>
            previous != current && current.userInfo != null,
        builder: (context, state) {
          final isAnyLoading = state.anyLoading(forr: [
            Httpstates.USER_INFO,
            Httpstates.LOG_OUT,
            Httpstates.DELETE_ME,
            Httpstates.UPDATE_PROFILE_META
          ]);
          return PopScope(
            canPop: !isAnyLoading || (_lastBackPressedAt != null && DateTime.now().difference(_lastBackPressedAt!) <= const Duration(seconds: 2)),
            onPopInvoked: (shouldInvoke) {
              if (shouldInvoke) {
                return router.pop();
              }
              if(mounted) {
                setState(() =>_lastBackPressedAt = DateTime.now());
              }
              ScaffoldMessenger.of(context).showSnackBar(notificationSnackbar(
                  text: "Press back again to exit | Do not quit"));
            },
            child: Scaffold(
              appBar: AppBar(
                title: const Text(
                  'Profile',
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Kalam",
                      fontSize: 32,
                      fontWeight: FontWeight.bold),
                ),
                centerTitle: true,
                elevation: 10,
                backgroundColor: theme.primaryColor,
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
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4.5),
                          padding: const EdgeInsets.all(5.5),
                          constraints: BoxConstraints(
                              maxHeight: mediaQuery.size.height * 0.3,
                              minWidth: double.infinity),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: theme.primaryColor),
                              image: DecorationImage(
                                image: (coverImage != null
                                    ? FileImage(File(coverImage!.path))
                                    : NetworkImage(state.userInfo!.posterMeta!
                                        .secure_url)) as ImageProvider,
                                fit: BoxFit.fitWidth,
                                alignment: Alignment.topCenter,
                                repeat: ImageRepeat.noRepeat,
                              )),
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            clipBehavior: Clip.none,
                            children: [
                              Align(
                                alignment: Alignment.topRight,
                                child: CameraIconButton(
                                    onPressed: state.isLoading(
                                            forr: Httpstates.USER_INFO)
                                        ? null
                                        : () async {
                                            var posterImage =
                                                await imagePicker.pickImage(
                                                    source:
                                                        ImageSource.gallery);
                                            setState(() {
                                              if (!mounted) return;
                                              coverImage = posterImage;
                                            });
                                          }),
                              ),
                              Positioned(
                                  bottom: -45.6,
                                  child: Card(
                                    shape: CircleBorder(
                                        side: BorderSide(
                                            color: theme.primaryColor)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: CircleAvatar(
                                        radius: 45.6,
                                        backgroundImage: profileImage != null
                                            ? FileImage(
                                                File(profileImage!.path))
                                            : NetworkImage(state
                                                .userInfo!
                                                .profileMeta!
                                                .secure_url) as ImageProvider,
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: CameraIconButton(
                                              onPressed: state.isLoading(
                                                      forr:
                                                          Httpstates.USER_INFO)
                                                  ? null
                                                  : () async {
                                                      var profileImage =
                                                          await imagePicker
                                                              .pickImage(
                                                                  source: ImageSource
                                                                      .gallery);
                                                      setState(() {
                                                        if (!mounted) return;
                                                        this.profileImage =
                                                            profileImage;
                                                      });
                                                    }),
                                        ),
                                      ),
                                    ),
                                  ))
                            ],
                          ),
                        ),
                        const SizedBox(height: 64),
                        CustomInputField(
                            labelText: "Active Since",
                            initialValue: DateFormat("dd MMM yyyy")
                                .format(state.userInfo!.createdAt),
                            enabled: false),
                        const SizedBox(height: 7),
                        CustomInputField(
                            labelText: "First Name",
                            initialValue: state.userInfo!.firstName,
                            enabled: false),
                        const SizedBox(height: 7),
                        CustomInputField(
                            labelText: "Last Name",
                            initialValue: state.userInfo!.lastName,
                            enabled: false),
                        const SizedBox(height: 7),
                        CustomInputField(
                            labelText: "Username",
                            initialValue: state.userInfo!.username,
                            enabled: false),
                        const SizedBox(height: 7),
                        CustomInputField(
                            labelText: "Email",
                            initialValue: state.userInfo!.email,
                            enabled: false),
                        const SizedBox(height: 7),
                        CustomTextButton(
                            isLoading: state.isLoading(
                                forr: Httpstates.UPDATE_PROFILE_META),
                            onPressed: isAnyLoading ||
                                    (profileImage == null && coverImage == null)
                                ? null
                                : saveChanges,
                            child: const Text('Save Changes')),
                        const SizedBox(height: 12),
                        CustomTextButton(
                            isLoading: state.isLoading(
                                forr: Httpstates.UPDATE_PASSWORD),
                            onPressed: isAnyLoading
                                ? null
                                : () {
                                    GoRouter.of(context)
                                        .pushNamed(Routing.updatePassword.name);
                                  },
                            child: const Text('Update Password')),
                        CustomTextButton(
                            isLoading:
                                state.isLoading(forr: Httpstates.LOG_OUT),
                            onPressed: isAnyLoading
                                ? null
                                : () {
                                    BlocProvider.of<AuthBloc>(context).add(
                                        LogoutEvent(
                                            cancelToken: deleteMeToken));
                                  },
                            child: const Text('log out')),
                        const SizedBox(height: 64),
                        CustomTextButton(
                            isLoading:
                                state.isLoading(forr: Httpstates.DELETE_ME),
                            onPressed: isAnyLoading ? null : deleteAccountInit,
                            child: const Text('delete Account'))
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  saveChanges() async {
    if (this.profileImage == null && this.coverImage == null) throw Error();
    BlocProvider.of<AuthBloc>(context).add(UpdateProfileMeta(
        profileImage: profileImage != null
            ? await MultipartFile.fromFile(profileImage!.path)
            : null,
        posterImage: coverImage != null
            ? await MultipartFile.fromFile(coverImage!.path)
            : null,
        cancelToken: profileMetaToken));
  }

  deleteAccountInit() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(Icons.warning, color: Colors.red, size: 48),
              const Text('The action is irreversible',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 24,
                      height: 2,
                      color: Colors.red,
                      fontWeight: FontWeight.bold)),
              const Text('Are you sure you want to delete your account ?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.red,
                      fontWeight: FontWeight.w900)),
              const SizedBox(height: 15),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.grey)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Close',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  FilledButton(
                    style: FilledButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () {
                      BlocProvider.of<AuthBloc>(context)
                          .add(DeleteMeEvent(cancelToken: deleteMeToken));
                      Navigator.pop(context);
                    },
                    child: const Text('Delete'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    infoToken.cancel("cancelled");
    profileMetaToken.cancel("cancelled");
    deleteMeToken.cancel("cancelled");
    super.dispose();
  }
}
