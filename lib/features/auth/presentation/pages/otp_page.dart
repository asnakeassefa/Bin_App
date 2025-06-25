import 'dart:developer';

import 'package:bin_app/features/bin/presentation/pages/bin_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/custom_colors.dart';
import '../../../../core/theme/custom_typo.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/error_text.dart';
import '../../../../core/widgets/success_text.dart';
import '../bloc/auth_bloc.dart';
// import '../../../app.dart';

class OtpPage extends StatefulWidget {
  static const routeName = "/otp_page";

  final String email;
  const OtpPage({super.key, required this.email});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  String otp = "";
  bool filled = false;
  // lets do count down timer
  int currSecond = 60;
  bool isResendActive = true;
  TextEditingController otpController = TextEditingController();
  bool otpSent = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AuthCubit>(),
      child: Scaffold(
        appBar: AppBar(automaticallyImplyLeading: true),
        body: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is OtpSuccess) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                BinPage.routeName,
                (route) => false,
              );
            }

            if (state is AuthFailure) {
              // make the otp sent true for 10 seconds only
              setState(() {
                otpSent = false;
              });
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 20),
                          SvgPicture.asset('assets/images/logo.svg'),
                          Center(
                            child: Text(
                              'Enter OTP',
                              style: CustomTypography.titleMedium.copyWith(
                                color: CustomColors.bgLight,
                              ),
                            ),
                          ),
                          Center(
                            child: Text(
                              'Enter the OTP sent to your phone number',
                              style: CustomTypography.bodyLarge.copyWith(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Pinput(
                            length: 6,
                            controller: otpController,
                            focusedPinTheme: PinTheme(
                              textStyle: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Theme.of(context).colorScheme.tertiary,
                                  width: 2,
                                ),
                              ),
                              width: 60,
                              height: 60,
                            ),
                            defaultPinTheme: PinTheme(
                              textStyle: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 2,
                                ),
                                color: Theme.of(context).colorScheme.surface,
                                shape: BoxShape.circle,
                              ),
                              width: 60,
                              height: 60,
                            ),
                            onCompleted: (value) {
                              otp = value;
                              setState(() {
                                filled = true;
                              });
                            },
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                      if (state is AuthFailure)
                        ErrorText(errorText: state.message),
                      if (state is AuthSuccess)
                        // show success message
                        SuccessText(successText: state.message),

                      CustomButton(
                        onPressed: () {
                          context.read<AuthCubit>().verifyOtp({
                            "email": widget.email,
                            "code": otpController.text,
                          });
                        },
                        text: "Verify",
                        isLoading: state is AuthLoading,
                        height: 54,
                        width: MediaQuery.sizeOf(context).width * 0.7,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              if (isResendActive) {
                                log(widget.email);
                                context.read<AuthCubit>().resendOTP(
                                  widget.email,
                                );
                                setState(() {
                                  isResendActive = false;
                                });
                                Future.delayed(const Duration(seconds: 10), () {
                                  setState(() {
                                    isResendActive = true;
                                  });
                                });
                              }
                            },
                            child: Text(
                              "Resend OTP",
                              style: CustomTypography.bodyLarge.copyWith(
                                color: isResendActive
                                    ? Theme.of(context).colorScheme.tertiary
                                    : CustomColors.info,
                                fontFamily: GoogleFonts.poppins().fontFamily,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
