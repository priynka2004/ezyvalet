// import 'package:flutter/material.dart';
//
// class CityGuideScreen extends StatelessWidget {
//   const CityGuideScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('City Guide', style: TextStyle(color: Colors.black)),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         iconTheme: IconThemeData(color: Colors.black),
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildSearchBar(),
//             SizedBox(height: 20),
//             _buildCategoryTabs(),
//             SizedBox(height: 20),
//             _buildFeaturedPlaces(),
//             SizedBox(height: 20),
//             _buildNearbyAttractions(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSearchBar() {
//     return TextField(
//       decoration: InputDecoration(
//         hintText: 'Search places, restaurants, attractions...',
//         prefixIcon: Icon(Icons.search),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide.none,
//         ),
//         filled: true,
//         fillColor: Colors.white,
//       ),
//     );
//   }
//
//   Widget _buildCategoryTabs() {
//     final categories = ['All', 'Restaurants', 'Hotels', 'Attractions', 'Shopping'];
//
//     return Container(
//       height: 40,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: categories.length,
//         itemBuilder: (context, index) {
//           final isSelected = index == 0;
//           return Container(
//             margin: EdgeInsets.only(right: 12),
//             child: FilterChip(
//               label: Text(categories[index]),
//               selected: isSelected,
//               onSelected: (selected) {},
//               backgroundColor: Colors.white,
//               selectedColor: Color(0xFFFF9500),
//               labelStyle: TextStyle(
//                 color: isSelected ? Colors.white : Colors.grey[700],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildFeaturedPlaces() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Featured Places',
//           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         SizedBox(height: 12),
//         Container(
//           height: 180,
//           child: ListView.builder(
//             scrollDirection: Axis.horizontal,
//             itemCount: 3,
//             itemBuilder: (context, index) {
//               return Container(
//                 width: 250,
//                 margin: EdgeInsets.only(right: 16),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(12),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.withOpacity(0.1),
//                       blurRadius: 5,
//                       offset: Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Container(
//                       height: 100,
//                       decoration: BoxDecoration(
//                         color: Colors.grey[300],
//                         borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
//                       ),
//                       child: Center(
//                         child: Icon(Icons.place, size: 40, color: Colors.grey[600]),
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.all(12),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Place ${index + 1}',
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                           SizedBox(height: 4),
//                           Text(
//                             'Amazing location with great reviews',
//                             style: TextStyle(color: Colors.grey[600], fontSize: 12),
//                           ),
//                           SizedBox(height: 8),
//                           Row(
//                             children: [
//                               Icon(Icons.star, size: 16, color: Colors.amber),
//                               Text('4.${8 + index}'),
//                               Spacer(),
//                               Text('2.${index + 1} km', style: TextStyle(fontSize: 12)),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildNearbyAttractions() {
//     final attractions = [
//       {'name': 'Central Park', 'distance': '0.5 km', 'rating': '4.8'},
//       {'name': 'Art Museum', 'distance': '1.2 km', 'rating': '4.6'},
//       {'name': 'Shopping Mall', 'distance': '0.8 km', 'rating': '4.4'},
//     ];
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Nearby Attractions',
//           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         SizedBox(height: 12),
//         ListView.builder(
//           shrinkWrap: true,
//           physics: NeverScrollableScrollPhysics(),
//           itemCount: attractions.length,
//           itemBuilder: (context, index) {
//             final attraction = attractions[index];
//             return Container(
//               margin: EdgeInsets.only(bottom: 12),
//               padding: EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(12),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.1),
//                     blurRadius: 5,
//                     offset: Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: Row(
//                 children: [
//                   Container(
//                     width: 50,
//                     height: 50,
//                     decoration: BoxDecoration(
//                       color: Colors.grey[300],
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Icon(Icons.place, color: Colors.grey[600]),
//                   ),
//                   SizedBox(width: 12),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           attraction['name']!,
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                         SizedBox(height: 4),
//                         Text(
//                           attraction['distance']!,
//                           style: TextStyle(color: Colors.grey[600], fontSize: 12),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Row(
//                     children: [
//                       Icon(Icons.star, size: 16, color: Colors.amber),
//                       Text(attraction['rating']!),
//                     ],
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ],
//     );
//   }
// }
