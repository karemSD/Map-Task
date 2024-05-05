// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:lastapp/utils/services/auth_service.dart';

// import 'home_view.dart';
// import 'login_or_rigster_view.dart';

// class AuthPage extends StatelessWidget {
//   const AuthPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: StreamBuilder<User?>(
//         stream: AuthService.instance.firebaseAuth.authStateChanges(),
//         builder: (context, snapshot) {
//           // user Logged in
//           if (snapshot.hasData) {
//             return HomeView();
//           } else {
//             return const LoginOrRigsterView();
//           }

//           // user not Logged in
//         },
//       ),
//     );
//   }
// }
