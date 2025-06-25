import 'package:bin_app/features/bin/presentation/bloc/bin_bloc.dart';
import 'package:bin_app/features/bin/presentation/bloc/bin_state.dart';
import 'package:bin_app/features/bin/presentation/widgets/detail_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/utility/svg_generator.dart';

class BinImage extends StatelessWidget {
  final String binColor;
  final String lidColor;
  final String title;
  const BinImage({
    super.key,
    required this.binColor,
    required this.lidColor,
    required this.title,
  });
  @override
  Widget build(BuildContext context) {
    final binShades = generateShades(binColor);
    final lidShades = generateShades(lidColor);
    String svgContent = generateSvg(
      binColor,
      lidColor,
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
              gradient: LinearGradient(
                colors: [Colors.white.withOpacity(0.8)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
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
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w100,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          DetailCard(
            title: 'Last Collection',
            subtitle: binColor,
            shade: Colors.green.withOpacity(.1),
          ),
          DetailCard(
            title: 'Next Collection',
            subtitle: lidColor,
            shade: Colors.green.withOpacity(.1),
          ),
        ],
      ),
    );
  }
}
// 
Future<dynamic> changePasswordBottomSheet(BuildContext context) {
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
                      'Change Password',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 24),

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
