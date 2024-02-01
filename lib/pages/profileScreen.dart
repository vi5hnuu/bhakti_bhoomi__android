import 'package:bhakti_bhoomi/state/auth/auth_bloc.dart';
import 'package:bhakti_bhoomi/widgets/CameraIconButton.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final CancelToken userInfoCancelToken = CancelToken();

  @override
  void initState() {
    BlocProvider.of<AuthBloc>(context).add(FetchUserInfoEvent(cancelToken: userInfoCancelToken));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.orange),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          final userInfo = state.userInfo;
          return userInfo != null
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.bottomCenter,
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 4.5),
                            padding: EdgeInsets.all(5.5),
                            constraints: BoxConstraints(maxHeight: 170, minHeight: 170, minWidth: double.infinity),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                image: DecorationImage(
                                  image: NetworkImage(userInfo.posterMeta!.secure_url),
                                  fit: BoxFit.fitWidth,
                                  alignment: Alignment.topCenter,
                                  repeat: ImageRepeat.noRepeat,
                                )),
                            child: Align(
                              alignment: Alignment.topRight,
                              child: CameraIconButton(onPressed: () async {
                                // var posterImage = await imagePicker.pickImage(source: ImageSource.gallery);
                                // setState(() {
                                //   if (!mounted) return;
                                //   coverImage = posterImage;
                                // });
                              }),
                            ),
                          ),
                          Positioned(
                              top: 110,
                              child: Card(
                                shape: CircleBorder(side: BorderSide(color: Colors.black26)),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: CircleAvatar(
                                    radius: 45.6,
                                    backgroundImage: NetworkImage(userInfo.profileMeta!.secure_url),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: CameraIconButton(onPressed: () async {
                                        // var profileImage = await imagePicker.pickImage(source: ImageSource.gallery);
                                        // setState(() {
                                        //   if (!mounted) return;
                                        //   this.profileImage = profileImage;
                                        // });
                                      }),
                                    ),
                                  ),
                                ),
                              ))
                        ],
                      ),
                      Text(userInfo.firstName),
                      Text(userInfo.lastName),
                      Text(userInfo.username),
                      Text(userInfo.email),
                      Text(userInfo.role.map((e) => e.name).join(', ')),
                      Text(userInfo.createdAt.toString()),
                      Text(userInfo.updatedAt.toString()),
                      Text(userInfo.enabled.toString()),
                      Text(userInfo.locked.toString()),
                    ],
                  ),
                )
              : state.error != null
                  ? Text(state.error!)
                  : Center(child: const RefreshProgressIndicator());
        },
      ),
    );
  }
}
