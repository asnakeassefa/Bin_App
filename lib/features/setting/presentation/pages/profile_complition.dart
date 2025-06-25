// import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// // import 'package:fl_chart/fl_chart.dart';
// import '../../../../../core/network/eskalate_endpoints.dart';

// class UserProfileProgressScreen extends StatefulWidget {
//   static const String routeName = '/getProgressBar';
//   const UserProfileProgressScreen({super.key});

//   @override
//   UserProfileProgressScreenState createState() => UserProfileProgressScreenState();
// }

// class UserProfileProgressScreenState extends State<UserProfileProgressScreen> {
//   double progress = 0.0;
//   Map<String, dynamic> profileStatus = {};

//   @override
//   void initState() {
//     super.initState();
//     fetchProfileProgress();
//   }

//   Future<void> fetchProfileProgress() async {
//     String url = Endpoints.getProgressBar;
//     final authToken = await const FlutterSecureStorage().read(key: "refreshToken");

//     try {
//       final response = await http.get(
//         Uri.parse(url),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $authToken',
//         },
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         setState(() {
//           progress = data['Progress'] / 100.0;
//           profileStatus = data['ProfileStatus'];
//         });
//       } else {
//         // print('Failed to load profile progress: ${response.body}');
//       }
//     } catch (e) {
//       // print('Error fetching profile progress: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('User Profile Progress'),
//       ),
//       body: Center(
//         child: profileStatus.isEmpty
//             ? const CircularProgressIndicator()
//             : Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Text('Profile Completion', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                   const SizedBox(height: 16),
//                   SizedBox(
//                     height: 200,
//                     child: PieChart(
//                       PieChartData(
//                         sections: [
//                           PieChartSectionData(
//                             value: progress * 100,
//                             color: Colors.blue,
//                             title: '${(progress * 100).toStringAsFixed(0)}%',
//                             radius: 50,
//                             titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
//                           ),
//                           PieChartSectionData(
//                             value: (1 - progress) * 100,
//                             color: Colors.grey[300],
//                             title: '',
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   Text('${(progress * 100).toStringAsFixed(0)}% Complete'),
//                   const SizedBox(height: 16),
//                   Expanded(
//                     child: ListView(
//                       children: profileStatus.entries.map((entry) {
//                         return Card(
//                           margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                           child: Padding(
//                             padding: const EdgeInsets.all(16.0),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(entry.key, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                                 if (entry.value is Map)
//                                   ..._buildProfileStatusList(entry.value)
//                                 else
//                                   Padding(
//                                     padding: const EdgeInsets.symmetric(vertical: 4.0),
//                                     child: Row(
//                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Text(entry.key),
//                                         Text('${entry.value}'),
//                                       ],
//                                     ),
//                                   ),
//                               ],
//                             ),
//                           ),
//                         );
//                       }).toList(),
//                     ),
//                   ),
//                 ],
//               ),
//       ),
//     );
//   }

//   List<Widget> _buildProfileStatusList(Map<String, dynamic> value) {
//     return value.entries.map<Widget>((subEntry) {
//       return Padding(
//         padding: const EdgeInsets.symmetric(vertical: 4.0),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(subEntry.key),
//             Text('${subEntry.value}'),
//           ],
//         ),
//       );
//     }).toList();
//   }
// }
