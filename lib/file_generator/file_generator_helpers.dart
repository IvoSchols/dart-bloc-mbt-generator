import 'dart:io';

class FileGeneratorHelperFunctions {
  static void formatFile(String path) {
    Process.run('./dart', ['format', path], runInShell: true);
  }

  static void formatFiles(List<String> paths) {
    for (String path in paths) {
      formatFile(path);
    }
  }
}
