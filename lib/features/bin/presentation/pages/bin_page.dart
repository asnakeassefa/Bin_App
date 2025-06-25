import 'package:bin_app/features/bin/presentation/widgets/bin_image.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../../../setting/presentation/pages/setting_page.dart';

class BinPage extends StatefulWidget {
  static const routeName = '/bin_page';
  const BinPage({super.key});

  @override
  State<BinPage> createState() => _BinPageState();
}

class _BinPageState extends State<BinPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text(
        //   'Bin Page',
        //   style: TextStyle(
        //     fontSize: 24,
        //     fontWeight: FontWeight.bold,
        //     color: Colors.white,
        //   ),
        // ),
        actions: [
          IconButton(
            icon: Icon(
              Ionicons.settings_outline,
              color: Theme.of(context).colorScheme.primary,
            ),
            onPressed: () {
              // Navigate to settings page
              Navigator.pushNamed(context, SettingPage.routeName);
            },
          ),
        ],
        // backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Column(
        children: [
          SizedBox(height: 24),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * .8,
            child: PageView(
              scrollDirection: Axis.horizontal,
              children: [
                // Bin
                BinImage(
                  binColor: "#808080",
                  lidColor: "#808080",
                  title: "Bin",
                ),
                // recycle bin
                BinImage(
                  binColor: "#1D63D8",
                  lidColor: "#1D63D8",
                  title: "Recycle Bin",
                ),
                // Garden bin
                BinImage(
                  binColor: "#7D3A2A",
                  lidColor: "#7D3A2A",
                  title: "Garden Bin",
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // add 
        ],
      ),
    );
  }
}




// Future<dynamic> changePasswordBottomSheet(BuildContext context) {
//     TextEditingController oldPasswordController = TextEditingController();

//     TextEditingController newPasswordController = TextEditingController();

//     TextEditingController confirmPasswordController = TextEditingController();
//     return showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       builder: (context) => BlocProvider(
//         create: (context) => getIt<AuthCubit>(),
//         child: Container(
//           padding: EdgeInsets.only(top: 10, left: 24, right: 24),
//           decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
//           height: MediaQuery.sizeOf(context).height * 0.6,
//           child: Padding(
//             padding: EdgeInsets.only(
//               bottom: MediaQuery.of(
//                 context,
//               ).viewInsets.bottom, // Adjust for keyboard
//             ),
//             child: BlocConsumer<AuthCubit, AuthState>(
//               listener: (context, state) {
//                 if (state is AuthSuccess) {
//                   Navigator.pop(context);
//                 }

//                 if (state is AuthFailure) {
//                   ScaffoldMessenger.of(
//                     context,
//                   ).showSnackBar(SnackBar(content: Text(state.message)));
//                   Navigator.pop(context);
//                 }
//               },
//               builder: (context, state) {
//                 return SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Container(
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(2),
//                           color: Theme.of(context).colorScheme.secondary,
//                         ),
//                         width: 50,
//                         height: 5,
//                       ),
//                       SizedBox(height: 24),
//                       Text(
//                         'Change Password',
//                         style: TextStyle(
//                           color: Theme.of(context).colorScheme.primary,
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       SizedBox(height: 24),
//                       CustomTextField(
//                         isObscure: false,
//                         headerText: "Old password",
//                         hintText: "*************",
//                         controller: oldPasswordController,
//                         validator: null,
//                       ),
//                       CustomTextField(
//                         isObscure: false,
//                         headerText: "New password",
//                         hintText: "*************",
//                         controller: newPasswordController,
//                         validator: null,
//                       ),
//                       CustomTextField(
//                         isObscure: false,
//                         headerText: "Confirm password",
//                         hintText: "*************",
//                         controller: confirmPasswordController,
//                         validator: null,
//                       ),
//                       SizedBox(height: 24),
//                       CustomButton(
//                         onPressed: () {
//                           context.read<AuthCubit>().changePassword(
//                             oldPasswordController.text,
//                             newPasswordController.text,
//                           );
//                         },
//                         text: "Save",
//                         isLoading: state is AuthLoading,
//                         height: 56,
//                         width: MediaQuery.sizeOf(context).width,
//                       ),
//                       SizedBox(height: 24),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//   }