import 'package:bhakti_bhoomi/singletons/NotificationService.dart';
import 'package:bhakti_bhoomi/state/auth/auth_bloc.dart';
import 'package:bhakti_bhoomi/state/httpStates.dart';
import 'package:bhakti_bhoomi/widgets/CustomElevatedButton.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/CustomInputField.dart';

class UpdatePasswordScreen extends StatefulWidget {
  const UpdatePasswordScreen({super.key});

  @override
  State<UpdatePasswordScreen> createState() => _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  final formKey = GlobalKey<FormState>(debugLabel: 'updatePassword');

  final TextEditingController oldPasswordCntrl = TextEditingController();
  final TextEditingController newPasswordCntrl = TextEditingController();
  final TextEditingController confirmPasswordCntrl = TextEditingController();
  final CancelToken cancelToken = CancelToken();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
        listenWhen: (previous, current) => previous != current,
        listener: (ctx, state) {
          if (state.isError(forr: Httpstates.UPDATE_PASSWORD)) {
            NotificationService.showSnackbar(text: state.getError(forr: Httpstates.UPDATE_PASSWORD)!.message, color: Colors.red);
          }
          if (state.success) {
            NotificationService.showSnackbar(text: state.message ?? "Password updated successfully", color: Colors.green);
            GoRouter.of(context).pop();
          }
        },
        builder: (context, state) => Scaffold(
              appBar: AppBar(
                title: const Text(
                  'Update Password',
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
                        CustomInputField(
                            controller: oldPasswordCntrl,
                            labelText: "Old Password",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter old Password';
                              }
                              return null;
                            }),
                        const SizedBox(
                          height: 7,
                        ),
                        CustomInputField(
                            controller: newPasswordCntrl,
                            labelText: "New Password",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter New Password';
                              }
                              return null;
                            }),
                        const SizedBox(
                          height: 7,
                        ),
                        CustomInputField(
                            controller: confirmPasswordCntrl,
                            labelText: "Confirm Password",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter Confirm Password';
                              }
                              return null;
                            }),
                        const SizedBox(
                          height: 7,
                        ),
                        CustomElevatedButton(
                          onPressed: state.isLoading(forr: Httpstates.UPDATE_PASSWORD)
                              ? null
                              : () async {
                                  if (formKey.currentState?.validate() == false) {
                                    return;
                                  }

                                  BlocProvider.of<AuthBloc>(context).add(UpdatePasswordEvent(
                                      oldPassword: oldPasswordCntrl.value.text, newPassword: newPasswordCntrl.value.text, confirmPassword: confirmPasswordCntrl.value.text, cancelToken: cancelToken));
                                },
                          child: const Text(
                            'Update Password',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ));
  }

  @override
  void dispose() {
    cancelToken.cancel("register cancelled");
    super.dispose();
  }
}
