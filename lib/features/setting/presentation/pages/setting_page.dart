import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ionicons/ionicons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
// import 'package:eskalate_mobile/core/utility/router.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/pages/login_screen.dart';
import '../bloc/profile_cubit/profile_cubit.dart';
import '../bloc/profile_cubit/profile_state.dart';
import '../widgets/account_widget.dart';
import '../widgets/option.dart'; // Import your login screen

class SettingPage extends StatefulWidget {
  static const String routeName = '/setting';
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  Future<void> _logout(BuildContext context) async {
    // Clear user session data
    final navigator = Navigator.of(context);
    await _clearUserData();

    // Navigate to the login screen and remove all previous routes
    navigator.pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }

  Future<void> _clearUserData() async {
    // Clear any user data you may have stored (e.g., tokens, user info)
    await FlutterSecureStorage().delete(
      key: 'accessToken',
    ); // Example for using secure storage, adjust as needed
  }

  bool isOpenToWork = true;
  String profilePicture = 'https://cdn.pixabay.com/photo';
  String name = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Setting',
          style: TextStyle(color: Theme.of(context).colorScheme.secondary),
        ),
        automaticallyImplyLeading: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              // Name
              Center(
                child: Text(
                  "USER NAME",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Account',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 16, right: 8),
                child: Column(
                  children: [
                    SettingContent(
                      text: "Update Profile",
                      onPressed: () {
                        log('Update Profile pressed');
                        changePasswordBottomSheet(context);
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 16, right: 8),
                child: Column(
                  children: [
                    SettingContent(
                      text: "Change Password",
                      onPressed: () {
                        log('Change Password pressed');
                        changePasswordBottomSheet(context);
                      },
                    ),
                  ],
                ),
              ),

              Text(
                'Legal & Privacy',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 16),

              Padding(
                padding: EdgeInsets.only(left: 16, right: 8),
                child: Column(
                  children: [
                    SettingLegalContent(
                      text: "Privacy Policy",
                      iconPath: Ionicons.shield_checkmark_outline,
                    ),
                    SettingLegalContent(
                      text: "Terms of Service",
                      iconPath: Ionicons.book_outline,
                    ),
                    SettingLegalContent(
                      text: "App Version",
                      iconPath: Ionicons.code_outline,
                      version: "1.0.0",
                    ),
                  ],
                ),
              ),
              // SizedBox(height: 16),
              // Text(
              //   'Help & Support',
              //   style: TextStyle(
              //     color: Theme.of(context).colorScheme.primary,
              //     fontSize: 16,
              //     fontWeight: FontWeight.w600,
              //   ),
              // ),
              // SizedBox(height: 16),
              // Padding(
              //   padding: EdgeInsets.only(left: 16, right: 8),
              //   child: Column(
              //     children: [
              //       SettingLegalContent(
              //         text: "FAQ",
              //         iconPath: Ionicons.help_circle_outline,
              //       ),
              //       SettingLegalContent(
              //         text: "Contact & Support",
              //         iconPath: Ionicons.mail_outline,
              //       ),
              //       SettingLegalContent(
              //         text: "Report Problem",
              //         iconPath: Ionicons.warning_outline,
              //       ),
              //     ],
              //   ),
              // ),
              SizedBox(height: 16),
              CustomButton(
                onPressed: () {
                  _logout(context);
                },
                text: " Logout",
                isLoading: false,
                height: 56,
                width: MediaQuery.of(context).size.width,
                color: Colors.red,
                imageName: 'assets/icons/logout.svg',
              ),

              SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> changePasswordBottomSheet(BuildContext context) {
    TextEditingController oldPasswordController = TextEditingController();

    TextEditingController newPasswordController = TextEditingController();

    TextEditingController confirmPasswordController = TextEditingController();
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => BlocProvider(
        create: (context) => getIt<AuthCubit>(),
        child: Container(
          padding: EdgeInsets.only(top: 10, left: 24, right: 24),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
          height: MediaQuery.sizeOf(context).height * 0.6,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(
                context,
              ).viewInsets.bottom, // Adjust for keyboard
            ),
            child: BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is AuthSuccess) {
                  Navigator.pop(context);
                }

                if (state is AuthFailure) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message)));
                  Navigator.pop(context);
                }
              },
              builder: (context, state) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        width: 50,
                        height: 5,
                      ),
                      SizedBox(height: 24),
                      Text(
                        'Change Password',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 24),
                      CustomTextField(
                        isObscure: false,
                        headerText: "Old password",
                        hintText: "*************",
                        controller: oldPasswordController,
                        validator: null,
                      ),
                      CustomTextField(
                        isObscure: false,
                        headerText: "New password",
                        hintText: "*************",
                        controller: newPasswordController,
                        validator: null,
                      ),
                      CustomTextField(
                        isObscure: false,
                        headerText: "Confirm password",
                        hintText: "*************",
                        controller: confirmPasswordController,
                        validator: null,
                      ),
                      SizedBox(height: 24),
                      CustomButton(
                        onPressed: () {
                          context.read<AuthCubit>().changePassword(
                            oldPasswordController.text,
                            newPasswordController.text,
                          );
                        },
                        text: "Save",
                        isLoading: state is AuthLoading,
                        height: 56,
                        width: MediaQuery.sizeOf(context).width,
                      ),
                      SizedBox(height: 24),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class SettingLegalContent extends StatelessWidget {
  final IconData iconPath;
  final String text;
  final String? version;
  SettingLegalContent({
    super.key,
    required this.iconPath,
    required this.text,
    this.version,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              iconPath,
              color: Theme.of(context).colorScheme.primary,
              size: 24,
            ),
            SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
              ),
            ),
          ],
        ),
        version != null
            ? SizedBox(
                height: 44,
                child: Center(
                  child: Text(
                    "V $version",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
              )
            : IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Scaffold(
                        body: Center(
                          child: Text(
                            'This feature is not implemented yet.',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                icon: SvgPicture.asset(
                  'assets/icons/arrow_right.svg',
                  color: Theme.of(context).colorScheme.primary,
                  height: 24,
                  width: 24,
                ),
              ),
      ],
    );
  }
}
