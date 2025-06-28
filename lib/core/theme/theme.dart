import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ThemeData theme = ThemeData(
//   fontFamily: 'poppins',
//   appBarTheme: const AppBarTheme(scrolledUnderElevation: 0.0),
//   colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
//   bottomSheetTheme: BottomSheetThemeData(
//     dragHandleColor: Colors.grey,
//     backgroundColor: Colors.white,
//     showDragHandle: true,
//     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//   ),
//   textTheme: const TextTheme(
//     bodyMedium: TextStyle(color: Color(0xff3f3f46)),
//     bodySmall: TextStyle(color: Color(0xff3f3f46)),
//     bodyLarge: TextStyle(color: Color(0xff3f3f46)),
//     displaySmall: TextStyle(color: Color(0xff3f3f46)),
//     displayMedium: TextStyle(color: Color(0xff3f3f46)),
//     displayLarge: TextStyle(color: Color(0xff3f3f46)),
//   ),
// );

// set light and dark theme
ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  // use google font poppins
  fontFamily: GoogleFonts.poppins().fontFamily,
  scaffoldBackgroundColor: Colors.white,
  colorScheme: ColorScheme.light(
    primary: Color(0xff362929),
    secondary: Color(0xff485464),
    tertiary: Color(0xff4F93D2),
    surface: Colors.white, // Fills the remaining parts of the app window
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.white,
    // color: Colors.white,
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Color(0xffD9D9D9)), // Default border
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        color: Color(0xffD9D9D9),
      ), // Border when not focused
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Colors.red), // Border when error
    ),
    errorStyle: TextStyle(color: Colors.red, fontSize: 12),
    // focusedBorder: OutlineInputBorder(
    //   borderRadius: BorderRadius.circular(8),
    //   borderSide: BorderSide(color: Colors.blue),
    // ),
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Color(0xff3f3f46)),
    bodySmall: TextStyle(color: Color(0xff3f3f46)),
    bodyLarge: TextStyle(color: Color(0xff3f3f46)),
    displaySmall: TextStyle(color: Color(0xff3f3f46)),
    displayMedium: TextStyle(color: Color(0xff3f3f46)),
    displayLarge: TextStyle(color: Color(0xff3f3f46)),
  ),
  // ... other theme properties
);

// ThemeData darkTheme = ThemeData(
//   brightness: Brightness.dark,
//   scaffoldBackgroundColor: Colors.black,
//   fontFamily: 'inter',
//   colorScheme: ColorScheme.dark(
//     primary: Colors.white,
//     secondary: Color(0xffA1A1AA),
//     tertiary: Color(0xffF97316),
//     surface: Colors.black, // Fills the remaining parts of the app window
//   ),
//   appBarTheme: AppBarTheme(
//     backgroundColor: Colors.black,
//     // color: Colors.black
//   ),
//   inputDecorationTheme: InputDecorationTheme(
//     border: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(8),
//       borderSide: BorderSide(color: Color(0xffD9D9D9)), // Default border
//     ),
//     enabledBorder: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(8),
//       borderSide: BorderSide(
//         color: Color(0xffD9D9D9),
//       ), // Border when not focused
//     ),
//     // focusedBorder: OutlineInputBorder(
//     //   borderRadius: BorderRadius.circular(8),
//     //   borderSide: BorderSide(color: Colors.blue),
//     // ),
//   ),
//   textTheme: const TextTheme(
//     bodyMedium: TextStyle(color: Color(0xffA1A1AA)),
//     bodySmall: TextStyle(color: Color(0xffA1A1AA)),
//     bodyLarge: TextStyle(color: Color(0xffA1A1AA)),
//     displaySmall: TextStyle(color: Color(0xffA1A1AA)),
//     displayMedium: TextStyle(color: Color(0xffA1A1AA)),
//     displayLarge: TextStyle(color: Color(0xffA1A1AA)),
//   ),
//   // ... other theme properties
// );

// const Color borderColor = Color(0xffD9D9D9);
