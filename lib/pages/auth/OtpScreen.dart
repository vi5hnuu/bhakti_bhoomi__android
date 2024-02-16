import 'package:bhakti_bhoomi/routing/routes.dart';
import 'package:bhakti_bhoomi/state/auth/auth_bloc.dart';
import 'package:bhakti_bhoomi/widgets/CustomElevatedButton.dart';
import 'package:bhakti_bhoomi/widgets/CustomTextButton.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/CustomInputField.dart';

class OtpScreen extends StatefulWidget {
  final String usernameEmail;
  const OtpScreen({super.key, required this.usernameEmail});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final formKey = GlobalKey<FormState>(debugLabel: 'otpForm');
  final TextEditingController usernameEmailCntrl = TextEditingController(text: '');
  final TextEditingController passwordCntrl = TextEditingController(text: '');
  final TextEditingController confirmPasswordCntrl = TextEditingController(text: '');
  late List<FocusNode> _focusNodes;
  late List<TextEditingController> _Otpcontrollers;
  final CancelToken cancelToken = CancelToken();

  @override
  void initState() {
    super.initState();
    usernameEmailCntrl.text = widget.usernameEmail;

    _focusNodes = List.generate(6, (index) => FocusNode());
    _Otpcontrollers = List.generate(6, (index) => TextEditingController());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
        listener: (ctx, state) {
          if (state.success) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message ?? "password changed successfully")));
            GoRouter.of(context).goNamed(Routing.login);
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
                        CustomInputField(controller: usernameEmailCntrl, enabled: false, labelText: "Username/Email"),
                        const SizedBox(
                          height: 7,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(
                            6,
                            (index) => Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(right: (index == 5 ? 0 : 5.0)),
                                child: TextField(
                                  controller: _Otpcontrollers[index],
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  maxLength: 1,
                                  onChanged: (value) {
                                    if (value.isNotEmpty && index < 5) {
                                      _focusNodes[index + 1].requestFocus();
                                    } else if (value.isEmpty && index > 0) {
                                      _focusNodes[index - 1].requestFocus();
                                    }
                                  },
                                  focusNode: _focusNodes[index],
                                  decoration: InputDecoration(
                                    counterText: '',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 7,
                        ),
                        CustomInputField(
                            controller: passwordCntrl,
                            obscureText: true,
                            labelText: "new Password",
                            suffixIcon: Icon(Icons.password),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter valid new password';
                              }
                              return null;
                            }),
                        const SizedBox(
                          height: 18,
                        ),
                        CustomInputField(
                            controller: confirmPasswordCntrl,
                            obscureText: true,
                            labelText: "confirm password",
                            suffixIcon: Icon(Icons.password),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter valid confirm password';
                              }
                              return null;
                            }),
                        const SizedBox(
                          height: 18,
                        ),
                        CustomElevatedButton(
                          onPressed: state.isLoading
                              ? null
                              : () async {
                                  if (formKey.currentState?.validate() == false || _Otpcontrollers.where((otpCntrl) => otpCntrl.value.text.isEmpty).isNotEmpty) {
                                    return;
                                  }
                                  BlocProvider.of<AuthBloc>(context).add(ResetPasswordEvent(
                                      usernameEmail: widget.usernameEmail,
                                      otp: this._Otpcontrollers.map((otpCntrl) => otpCntrl.value.text).join(''),
                                      password: passwordCntrl.text,
                                      confirmPassword: confirmPasswordCntrl.text,
                                      cancelToken: cancelToken));
                                },
                          child: Text(
                            'Update',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                        if (state.error != null) Text(state.error!),
                        if (passwordCntrl.value.text != confirmPasswordCntrl.value.text) Text("new password should be equal to confirm password"),
                        const SizedBox(height: 12),
                        CustomTextButton(
                            onPressed: state.isLoading
                                ? null
                                : () {
                                    GoRouter.of(context).goNamed(Routing.login);
                                  },
                            child: Text('Sign-in instead'))
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
    this._focusNodes.forEach((node) => node.dispose());
    this._Otpcontrollers.forEach((cntrl) => cntrl.dispose());
    usernameEmailCntrl.dispose();
    passwordCntrl.dispose();
    confirmPasswordCntrl.dispose();

    super.dispose();
  }
}
