import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomButton extends StatelessWidget {
  final void Function() onPressed;
  final String text;
  final bool isLoading;
  final double height;
  final double width;
  final Color? color;
  final String? imageName;
  const CustomButton({
    super.key,
    required this.onPressed,
    required this.text,
    required this.isLoading,
    required this.height,
    required this.width,
    this.color,
    this.imageName,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color != null
            ? color
            : Theme.of(context).colorScheme.primary,
        maximumSize: Size(width, height),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: onPressed,
      child: isLoading
          ? Container(
              width: width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 35,
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                ],
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (imageName != null)
                  SvgPicture.asset(
                    imageName!,
                    color: color != null
                        ? Colors.white
                        : Theme.of(context).colorScheme.surface,
                  ),
                Text(
                  text,
                  style: TextStyle(
                    color: color != null
                        ? Colors.white
                        : Theme.of(context).colorScheme.surface,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
    );
  }
}
