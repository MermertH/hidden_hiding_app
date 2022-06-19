import 'dart:io';
import 'dart:typed_data';

class StorageItem {
  final FileSystemEntity key;
  final List<String> value;
  Uint8List? thumbnail;
  StorageItem({required this.key, required this.value, this.thumbnail});
}
