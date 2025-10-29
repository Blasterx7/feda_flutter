#!/usr/bin/env dart

import 'dart:io';

void main(List<String> args) {
  final projectRoot = Directory.current.path;
  final srcDir = Directory('$projectRoot/lib/src');
  final exportsDir = Directory('${srcDir.path}/exports');

  if (!srcDir.existsSync()) {
    stderr.writeln(
      'lib/src directory not found. Run this script from project root.',
    );
    exit(2);
  }

  if (!exportsDir.existsSync()) {
    exportsDir.createSync(recursive: true);
    stdout.writeln('Created exports directory at ${exportsDir.path}');
  }

  final Map<String, String> exportsMap =
      {}; // exportFileName -> relativeSourcePath

  final files = srcDir
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'))
      .toList();

  for (final file in files) {
    final path = file.path.replaceAll('\\', '/');
    if (path.contains('/src/exports/')) continue; // skip existing exports
    // compute relative path from lib/src
    final prefix = '${projectRoot.replaceAll('\\', '/')}/lib/src/';
    String rel;
    if (path.startsWith(prefix)) {
      rel = path.substring(prefix.length);
    } else if (path.startsWith('lib/src/')) {
      rel = path.substring('lib/src/'.length);
    } else {
      // fallback
      final idx = path.indexOf('/lib/src/');
      rel = idx >= 0
          ? path.substring(idx + '/lib/src/'.length)
          : path.split('/lib/src/').last;
    }

    final basename = rel.split('/').last;
    var exportName = basename; // candidate

    // handle collisions
    if (exportsMap.containsKey(exportName)) {
      // create unique name using path components
      exportName = rel.replaceAll('/', '_');
      if (exportsMap.containsKey(exportName)) {
        var i = 1;
        var base = exportName.replaceAll('.dart', '');
        while (exportsMap.containsKey('${base}_$i.dart')) {
          i++;
        }
        exportName = '${base}_$i.dart';
      }
    }

    exportsMap[exportName] = rel;
  }

  // write individual export files
  for (final entry in exportsMap.entries) {
    final fileName = entry.key;
    final relPath = entry.value;
    final exportFile = File('${exportsDir.path}/$fileName');
    final content = "// Re-export ../$relPath\nexport '../$relPath';\n";
    if (exportFile.existsSync()) {
      final existing = exportFile.readAsStringSync();
      if (existing != content) {
        exportFile.writeAsStringSync(content);
        stdout.writeln('Updated ${exportFile.path}');
      }
    } else {
      exportFile.writeAsStringSync(content);
      stdout.writeln('Created ${exportFile.path}');
    }
  }

  // write index.dart
  final indexFile = File('${exportsDir.path}/index.dart');
  final buffer = StringBuffer();
  buffer.writeln('// Central exports for the package (generated).');
  buffer.writeln();
  final sorted = exportsMap.keys.toList()..sort();
  for (final f in sorted) {
    buffer.writeln("export '$f';");
  }
  final indexContent = buffer.toString();
  if (!indexFile.existsSync() || indexFile.readAsStringSync() != indexContent) {
    indexFile.writeAsStringSync(indexContent);
    stdout.writeln('Wrote ${indexFile.path}');
  } else {
    stdout.writeln('Index up-to-date: ${indexFile.path}');
  }

  // ensure top-level lib/feda_flutter.dart exports the index
  final topFile = File('$projectRoot/lib/feda_flutter.dart');
  if (topFile.existsSync()) {
    final desired =
        "library feda_flutter;\n\nexport 'package:feda_flutter/src/exports/index.dart';\n";
    final current = topFile.readAsStringSync();
    if (current.trim() != desired.trim()) {
      topFile.writeAsStringSync(desired);
      stdout.writeln(
        'Updated lib/feda_flutter.dart to export the generated index.',
      );
    } else {
      stdout.writeln('lib/feda_flutter.dart already up-to-date.');
    }
  } else {
    topFile.writeAsStringSync(
      "library feda_flutter;\n\nexport 'package:feda_flutter/src/exports/index.dart';\n",
    );
    stdout.writeln('Created lib/feda_flutter.dart');
  }

  stdout.writeln(
    '\nDone. ${exportsMap.length} export files generated/updated.',
  );
}
