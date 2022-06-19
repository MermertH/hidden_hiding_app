import 'dart:io';

class StorageItem {
  final FileSystemEntity key;
  final List<String> value;
  // Uint8List? thumbnail;
  StorageItem({required this.key, required this.value});
}
