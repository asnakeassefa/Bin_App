import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../bloc/auth_bloc.dart';
import 'login_screen.dart';
import 'otp_page.dart';

class SignUpScreen extends StatelessWidget {
  static const routeName = '/signup';
  final _formKey = GlobalKey<FormState>();
  SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailCont = TextEditingController();
    final TextEditingController passCont = TextEditingController();
    final TextEditingController nameCont = TextEditingController();
    final TextEditingController countryCont = TextEditingController();
    final TextEditingController confirmPassCont = TextEditingController();
    return BlocProvider(
      create: (context) => getIt<AuthCubit>(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('We have sent you OTP to your email'),
              ),
            );

            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) {
                  return OtpPage(email: emailCont.text);
                },
              ),
              (route) => false,
            );
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 60),
                        SizedBox(
                          height: 98,
                          width: 136,
                          child: Image.asset(
                            'assets/images/logo.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(height: 32),
                        Text(
                          'Sign up',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              // Full Name
                              CustomTextField(
                                isObscure: false,
                                headerText: 'Full Name',
                                hintText: 'Enter your Full Name',
                                controller: nameCont,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Name cannot be empty';
                                  }
                                  return null;
                                },
                              ),
                              // Email
                              CustomTextField(
                                isObscure: false,
                                headerText: 'Email',
                                hintText: 'Enter your email',
                                controller: emailCont,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Email cannot be empty';
                                  } else if (!value.contains('@')) {
                                    return 'Invalid email';
                                  }
                                  return null;
                                },
                              ),
                              // // Username
                              // CustomTextField(
                              //   isObscure: false,
                              //   headerText: 'Username',
                              //   hintText: 'Enter your username',
                              //   controller: usernameCont,
                              //   validator: (value) {
                              //     if (value!.isEmpty) {
                              //       return 'Username cannot be empty';
                              //     } else if (value.length < 3) {
                              //       return 'Username must be at least 3 characters';
                              //     }
                              //     return null;
                              //   },
                              // ),
                              // password
                              CustomTextField(
                                isObscure: true,
                                headerText: 'Password',
                                hintText: 'Enter your password',
                                controller: passCont,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Password cannot be empty';
                                  } else if (value.length < 6) {
                                    return 'Password must be at least 6 characters';
                                  }
                                  return null;
                                },
                              ),
                              // confirm password
                              CustomTextField(
                                isObscure: true,
                                headerText: 'Confirm Password',
                                hintText: 'Enter your password',
                                controller: confirmPassCont,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Password cannot be empty';
                                  } else if (value != passCont.text) {
                                    return 'Password does not match';
                                  }
                                  return null;
                                },
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Country',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                              // Country Dropdown (UK countries only, with codes)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8.0,
                                ),
                                child: DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                    hintStyle: TextStyle(
                                      fontWeight: FontWeight.w200,
                                    ),
                                    hintText: 'Select your country',
                                    border: OutlineInputBorder(),
                                  ),
                                  value: countryCont.text.isNotEmpty
                                      ? countryCont.text
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
                                      ].map((country) {
                                        final display = '${country['name']}';
                                        final code = country['code']!;
                                        return DropdownMenuItem(
                                          value: code,
                                          child: Text(display),
                                        );
                                      }).toList(),
                                  onChanged: (value) {
                                    countryCont.text = value ?? '';
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Country cannot be empty';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        CustomButton(
                          height: 56,
                          isLoading: state is AuthLoading,
                          onPressed: () {
                            // check for the password match
                            if (_formKey.currentState!.validate()) {
                              final user = {
                                "fullName": nameCont.text,
                                "email": emailCont.text,
                                "password": passCont.text,
                                "country": countryCont.text,
                              };
                              BlocProvider.of<AuthCubit>(
                                context,
                              ).register(user);
                            }
                          },
                          text: 'Sign up',
                          width: double.infinity,
                        ),

                        SizedBox(height: 8),

                        // Redirect to Login
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account?',
                              style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  LoginScreen.routeName,
                                  (routes) => false,
                                );
                              },
                              child: Text(
                                'Login',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Theme.of(context).colorScheme.tertiary,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
