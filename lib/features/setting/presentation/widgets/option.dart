
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SettingOptionContent extends StatelessWidget {
  final String iconPath;
  final String text;
  final bool isSwitch;
  SettingOptionContent({
    super.key,
    required this.iconPath,
    required this.text,
    required this.isSwitch,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SvgPicture.asset(
              iconPath,
              color: Theme.of(context).colorScheme.primary,
            ),
            SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
              ),
            ),
          ],
        ),
        // Switch to enable and disable
        Switch(
          value: isSwitch,
          onChanged: (value) {},
          activeTrackColor: Theme.of(context).colorScheme.primary,
          activeColor: Theme.of(context).colorScheme.surface,
        ),
      ],
    );
  }
}
