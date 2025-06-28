import 'dart:developer';

// import 'package:bin_app/core/utility/date_picker.dart';
import 'package:bin_app/core/widgets/custom_button.dart';
import 'package:bin_app/core/widgets/custom_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/utility/date_formater.dart';
import '../../../../core/utility/date_picker.dart';
import '../../../../core/utility/svg_generator.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../bloc/bin_bloc.dart';
import '../bloc/bin_state.dart';

Future<dynamic> editBinScheduleBottomSheet(BuildContext context, String binId) {
  TextEditingController dateController = TextEditingController();
  TextEditingController collectionIntervalController = TextEditingController();
  String date = DateTime.now().subtract(Duration(days: 14)).toString();
  bool dateIsEmpty = false;
  // form key
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) => BlocProvider(
      create: (context) => getIt<BinBloc>(),
      child: Padding(
        padding: EdgeInsets.only(
          top: 10,
          left: 24,
          right: 24,
          bottom: MediaQuery.of(
            context,
          ).viewInsets.bottom, // Adjust for keyboard
        ),
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
          // Remove fixed height to allow resizing with keyboard
          child: BlocConsumer<BinBloc, BinState>(
            listener: (context, state) {
              if (state is BinUpdated) {
                log('Bin schedule updated successfully');
                Navigator.pop(context, true);
              }
            },
            builder: (context, state) {
              return StatefulBuilder(
                builder: (context, setState) {
                  return SingleChildScrollView(
                    // Add this to ensure the bottom sheet resizes with keyboard
                    reverse: true,
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
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
                          CustomDatePicker(
                            dateController: dateController,
                            endDate: date,
                            title: "Pick last collection date",
                            onTap: () async {
                              await DatePicker.showSimpleDatePicker(
                                context,
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2090),
                                dateFormat: "dd-MMMM-yyyy",
                                locale: DateTimePickerLocale.en_us,
                                looping: true,
                              ).then((value) {
                                log('Selected date: $value');
                                if (value == null) {
                                  return;
                                }
                                setState(() {
                                  date = value.toString();
                                  dateController.text = formatDate(date);
                                });
                                setState(() {
                                  dateIsEmpty = false;
                                });
                              });
                            },
                            isError: dateIsEmpty,
                            errorText: "End date is required",
                          ),
                          SizedBox(height: 16),
                          CustomTextField(
                            isObscure: false,
                            headerText: "CollectionInterval",
                            hintText: "Enter collection interval in days",
                            controller: collectionIntervalController,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Collection interval is required";
                              }
                              final int? number = int.tryParse(value);
                              if (number == null || number <= 0) {
                                return "Please enter a valid number greater than 0";
                              }
                              if (number > 30) {
                                return "Collection interval cannot be more than 30 days";
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),
                          CustomButton(
                            onPressed: () {
                              if (dateController.text.isEmpty) {
                                formKey.currentState?.validate();
                                setState(() {
                                  dateIsEmpty = true;
                                });
                                return;
                              } else if (formKey.currentState?.validate() ??
                                  false) {
                                context
                                    .read<BinBloc>()
                                    .updateBinSchedule(binId, {
                                      "lastCollectionDate": date.toString(),
                                      "collectionInterval": int.parse(
                                        collectionIntervalController.text,
                                      ),
                                    });
                              }
                            },
                            text: "Update",
                            isLoading: state is BinLoading,
                            height: 54,
                            width: MediaQuery.sizeOf(context).width * .9,
                          ),
                        ],
                      ),
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
        height: MediaQuery.sizeOf(context).height * 0.5,

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
                          'Edit Bin Color',
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomButtonOut(
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
                                                Navigator.of(
                                                  context,
                                                ).pop(color);
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
                              content: Text("Pick lid Color"),
                              isLoading: false,
                              height: 48,
                              width: MediaQuery.sizeOf(context).width * .42,
                            ),
                            CustomButtonOut(
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
                                                Navigator.of(
                                                  context,
                                                ).pop(color);
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
                              content: Text("Pick Bin Color"),
                              isLoading: false,
                              height: 48,
                              width: MediaQuery.sizeOf(context).width * .42,
                            ),
                          ],
                        ),

                        SizedBox(height: 16),

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

Future<dynamic> addBinDetailBottomSheet(
  BuildContext context,
  String binColor,
  String lidColor,
  String binType,
  List<String> colors,
) {
  TextEditingController dateController = TextEditingController();
  TextEditingController collectionIntervalController = TextEditingController();
  String date = DateTime.now().subtract(Duration(days: 14)).toString();
  bool dateIsEmpty = false;
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
  // form key
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) => BlocProvider(
      create: (context) => getIt<BinBloc>(),
      child: Padding(
        padding: EdgeInsets.only(
          top: 10,
          left: 24,
          right: 24,
          bottom: MediaQuery.of(
            context,
          ).viewInsets.bottom, // Adjust for keyboard
        ),
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
          // Remove fixed height to allow resizing with keyboard
          child: BlocConsumer<BinBloc, BinState>(
            listener: (context, state) {
              if (state is BinAdded) {
                log('Bin added successfully');
                Navigator.pop(context, true);
              }
            },
            builder: (context, state) {
              return StatefulBuilder(
                builder: (context, setState) {
                  return SingleChildScrollView(
                    // Add this to ensure the bottom sheet resizes with keyboard
                    reverse: true,
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
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
                            'Add Detail',
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
                          CustomDatePicker(
                            dateController: dateController,
                            endDate: date,
                            title: "Pick last collection date",
                            onTap: () async {
                              await DatePicker.showSimpleDatePicker(
                                context,
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2090),
                                dateFormat: "dd-MMMM-yyyy",
                                locale: DateTimePickerLocale.en_us,
                                looping: true,
                              ).then((value) {
                                log('Selected date: $value');
                                if (value == null) {
                                  return;
                                }
                                setState(() {
                                  date = value.toString();
                                  dateController.text = formatDate(date);
                                });
                                setState(() {
                                  dateIsEmpty = false;
                                });
                              });
                            },
                            isError: dateIsEmpty,
                            errorText: "End date is required",
                          ),
                          SizedBox(height: 16),
                          CustomTextField(
                            isObscure: false,
                            headerText: "CollectionInterval",
                            hintText: "Enter collection interval in days",
                            controller: collectionIntervalController,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Collection interval is required";
                              }
                              final int? number = int.tryParse(value);
                              if (number == null || number <= 0) {
                                return "Please enter a valid number greater than 0";
                              }
                              if (number > 30) {
                                return "Collection interval cannot be more than 30 days";
                              }
                              return null;
                            },
                          ),

                          // bin image
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomButtonOut(
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
                                                  Navigator.of(
                                                    context,
                                                  ).pop(color);
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
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
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
                                        lidShades = generateShades(
                                          thislidColor,
                                        );

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
                                content: Text("Pick lid Color"),
                                isLoading: false,
                                height: 48,
                                width: MediaQuery.sizeOf(context).width * .42,
                              ),
                              CustomButtonOut(
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
                                                  Navigator.of(
                                                    context,
                                                  ).pop(color);
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
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
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
                                        binShades = generateShades(
                                          thisBinColor,
                                        );
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
                                content: Text("Pick Bin Color"),
                                isLoading: false,
                                height: 48,
                                width: MediaQuery.sizeOf(context).width * .42,
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          CustomButton(
                            onPressed: () {
                              if (dateController.text.isEmpty) {
                                formKey.currentState?.validate();
                                setState(() {
                                  dateIsEmpty = true;
                                });
                                return;
                              } else if (formKey.currentState?.validate() ??
                                  false) {
                                context.read<BinBloc>().addBins({
                                  "binType": binType,
                                  "bodyColor": thisBinColor,
                                  "headColor": thislidColor,
                                  "lastCollectionDate": date.toString(),
                                  "collectionInterval": int.parse(
                                    collectionIntervalController.text,
                                  ),
                                  "notifyDaysBefore": 1,
                                });
                              }
                            },
                            text: "Add",
                            isLoading: state is BinLoading,
                            height: 54,
                            width: MediaQuery.sizeOf(context).width * .9,
                          ),
                        ],
                      ),
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
