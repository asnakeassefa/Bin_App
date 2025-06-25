import 'package:bin_app/core/theme/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class DetailCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color shade;
  const DetailCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.shade,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),

      child: ListTile(
        leading: Container(
          // add rectangle with width 40 and height 40
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: shade,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Ionicons.time_outline),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle, style: TextStyle(fontSize: 14)),
      ),
    );
  }
}

int hexToFlutterHex(String hex) {
  if (hex.startsWith('#')) {
    hex = hex.substring(1);
  }
  if (hex.length == 6) {
    hex = 'FF$hex'; // Add alpha channel
  }
  return int.parse(hex, radix: 16);
}
