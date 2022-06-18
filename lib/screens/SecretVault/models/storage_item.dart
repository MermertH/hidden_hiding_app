import 'dart:io';

class StorageItem {
  StorageItem(this.key, this.value);

  final FileSystemEntity key;
  final List<String> value;
}
