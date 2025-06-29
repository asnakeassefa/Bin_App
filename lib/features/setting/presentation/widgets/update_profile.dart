import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../bloc/setting_cubit.dart';
import '../bloc/setting_state.dart';

Future<dynamic> updateProfileBottomSheet(
  BuildContext context,
  String initialName,
  String initialCountry,
) {
  TextEditingController name = TextEditingController(text: initialName);
  String country = initialCountry;
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
          bottom: MediaQuery.of(
            context,
          ).viewInsets.bottom, // Adjust for keyboard
        ),
        child: Container(
          padding: EdgeInsets.only(top: 10, left: 24, right: 24),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
          height: MediaQuery.sizeOf(context).height * 0.5,
          child: BlocConsumer<SettingCubit, SettingState>(
            listener: (context, state) {
              if (state is SettingError) {
                Navigator.pop(context, false);
              }
            },
            builder: (context, state) {
              if (state is ProfileUpdated) {
                // return success message
                return Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 40,
                    horizontal: 16,
                  ),
                  width: MediaQuery.sizeOf(context).width,
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
                        'Profile updated successfully!',
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
                        isLoading: state is ProfileUpdateLoading,
                        text: "Close",
                        height: 48,
                        width: MediaQuery.sizeOf(context).width * 0.5,
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
                        'Update profile',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 24),
                      CustomTextField(
                        isObscure: false,
                        headerText: "Enter your name",
                        hintText: "Please enter your name",

                        controller: name,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: StatefulBuilder(
                          builder: (context, setState) {
                            return DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                hintStyle: TextStyle(
                                  fontWeight: FontWeight.w200,
                                ),
                                hintText: 'Select your country',
                                border: OutlineInputBorder(),
                              ),
                              value:
                                  [
                                    'GB-ENG',
                                    'GB-SCT',
                                    'GB-WLS',
                                    'GB-NIR',
                                  ].contains(country)
                                  ? country
                                  : null,
                              items:
                                  [
                                    {'code': 'GB-ENG', 'name': 'England'},
                                    {'code': 'GB-SCT', 'name': 'Scotland'},
                                    {'code': 'GB-WLS', 'name': 'Wales'},
                                    {
                                      'code': 'GB-NIR',
                                      'name': 'Northern Ireland',
                                    },
                                  ].map((countryMap) {
                                    final display = '${countryMap['name']}';
                                    final code = countryMap['code']!;
                                    return DropdownMenuItem(
                                      value: code,
                                      child: Text(display),
                                    );
                                  }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  country = value ?? '';
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Country cannot be empty';
                                }
                                return null;
                              },
                            );
                          },
                        ),
                      ),

                      SizedBox(height: 24),
                      CustomButton(
                        onPressed: () {
                          context.read<SettingCubit>().updateProfile({
                            "fullName": name.text,
                            "country": country,
                          });
                        },
                        text: "Save",
                        isLoading: state is ProfileUpdateLoading,
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
