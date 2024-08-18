
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleApi {
  static final GoogleApi _instance=GoogleApi._();
  static const List<String> _scopes=[
    "https://www.googleapis.com/auth/userinfo.email",
    "https://www.googleapis.com/auth/userinfo.profile",
    "openid"
  ];
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    serverClientId: dotenv.env["GOOGLE_CLIENT_ID"],
    scopes: _scopes,
    signInOption: SignInOption.standard,
    forceCodeForRefreshToken: true,
  );

  GoogleApi._();

  factory GoogleApi(){
    return _instance;
  }

  Future<GoogleSignInAccount?> login() async{
    final res= await _googleSignIn.signIn();
    print("google-sign-in ${res}");
    return res;
  }

  Future<GoogleSignInAccount?> logout(){
    final res= _googleSignIn.signOut();
    print("google-sign-out ${res}");
    return res;
  }
}


// class _SignInDemoState extends State<LoginScreen> {
//   GoogleSignInAccount? _currentUser;
//   bool _isAuthorized = false; // has granted permissions?
//
//   @override
//   void initState() {
//     super.initState();
//
//     _googleSignIn.onCurrentUserChanged
//         .listen((GoogleSignInAccount? account) async {
//       print("current user changed ${_currentUser.toString()}");
// // #docregion CanAccessScopes
//       // In mobile, being authenticated means being authorized...
//       bool isAuthorized = account != null;
// // #enddocregion CanAccessScopes
//
//       setState(() {
//         _currentUser = account;
//         _isAuthorized = isAuthorized;
//       });
//
//       // Now that we know that the user can access the required scopes, the app
//       // can call the REST API.
//       // if (isAuthorized) {
//       //   unawaited(_handleGetContact(account));
//       // }
//     });
//
//     // In the web, _googleSignIn.signInSilently() triggers the One Tap UX.
//     //
//     // It is recommended by Google Identity Services to render both the One Tap UX
//     // and the Google Sign In button together to "reduce friction and improve
//     // sign-in rates" ([docs](https://developers.google.com/identity/gsi/web/guides/display-button#html)).
//     _googleSignIn.signInSilently();
//   }
//
//   // #docregion SignIn
//   Future<void> _handleSignIn() async {
//     try {
//       await _googleSignIn.signIn();
//     } catch (error) {
//       print("got an error ${error}");
//     }
//   }
//   // #enddocregion SignIn
//
//   // Prompts the user to authorize `scopes`.
//   //
//   // This action is **required** in platforms that don't perform Authentication
//   // and Authorization at the same time (like the web).
//   //
//   // On the web, this must be called from an user interaction (button click).
//   // #docregion RequestScopes
//   Future<void> _handleAuthorizeScopes() async {
//     final bool isAuthorized = await _googleSignIn.requestScopes(scopes);
//     // #enddocregion RequestScopes
//     setState(() {
//       _isAuthorized = isAuthorized;
//     });
//   }
//
//   Future<void> _handleSignOut() => _googleSignIn.disconnect();
//
//   Widget _buildBody() {
//     final GoogleSignInAccount? user = _currentUser;
//     if (user != null) {
//       // The user is Authenticated
//       return Column(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: <Widget>[
//           ListTile(
//             leading: GoogleUserCircleAvatar(
//               identity: user,
//             ),
//             title: Text(user.displayName ?? ''),
//             subtitle: Text(user.email),
//           ),
//           const Text('Signed in successfully.'),
//           if (!_isAuthorized) ...<Widget>[
//             // The user has NOT Authorized all required scopes.
//             // (Mobile users may never see this button!)
//             const Text('Additional permissions needed to read your contacts.'),
//             ElevatedButton(
//               onPressed: _handleAuthorizeScopes,
//               child: const Text('REQUEST PERMISSIONS'),
//             ),
//           ],
//           ElevatedButton(
//             onPressed: _handleSignOut,
//             child: const Text('SIGN OUT'),
//           ),
//         ],
//       );
//     } else {
//       // The user is NOT Authenticated
//       return Column(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: <Widget>[
//           const Text('You are not currently signed in.'),
//           // This method is used to separate mobile from web code with conditional exports.
//           // See: src/sign_in_button.dart
//           buildSignInButton(
//             onPressed: _handleSignIn,
//           ),
//         ],
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     print('ClientId');
//     print(dotenv.env["GOOGLE_CLIENT_ID"]);
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text('Google Sign In'),
//         ),
//         body: ConstrainedBox(
//           constraints: const BoxConstraints.expand(),
//           child: _buildBody(),
//         ));
//   }
// }

