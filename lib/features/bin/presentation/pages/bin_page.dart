import 'dart:convert';

import 'package:bin_app/features/bin/data/model/bin_model.dart';
import 'package:bin_app/features/bin/presentation/bloc/bin_bloc.dart';
import 'package:bin_app/features/bin/presentation/bloc/bin_state.dart';
import 'package:bin_app/features/bin/presentation/widgets/bin_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ionicons/ionicons.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../core/di/injection.dart';
import '../../../setting/presentation/pages/setting_page.dart';

class BinPage extends StatefulWidget {
  static const routeName = '/bin_page';
  const BinPage({super.key});

  @override
  State<BinPage> createState() => _BinPageState();
}

class _BinPageState extends State<BinPage> {
  Data binData = Data();
  String? binId;
  Data recycleBinData = Data();
  String? recycleBinId;
  Data gardenBinData = Data();
  String? generalBinId;

  List<String> binColors = [
    '#1D563B',
    '#1D63D8',
    '#000000',
    '#41322A',
    '#7D3A2A',
  ];

  List<String> recycleBinColors = [
    '#76B17F',
    '#1D63D8',
    '#000000',
    '#FFBD59',
    '#7D3A2A',
  ];
  List<String> gardenBinColors = [
    '#1D563B',
    '#7617BF',
    '#A9D0A0',
    '#8F6F5E',
    '#7D3A2A',
  ];

  PageController controller = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    // Initialize from local storage if needed
    initializeFromLocalStorage();
  }

  void initializeFromLocalStorage() async {
    final storage = FlutterSecureStorage();
    // Load bin colors from local storage
    try {
      String? binJson = await storage.read(key: 'binData');
      String? recycleBinJson = await storage.read(key: 'recycleBinData');
      String? gardenBinJson = await storage.read(key: 'gardenBinData');

      if (binJson != null) {
        binData = Data.fromJson(jsonDecode(binJson));
      }
      if (recycleBinJson != null) {
        recycleBinData = Data.fromJson(jsonDecode(recycleBinJson));
      }
      if (gardenBinJson != null) {
        gardenBinData = Data.fromJson(jsonDecode(gardenBinJson));
      }
    } catch (e) {
      // Handle error if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      body: BlocProvider(
        create: (context) => getIt<BinBloc>()..getBins(),
        child: BlocConsumer<BinBloc, BinState>(
          listener: (context, state) {
            // TODO: implement listener
            if (state is BinLoaded) {
              // assign bin data
              // if binData is general
              if (state.bins.data!.isNotEmpty) {
                for (var bin in state.bins.data!) {
                  if (bin?.binType == 'general') {
                    binData = bin ?? Data();
                    binId = (bin?.id ?? "").toString();
                  } else if (bin?.binType == 'recycle') {
                    recycleBinData = bin ?? Data();
                    recycleBinId = (bin?.id ?? "").toString();
                  } else if (bin?.binType == 'garden') {
                    gardenBinData = bin ?? Data();
                    generalBinId = (bin?.id ?? "").toString();
                  }
                }
              }
            }
          },
          builder: (context, state) {
            if (state is BinLoading) {
              return Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.primary,
                ),
              );
            }
            if (state is BinLoaded) {
              return Column(
                children: [
                  SizedBox(height: 24),
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * .8,
                    child: PageView(
                      scrollDirection: Axis.horizontal,
                      controller: controller,
                      children: [
                        // bin
                        BinImage(
                          data: binData,
                          colors: binColors,
                          binId: binId ?? "0",
                          onColorChange: () {
                            context.read<BinBloc>().getBins();
                          },
                        ),
                        // recycle bin
                        BinImage(
                          data: recycleBinData,
                          binId: recycleBinId ?? "0",
                          colors: recycleBinColors,
                          onColorChange: () {
                            context.read<BinBloc>().getBins();
                          },
                        ),
                        // garden bin
                        BinImage(
                          data: gardenBinData,
                          binId: generalBinId ?? "0",
                          colors: gardenBinColors,
                          onColorChange: () {
                            context.read<BinBloc>().getBins();
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // add
                  // smothe page indicator
                  SmoothPageIndicator(
                    controller: controller,
                    count: 3,
                    onDotClicked: (index) {
                      controller.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                      );
                    },

                    effect: WormEffect(
                      dotHeight: 8,
                      dotWidth: 8,
                      activeDotColor: Theme.of(context).colorScheme.primary,
                      dotColor: Colors.grey.withOpacity(0.5),
                    ),
                  ),
                  const Text(
                    'Swipe to view different bins',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              );
            }

            return Center(
              child: Text(
                'No bins found',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 18,
                ),
              ),
            );
          },
        ),
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