import 'package:bhakti_bhoomi/routing/routes.dart';
import 'package:bhakti_bhoomi/state/auth/auth_bloc.dart';
import 'package:bhakti_bhoomi/widgets/CustomElevatedButton.dart';
import 'package:bhakti_bhoomi/widgets/CustomInputField.dart';
import 'package:bhakti_bhoomi/widgets/CustomTextButton.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/notificationSnackbar.dart';

class VerifyScreen extends StatefulWidget {
  VerifyScreen({super.key});

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final CancelToken cancelToken = CancelToken();
  final formKey = GlobalKey<FormState>(debugLabel: 'loginForm');
  final TextEditingController emailCntrl = TextEditingController(text: 'kum0rvishnu@gmail.com');

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listenWhen: (previous, current) => previous != current,
      listener: (ctx, state) {
        if (state.success) {
          ScaffoldMessenger.of(context).showSnackBar(notificationSnackbar(text: state.message ?? "verified successfully", color: Colors.green));
          context.goNamed(Routing.login);
        }
        if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(notificationSnackbar(text: state.message ?? "verification failed", color: Colors.red));
        }
      },
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          title: Text(
            'verify',
            style: TextStyle(color: Colors.white, fontFamily: "Kalam", fontSize: 32, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 10,
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Center(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomInputField(
                    controller: emailCntrl,
                    labelText: 'Email',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter email";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 18),
                  CustomElevatedButton(
                      onPressed: state.isLoading ? null : () => BlocProvider.of<AuthBloc>(context).add(ReVerifyEvent(email: this.emailCntrl.value.text, cancelToken: cancelToken)),
                      child: const Text(
                        "send verification email",
                        style: TextStyle(color: Colors.white),
                      )),
                  const SizedBox(height: 12),
                  CustomTextButton(onPressed: state.isLoading ? null : () => context.goNamed(Routing.login), child: const Text('login instead')),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    cancelToken.cancel("login cancelled");
    super.dispose();
  }
}
