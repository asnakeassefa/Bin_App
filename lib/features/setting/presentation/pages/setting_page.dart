import 'dart:developer';

import 'package:bin_app/features/setting/presentation/bloc/setting_cubit.dart';
import 'package:bin_app/features/setting/presentation/bloc/setting_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ionicons/ionicons.dart';
// import 'package:eskalate_mobile/core/utility/router.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../auth/presentation/pages/login_screen.dart';
import '../widgets/account_widget.dart';
import '../widgets/change_password.dart';
import '../widgets/update_profile.dart';

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
  String country = '';
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
              log('Profile loaded: ${state.profile.data?.fullName}');
              if (state.profile.data?.fullName != null) {
                setState(() {
                  name = state.profile.data?.fullName ?? '';
                  country = state.profile.data?.country ?? '';
                });
                // Save the name to local storage
                FlutterSecureStorage().write(
                  key: 'fullName',
                  value: state.profile.data?.fullName ?? '',
                );
                FlutterSecureStorage().write(
                  key: 'country',
                  value: state.profile.data?.country ?? '',
                );
              }
            }
          },
          child: Builder(
            builder: (innerContext) {
              return Padding(
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
                                updateProfileBottomSheet(
                                  context,
                                  name,
                                  country,
                                ).then((value) {
                                  log(
                                    'Update Profile Bottom Sheet closed with value: $value',
                                  );
                                  // Fetch the updated profile data
                                  innerContext.read<SettingCubit>().getProfile();
                                });
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
              );
            }
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
