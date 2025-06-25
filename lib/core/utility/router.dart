import 'package:bin_app/features/auth/presentation/pages/forget_password_screen.dart';
import 'package:bin_app/features/setting/presentation/pages/setting_page.dart';
import 'package:flutter/material.dart';

import '../../features/auth/presentation/pages/change_password_screen.dart';
import '../../features/auth/presentation/pages/login_screen.dart';
import '../../features/auth/presentation/pages/sign_up_screen.dart';
import '../../features/bin/presentation/pages/bin_page.dart';

final Map<String, WidgetBuilder> routes = {
  // Authentication routes
  SignUpScreen.routeName: (context) => SignUpScreen(),
  LoginScreen.routeName: (context) => LoginScreen(),
  ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
  ChangePasswordScreen.routeName: (context) => ChangePasswordScreen(),
  // Bin page route
  BinPage.routeName: (context) => const BinPage(),
  SettingPage.routeName: (context) => const SettingPage(),
};
