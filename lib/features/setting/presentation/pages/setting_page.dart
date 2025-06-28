import 'dart:developer';

import 'package:bin_app/features/setting/presentation/bloc/setting_cubit.dart';
import 'package:bin_app/features/setting/presentation/bloc/setting_state.dart';
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
    // clear all and add only onboarding true
    await FlutterSecureStorage().deleteAll();
    // You can also clear other data if needed
    log('User data cleared');
    // now onboarding to local storage
    await FlutterSecureStorage().write(
      key: 'onboarding',
      value: 'true',
    ); // Example for setting onboarding status
  }

  // init the name from local then update it with the profile data
  bool isOpenToWork = true;
  String profilePicture = 'https://cdn.pixabay.com/photo';
  String name = '';
  @override
  void initState() {
    super.initState();
    // Fetch the initial profile data
    final storage = FlutterSecureStorage();
    storage.read(key: 'fullName').then((value) {
      if (value != null) {
        setState(() {
          name = value;
        });
      }
    });
  }

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
      body: BlocProvider(
        create: (context) => getIt<SettingCubit>()..getProfile(),
        child: BlocListener<SettingCubit, SettingState>(
          listener: (context, state) {
            if (state is ProfileLoaded) {
              // add the name to local and update the name

              if (state.profile.data?.fullName != null) {
                setState(() {
                  name = state.profile.data?.fullName ?? '';
                });
                // Save the name to local storage
                FlutterSecureStorage().write(
                  key: 'fullName',
                  value: state.profile.data?.fullName ?? '',
                );
              }
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16),
                  // add uk flag here
                  Center(child: Text("🇬🇧", style: TextStyle(fontSize: 50))),
                  // Name
                  Center(
                    child: Text(
                      name,
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
                            // changePasswordBottomSheet(context);s
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
        ),
      ),
    );
  }

  Future<dynamic> changePasswordBottomSheet(BuildContext context) {
    TextEditingController oldPasswordController = TextEditingController();

    TextEditingController newPasswordController = TextEditingController();

    TextEditingController confirmPasswordController = TextEditingController();
    // form key
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => BlocProvider(
        create: (context) => getIt<SettingCubit>(),
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
            child: BlocConsumer<SettingCubit, SettingState>(
              listener: (context, state) {
                if (state is SettingError) {
                  Navigator.pop(context,false);
                }
              },
              builder: (context, state) {
                if(state is PasswordChanged){
                  // return success message
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Ionicons.checkmark_circle,
                          color: Colors.green,
                          size: 80,
                        ),
                        SizedBox(height: 24),
                        Text(
                          'Password changed successfully!',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 24),
                        CustomButton(
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                          isLoading: false,
                          text: "Close",
                          height: 48,
                          width: MediaQuery.sizeOf(context).width * 0.6,
                        ),
                      ],
                    ),
                  );
                }
                return SingleChildScrollView(
                  child: Form(
                    key: formKey,
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
                          isObscure: true,
                          headerText: "Old password",
                          hintText: "*************",
                          
                          controller: oldPasswordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your old password';
                            }
                            return null;
                          },
                        ),
                        CustomTextField(
                          isObscure: true,
                          headerText: "New password",
                          hintText: "*************",
                          controller: newPasswordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a new password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        CustomTextField(
                          isObscure: true,
                          headerText: "Confirm password",
                          hintText: "*************",
                          controller: confirmPasswordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your password';
                            }
                            if (value != newPasswordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 24),
                        CustomButton(
                          onPressed: () {
                            context.read<SettingCubit>().changePassword(
                              oldPasswordController.text,
                              newPasswordController.text,
                            );
                          },
                          text: "Save",
                          isLoading: state is PasswordChangeLoading,
                          height: 56,
                          width: MediaQuery.sizeOf(context).width,
                        ),
                        SizedBox(height: 24),
                      ],
                    ),
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
