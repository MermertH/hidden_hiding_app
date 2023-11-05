import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FileMovingDialog extends StatefulWidget {
  const FileMovingDialog({Key? key}) : super(key: key);

  @override
  State<FileMovingDialog> createState() => _FileMovingDialogState();
}

class _FileMovingDialogState extends State<FileMovingDialog> {
  int counter = 0;
  late Timer timer;

  @override
  void initState() {
    timer = Timer.periodic(const Duration(milliseconds: 250), (timer) {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              'Media is being moved...',
              textAlign: TextAlign.center,
              style: GoogleFonts.abel(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Flexible(
                  flex: 2,
                  child: Icon(
                    Icons.folder,
                    size: 45,
                  ),
                ),
                Flexible(
                  flex: 6,
                  child: Row(
                    children: List.generate(
                      50,
                      (index) => Expanded(
                        child: Container(
                          height: (Random().nextInt(20) + 5) * 1.0,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ),
                ),
                const Flexible(
                  flex: 2,
                  child: Icon(
                    Icons.folder,
                    size: 45,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
