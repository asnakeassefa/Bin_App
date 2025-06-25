import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SettingContent extends StatelessWidget {
  final String text;
  final Function onPressed;
  const SettingContent({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onPressed(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 16,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: SvgPicture.asset(
              'assets/icons/arrow_right.svg',
              color: Theme.of(context).colorScheme.primary,
              height: 24,
              width: 24,
            ),
          ),
        ],
      ),
    );
  }
}
