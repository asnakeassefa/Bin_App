import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../bloc/setting_cubit.dart';
import '../bloc/setting_state.dart';

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
      child: Padding(
        padding: EdgeInsets.only(
          top: 10,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: EdgeInsets.only(top: 10, left: 24, right: 24),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
          height: MediaQuery.sizeOf(context).height * 0.6,
          child: BlocConsumer<SettingCubit, SettingState>(
            listener: (context, state) {
              if (state is SettingError) {
                Navigator.pop(context, false);
              }
            },
            builder: (context, state) {
              if (state is PasswordChanged) {
                // return success message
                return Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 40,
                    horizontal: 16,
                  ),
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
                        hintText: "Please enter your old password",

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
                        hintText: "Please enter your new password",
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
                        hintText: "Please confirm your password",
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
