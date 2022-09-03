import 'dart:io';

class FileGeneratorHelperFunctions {
  // Takes a absolute path to a Dart file and formats the file
  static void formatFile(String path) {
    Process.run('dart', ['format', path], runInShell: true);
  }

  // Takes in absolute paths to Dart files and formats the files
  static void formatFiles(List<String> paths) {
    for (String path in paths) {
      formatFile(path);
    }
  }
}
