import 'dart:developer';

import 'package:bin_app/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/utility/svg_generator.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../bloc/bin_bloc.dart';
import '../bloc/bin_state.dart';

Future<dynamic> editBinBottomSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) => BlocProvider(
      create: (context) => getIt<BinBloc>(),
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
          child: BlocConsumer<BinBloc, BinState>(
            listener: (context, state) {},
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
                      'Edit Schedule',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 24),
                    CustomTextField(
                      isObscure: false,
                      headerText: "Bin Color",
                      hintText: "Enter bin color",
                      controller: TextEditingController(),
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

Future<dynamic> editBinsColorBottomSheet(
  BuildContext context,
  String binColor,
  String lidColor,
  String binId,
  List<String> colors,
) {
  String thisBinColor = binColor;
  String thislidColor = lidColor;
  List<String> binShades = generateShades(thisBinColor);
  List<String> lidShades = generateShades(thislidColor);
  String svgContent = generateSvg(
    thisBinColor,
    thislidColor,
    lidShades[0],
    lidShades[1],
    binShades[2],
  );
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) => BlocProvider(
      create: (context) => getIt<BinBloc>(),
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
          child: BlocConsumer<BinBloc, BinState>(
            listener: (context, state) {
              if (state is BinUpdated) {
                Navigator.pop(context, true);
              }
            },
            builder: (context, state) {
              return StatefulBuilder(
                builder: (context, setState) {
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
                          'Edit Schedule',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 24),

                        Container(
                          alignment: Alignment(0, -1.45),
                          height: MediaQuery.sizeOf(context).height * .2,
                          child: SvgPicture.string(
                            svgContent,
                            alignment: Alignment.bottomCenter,
                          ),
                        ),
                        SizedBox(height: 24),
                        // custom button for pick bin color
                        CustomButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                // Example list of colors, replace with your own
                                colors
                                    .map(
                                      (hex) => Color(
                                        int.parse(
                                          hex.replaceFirst('#', '0xFF'),
                                        ),
                                      ),
                                    )
                                    .toList();

                                return AlertDialog(
                                  title: Text('Select Bin Color'),
                                  content: SizedBox(
                                    width: double.maxFinite,
                                    child: Wrap(
                                      spacing: 12,
                                      runSpacing: 12,
                                      children: colors.map((color) {
                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).pop(color);
                                          },
                                          child: Container(
                                            width: 36,
                                            height: 36,
                                            decoration: BoxDecoration(
                                              color: Color(
                                                int.parse(
                                                  color.replaceFirst(
                                                    '#',
                                                    '0xFF',
                                                  ),
                                                ),
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                color: Colors.black26,
                                                width: 2,
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                );
                              },
                            ).then((value) {
                              if (value != null) {
                                setState(() {
                                  thisBinColor = value;
                                  binShades = generateShades(thisBinColor);
                                  svgContent = generateSvg(
                                    thisBinColor,
                                    thislidColor,
                                    lidShades[0],
                                    lidShades[1],
                                    binShades[2],
                                  );
                                });
                              }
                            });
                          },
                          text: "Pick Bin Color",
                          isLoading: false,
                          height: 54,
                          width: MediaQuery.sizeOf(context).width * .9,
                        ),
                        CustomButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Select Lid Color'),
                                  content: SizedBox(
                                    width: double.maxFinite,
                                    child: Wrap(
                                      spacing: 12,
                                      runSpacing: 12,
                                      children: colors.map((color) {
                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).pop(color);
                                          },
                                          child: Container(
                                            width: 36,
                                            height: 36,
                                            decoration: BoxDecoration(
                                              color: Color(
                                                int.parse(
                                                  color.replaceFirst(
                                                    '#',
                                                    '0xFF',
                                                  ),
                                                ),
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                color: Colors.black26,
                                                width: 2,
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                );
                              },
                            ).then((value) {
                              if (value != null) {
                                setState(() {
                                  thislidColor = value;
                                  lidShades = generateShades(thislidColor);

                                  svgContent = generateSvg(
                                    thisBinColor,
                                    thislidColor,
                                    lidShades[0],
                                    lidShades[1],
                                    binShades[2],
                                  );
                                });
                              }
                            });
                          },
                          text: "Pick lid Color",
                          isLoading: false,
                          height: 54,
                          width: MediaQuery.sizeOf(context).width * .9,
                        ),
                        CustomButton(
                          onPressed: () {
                            
                            context.read<BinBloc>().updateBinColor(binId, {
                              "bodyColor": thisBinColor,
                              "headColor": thislidColor,
                            });
                          },
                          text: "Update",
                          isLoading: state is BinLoading,
                          height: 52,
                          width: MediaQuery.sizeOf(context).width * .9,
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    ),
  );
}
