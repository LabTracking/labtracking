// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:labtracking/components/new_researcher_form.dart';
// import 'package:labtracking/models/new_researcher_form_data.dart';
// import 'package:labtracking/utils/routes.dart';

// import '../services/auth_service.dart';

// class NewResearcherScreen extends StatefulWidget {
//   final User user;

//   NewResearcherScreen({required this.user, super.key});

//   @override
//   State<NewResearcherScreen> createState() => _NewResearcherScreenState();
// }

// class _NewResearcherScreenState extends State<NewResearcherScreen> {
//   bool isLoading = false;

//   Future<void> handleSubmit(NewResearcherFormData newResearcherFormData) async {
//     try {
//       if (!mounted) return;
//       setState(() => isLoading = true);

//       await AuthService.signup(
//         widget.user,
//         newResearcherFormData.institution,
//         newResearcherFormData.address,
//         newResearcherFormData.country,
//       );

//       await Navigator.of(context).popAndPushNamed(AppRoutes.SAMPLES);
//     } catch (error) {
//     } finally {
//       if (!mounted) return;
//       setState(() => isLoading = false);
//     }

//     print(newResearcherFormData.email);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: Column(
//           children: [
//             Image.asset(
//               'assets/images/white_icon.png',
//               fit: BoxFit.cover,
//               height: 30,
//             ),
//             const Text(
//               "LabTracking",
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 14,
//               ),
//             ),
//           ],
//         ),
//         backgroundColor: const Color.fromARGB(255, 126, 217, 87),
//       ),
//       body: SingleChildScrollView(
//         child: Container(
//           padding:
//               EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
//           child: Center(
//             child: Column(
//               children: [
//                 Image.asset(
//                   'assets/images/logo.png',
//                   width: double.infinity,
//                   height: 300,
//                 ),
//                 NewResearcherForm(onSubmit: handleSubmit),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
