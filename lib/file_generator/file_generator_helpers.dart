import 'dart:io';

class FileGeneratorHelperFunctions {
  static void formatFile(String path) {
    Process.run('dart', ['format', path]).then((result) {
      stdout.write(result.stdout);
      stderr.write(result.stderr);
    });
  }

  static void formatFiles(List<String> paths) {
    for (String path in paths) {
      formatFile(path);
    }
  }
}
