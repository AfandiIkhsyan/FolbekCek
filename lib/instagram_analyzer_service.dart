import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:archive/archive.dart';

class InstagramAnalyzerService with ChangeNotifier {
  List<String> _followers = [];
  List<String> _following = [];
  List<String> _notFollowingBack = [];
  bool _isLoading = false;
  String _statusMessage = 'Silakan pilih file .zip Instagram Anda.';

  List<String> get followers => _followers;
  List<String> get following => _following;
  List<String> get notFollowingBack => _notFollowingBack;
  bool get isLoading => _isLoading;
  String get statusMessage => _statusMessage;

  void clearData() {
    _followers.clear();
    _following.clear();
    _notFollowingBack.clear();
    _statusMessage = 'Silakan pilih file .zip Instagram Anda.';
    notifyListeners();
  }

  Future<bool> pickAndProcessZipFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['zip'],
    );

    if (result == null) return false;

    _setLoading(true);
    clearData();
    _statusMessage = 'Membaca file ${result.files.single.name}...';
    notifyListeners();

    try {
      final path = result.files.single.path!;
      final bytes = await File(path).readAsBytes();
      final archive = ZipDecoder().decodeBytes(bytes);

      final followersFile = _findFileInArchive(archive, 'connections/followers_and_following/followers_1.json');
      final followingFile = _findFileInArchive(archive, 'connections/followers_and_following/following.json');

      if (followersFile == null || followingFile == null) {
        _statusMessage = 'Error: File followers_1.json atau following.json tidak ditemukan.';
        _setLoading(false);
        return false;
      }
      
      _statusMessage = 'Memproses followers...';
      notifyListeners();
      _followers = _parseFollowersList(followersFile.content);

      _statusMessage = 'Memproses following...';
      notifyListeners();
      _following = _parseFollowingMap(followingFile.content);

      _statusMessage = 'Menganalisis data...';
      notifyListeners();
      _analyze();
      
      _statusMessage = 'Analisis Selesai!';
      _setLoading(false);
      return true;

    } catch (e) {
      _statusMessage = 'Terjadi error: $e';
      _setLoading(false);
      return false;
    }
  }

  ArchiveFile? _findFileInArchive(Archive archive, String fileName) {
    for (final file in archive.files) {
      if (file.name == fileName) {
        return file;
      }
    }
    return null;
  }
  
  List<String> _parseFollowersList(dynamic fileContent) {
    final contentString = utf8.decode(fileContent as List<int>);
    final List<dynamic> userList = jsonDecode(contentString);

    final List<String> usernames = [];
    for (var item in userList) {
      if (item['string_list_data'] != null) {
        for (var data in item['string_list_data']) {
          usernames.add(data['value']);
        }
      }
    }
    return usernames;
  }

  List<String> _parseFollowingMap(dynamic fileContent) {
    final contentString = utf8.decode(fileContent as List<int>);
    final Map<String, dynamic> jsonData = jsonDecode(contentString);
    
    final List<dynamic> userList = jsonData['relationships_following'] ?? [];

    final List<String> usernames = [];
    for (var item in userList) {
      if (item['string_list_data'] != null) {
        for (var data in item['string_list_data']) {
          usernames.add(data['value']);
        }
      }
    }
    return usernames;
  }
  
  void _analyze() {
    final Set<String> followersSet = _followers.toSet();
    _notFollowingBack = _following.where((user) => !followersSet.contains(user)).toList();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}