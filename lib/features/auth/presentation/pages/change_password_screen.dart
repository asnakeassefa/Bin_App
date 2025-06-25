import 'dart:math';

import 'package:bin_app/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../bloc/auth_bloc.dart';

class ChangePasswordScreen extends StatefulWidget {
  static const String routeName = '/change-password';
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  TextEditingController currentPasswordCont = TextEditingController();
  TextEditingController newPasswordCont = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isObscure = true;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AuthCubit>(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.green,
                content: Text('Password changed successfully'),
              ),
            );
            Navigator.pop(context);
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.red,
                content: Text('Failed to change password'),
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.sizeOf(context).height,
                child: Stack(
                  children: [
                    SizedBox(
                      child: Container(
                        height: MediaQuery.sizeOf(context).height * 0.60,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                              'assets/images/background_vector.png',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Align(
                          alignment: const Alignment(0, -0.40),
                          child: SizedBox(
                            height: 200,
                            width: 200,
                            child: Image.asset('assets/images/logo.png'),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.sizeOf(context).height * 0.30,
                      child: SizedBox(
                        height: MediaQuery.sizeOf(context).height * 0.68,
                        width: MediaQuery.sizeOf(context).width,
                        child: SizedBox(
                          height: MediaQuery.sizeOf(context).height * 0.65,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 60),
                                  Center(
                                    child: Text(
                                      'Change Password',
                                      style: TextStyle(
                                        fontSize: 32,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Current Password
                                        CustomTextField(
                                          isObscure: isObscure,
                                          headerText: 'Old Password',
                                          hintText: 'Enter your password',
                                          controller: currentPasswordCont,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Password cannot be empty';
                                            } else if (value.length < 6) {
                                              return 'Password must be at least 6 characters';
                                            }
                                            return null;
                                          },
                                        ),
                                        CustomTextField(
                                          isObscure: isObscure,
                                          headerText: 'New password',
                                          hintText: 'Enter your password',
                                          controller: newPasswordCont,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Password cannot be empty';
                                            } else if (value.length < 6) {
                                              return 'Password must be at least 6 characters';
                                            }
                                            return null;
                                          },
                                        ),
                                        // Change Password Button
                                        CustomButton(
                                          onPressed: () {},
                                          text: 'Change Password',
                                          isLoading: state is AuthLoading,
                                          height: 54,
                                          width: double.infinity,
                                        ),
                                        const SizedBox(height: 16),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            'Back to Settings',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.tertiary,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
