import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/custom_colors.dart';
import '../../../../core/theme/custom_typo.dart';

class CustomDatePicker extends StatelessWidget {
  final TextEditingController dateController;
  final String endDate;
  final String title;
  final Function() onTap;
  final String? errorText;
  final bool? isError;
  const CustomDatePicker({
    super.key,
    required this.dateController,
    required this.endDate,
    required this.title,
    required this.onTap,
    this.errorText,
    this.isError,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            onTap();
          },
          child: Container(
            height: 48,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              border: Border.all(
                color: (isError ?? false) ? Colors.red : CustomColors.info,
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                const SizedBox(width: 16),
                const Icon(
                  Icons.calendar_month,
                  color: CustomColors.contentSecondary,
                ),
                const SizedBox(width: 16),
                Text(
                  dateController.text.isNotEmpty ? dateController.text : title,
                  style: CustomTypography.bodyMedium.copyWith(
                    color: dateController.text.isEmpty
                        ? CustomColors.contentSecondary
                        : CustomColors.contentPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
        if ((isError ?? false) && errorText != null)
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 4),
            child: Text(
              errorText!,
              style: CustomTypography.bodySmall.copyWith(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}
