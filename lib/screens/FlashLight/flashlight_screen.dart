// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:torch_light/torch_light.dart';

// class FlashLightScreen extends StatefulWidget {
//   const FlashLightScreen({Key? key}) : super(key: key);

//   @override
//   _FlashLightScreenState createState() => _FlashLightScreenState();
// }

// class _FlashLightScreenState extends State<FlashLightScreen> {
//   bool isActive = false;
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Colors.grey[900],
//         body: FutureBuilder<bool>(
//           future: _isTorchAvailable(context),
//           builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
//             if (snapshot.hasData && snapshot.data!) {
//               return Stack(
//                 children: [
//                   Align(
//                     alignment: Alignment.topCenter,
//                     child: Container(
//                       height: 75,
//                       decoration: const BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.only(
//                           bottomLeft: Radius.circular(45),
//                           bottomRight: Radius.circular(45),
//                         ),
//                       ),
//                     ),
//                   ),
//                   Align(
//                     alignment: Alignment.topCenter,
//                     child: Container(
//                       height: 70,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             "Flashlight",
//                             style: GoogleFonts.aclonica(
//                               color: !isActive ? Colors.black : Colors.white,
//                               fontSize: 30,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ],
//                       ),
//                       decoration: BoxDecoration(
//                         color: !isActive ? Colors.white : Colors.black,
//                         borderRadius: const BorderRadius.only(
//                           bottomLeft: Radius.circular(45),
//                           bottomRight: Radius.circular(45),
//                         ),
//                       ),
//                     ),
//                   ),
//                   Column(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       Align(
//                         alignment: Alignment.bottomCenter,
//                         child: Column(
//                           children: [
//                             Visibility(
//                               visible: isActive,
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(360),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       offset: const Offset(0, 0),
//                                       blurRadius: 50,
//                                       color: Colors.lightBlue[300]!,
//                                       spreadRadius: 50,
//                                     ),
//                                   ],
//                                 ),
//                                 child: Image.asset(
//                                   'assets/flashlight/images/flame.gif',
//                                   filterQuality: FilterQuality.high,
//                                   scale: 1.5,
//                                 ),
//                               ),
//                             ),
//                             Image.asset(
//                               'assets/flashlight/images/torch.png',
//                               filterQuality: FilterQuality.high,
//                               scale: 2,
//                             ),
//                           ],
//                         ),
//                       ),
//                       GestureDetector(
//                         onTap: () {
//                           if (!isActive) {
//                             setState(() {
//                               isActive = !isActive;
//                             });
//                             _enableTorch(context);
//                           } else {
//                             setState(() {
//                               isActive = !isActive;
//                             });
//                             _disableTorch(context);
//                           }
//                         },
//                         child: Container(
//                           margin: const EdgeInsets.only(top: 60, bottom: 150),
//                           height: 80,
//                           width: 80,
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             border: Border.all(
//                               color: !isActive ? Colors.black : Colors.white,
//                               width: 4,
//                             ),
//                             color: !isActive ? Colors.white : Colors.black,
//                           ),
//                           child: Center(
//                             child: Text(
//                               !isActive ? 'Light' : 'Dark',
//                               style: GoogleFonts.aclonica(
//                                 color: !isActive ? Colors.black : Colors.white,
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                 ],
//               );
//             } else if (snapshot.hasData) {
//               return const Center(
//                 child: Text('No torch available.'),
//               );
//             } else {
//               return const Center(
//                 child: CircularProgressIndicator(),
//               );
//             }
//           },
//         ),
//       ),
//     );
//   }
// }

// Future<bool> _isTorchAvailable(BuildContext context) async {
//   try {
//     return await TorchLight.isTorchAvailable();
//   } on Exception catch (_) {
//     _showMessage(
//       'Could not check if the device has an available torch',
//       context,
//     );
//     rethrow;
//   }
// }

// Future<void> _enableTorch(BuildContext context) async {
//   try {
//     await TorchLight.enableTorch();
//   } on Exception catch (_) {
//     _showMessage('Could not enable torch', context);
//   }
// }

// Future<void> _disableTorch(BuildContext context) async {
//   try {
//     await TorchLight.disableTorch();
//   } on Exception catch (_) {
//     _showMessage('Could not disable torch', context);
//   }
// }

// void _showMessage(String message, BuildContext context) {
//   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
// }
