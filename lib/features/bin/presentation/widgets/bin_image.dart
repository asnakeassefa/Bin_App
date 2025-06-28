import 'package:bin_app/core/widgets/custom_button.dart';
import 'package:bin_app/features/bin/presentation/widgets/detail_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/utility/date_formater.dart';
import '../../../../core/utility/svg_generator.dart';
import '../../data/model/bin_model.dart';
import 'edit_bin.dart';

class BinImage extends StatelessWidget {
  final Data data;
  final String binType;
  final String binName;
  final List<String> colors;
  final String? binId;
  final Function() onChange;
  const BinImage({
    super.key,
    required this.data,
    required this.colors,
    required this.binId,
    required this.onChange,
    required this.binType,
    required this.binName,
  });
  @override
  Widget build(BuildContext context) {
    final binShades = generateShades(data.bodyColor ?? '#808080');
    final lidShades = generateShades(data.headColor ?? '#808080');
    String svgContent = generateSvg(
      data.bodyColor ?? '#808080',
      data.headColor ?? '#808080',
      lidShades[0],
      lidShades[1],
      binShades[2],
    );
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              // make it gradient and to be transparent
              borderRadius: BorderRadius.circular(16),
            ),
            height: 320,
            child: Stack(
              // add bin lid and bin body
              children: [
                Container(
                  alignment: Alignment(0, -1.45),
                  child: SvgPicture.string(
                    svgContent,
                    alignment: Alignment.bottomCenter,
                  ),
                ),
                // Center the text horizontally to the bin SVG
                Positioned(
                  top: 220,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      (binType).toUpperCase(),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          DetailCard(
            title: 'Last Collection',
            subtitle: formatDate(data.lastCollectionDate ?? "") ?? 'N/A',
            shade: Colors.green.withOpacity(.1),
            onPress: () {},
          ),
          DetailCard(
            title: 'Next Collection',
            subtitle: formatDate(data.nextCollectionDate ?? ""),
            shade: Colors.green.withOpacity(.1),
            onPress: () {},
          ),
          // update the schedule
          if (binId != null)
            Column(
              children: [
                CustomButton(
                  onPressed: () {
                    editBinScheduleBottomSheet(context, binId.toString()).then((
                      value,
                    ) {
                      if (value == true) {
                        onChange();
                      }
                    });
                  },
                  text: "Update Schedule",
                  isLoading: false,
                  height: 54,
                  width: MediaQuery.sizeOf(context).width * .9,
                ),

                CustomButton(
                  onPressed: () {
                    if (binId != null) {
                      editBinsColorBottomSheet(
                        context,
                        data.bodyColor ?? '#808080',
                        data.headColor ?? '#808080',
                        binId ?? "",
                        colors,
                      ).then((value) {
                        if (value == true) {
                          onChange();
                        }
                      });
                    } else {}
                  },
                  text: "Update bin color",
                  isLoading: false,
                  height: 54,
                  width: MediaQuery.sizeOf(context).width * .9,
                ),
              ],
            ),
          if (binId == null)
            CustomButton(
              onPressed: () {
                addBinDetailBottomSheet(
                  context,
                  '#808080',
                  '#808080',
                  binName,
                  colors,
                ).then((value) {
                  if (value == true) {
                    onChange();
                  }
                });
              },
              text: "Add Bin Details",
              isLoading: false,
              height: 54,
              width: MediaQuery.sizeOf(context).width * .9,
            ),
        ],
      ),
    );
  }
}
