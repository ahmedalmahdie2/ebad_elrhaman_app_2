import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class FilesDownloader {
  FilesDownloader(
      this.url, this.secondPart, this.params, this.onConnectionFailed);

  final String url;
  final String secondPart;
  final Function(int) onConnectionFailed;
  final Map<String, String> params;
  int responseCode;
  static Directory homeDirectory;
  static bool _isFirstTime = true;
  static http.Client client = http.Client();

  Future getData() async {
    // print('connecting to: ${Uri.http(url, secondPart)}');

    http.Response response = await http.get(Uri.https(url, secondPart, params));
    print('connecting to: ${Uri.https(url, secondPart, params)}');

    if (response.statusCode == 200) {
      String data = response.body;
      // print(data);
      return jsonDecode(data);
    } else {
      print('we found an error !!!!!: ${response.statusCode}');
      onConnectionFailed(response.statusCode);
      return null;
    }
  }

  Future<int> getFileSize(Uri uri) async {
    http.Response r = await http.head(uri);
    return 100;
  }

  static Future<bool> doesFileExist(String path, String fileName) async {
    if (_isFirstTime) {
      print('getApplicationDocumentsDirectory _isFirstTime: $_isFirstTime');
      homeDirectory = await getApplicationDocumentsDirectory();
      _isFirstTime = false;
    }

    fileName = fileName.replaceAll(" ", "_");
    return await File(join(homeDirectory.path, path, '$fileName')).exists();
  }

  static Future<String> readFileAsString(path, String fileName) async {
    if (_isFirstTime) {
      print('getApplicationDocumentsDirectory _isFirstTime: $_isFirstTime');
      homeDirectory = await getApplicationDocumentsDirectory();
      _isFirstTime = false;
    }

    fileName = fileName.replaceAll(" ", "_");
    return await File(join(homeDirectory.path, path, '$fileName'))
        .readAsString();
  }

  ///
  /// path shouldn't include app home directory => getApplicationDocumentsDirectory
  /// fileName should include the extension
  static Future<String> SaveFile(
      String path, String fileName, List<int> bytes) async {
    if (_isFirstTime) {
      print('getApplicationDocumentsDirectory _isFirstTime: $_isFirstTime');
      homeDirectory = await getApplicationDocumentsDirectory();
      _isFirstTime = false;
    }
    fileName = fileName.replaceAll(" ", "_");
    Directory dir =
        await Directory(join(homeDirectory.path, path)).create(recursive: true);
    File file = File(join(dir.path, fileName));

    print(file.path);
    await file.writeAsString(utf8.decode(bytes));
    print('file has been saved to storage');
    return file.path;
  }

  static void closeDownload() {
    client.close();
  }

  static Future downloadFile(
      {Uri uri,
      Function(List<int>) onDone,
      Function(dynamic) onError,
      Function(int) onProgress}) async {
    client = http.Client();
    http.StreamedResponse response =
        await client.send(http.Request('GET', uri));

    final fileSize = response.headers["content-length"];

    List<int> bytes = [];
    int _progress = 0;
    print('$fileSize this is the content length');
    response.stream.listen((value) async {
      bytes.addAll(value);
      // print('recieved ${bytes.length}');
      // print('progress ${(bytes.length / int.parse(file_size)) * 100}');
      if (onProgress != null)
        onProgress(((bytes.length / int.parse(fileSize ?? 1)) * 100).floor());
    }, onDone: () async {
      if (onDone != null) onDone(bytes);
      closeDownload();
    }, onError: (e) {
      print(e);
      if (onError != null) onError(e);
      closeDownload();
    }, cancelOnError: true);
  }
}
