import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

final githubIssuesDatasourceProvider = Provider((ref) => GithubIssuesDatasource());

class GithubIssuesDatasource {
  final String _repoOwner = 'VladoDev';
  final String _repoName = 'hueyappanv1';

  Future<String?> _uploadScreenshot(Uint8List screenshotBytes, String token) async {
    try {
      final base64Image = base64Encode(screenshotBytes);
      final user = FirebaseAuth.instance.currentUser;
      final userId = user?.uid ?? 'anonymous';
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'bug_reports_images/${userId}_$timestamp.png';
      
      final url = Uri.parse('https://api.github.com/repos/$_repoOwner/$_repoName/contents/$fileName');
      
      final response = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/vnd.github.v3+json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'message': 'Upload bug report screenshot via app',
          'content': base64Image,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return jsonResponse['content']['download_url'] ?? jsonResponse['content']['html_url'];
      } else {
        print('Error uploading to GitHub: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error uploading screenshot to GitHub: $e');
      return null;
    }
  }

  Future<void> createIssue({
    required String title,
    required String description,
    required String type, // 'bug', 'idea', 'problem'
    Uint8List? screenshotBytes,
  }) async {
    final token = dotenv.env['GITHUB_PAT'];
    if (token == null || token.isEmpty) {
      throw Exception('GitHub PAT no está configurado en .env');
    }

    String finalDescription = description;
    String label = '';

    if (type == 'bug') {
      label = 'bug';
      
      try {
        final packageInfo = await PackageInfo.fromPlatform();
        final deviceInfo = DeviceInfoPlugin();
        String deviceModel = 'Desconocido';
        String osVersion = 'Desconocido';

        if (kIsWeb) {
          deviceModel = 'Web Browser';
          osVersion = 'Web';
        } else if (Platform.isAndroid) {
          final androidInfo = await deviceInfo.androidInfo;
          deviceModel = '${androidInfo.manufacturer} ${androidInfo.model}';
          osVersion = 'Android ${androidInfo.version.release} (SDK ${androidInfo.version.sdkInt})';
        } else if (Platform.isIOS) {
          final iosInfo = await deviceInfo.iosInfo;
          deviceModel = iosInfo.utsname.machine;
          osVersion = '${iosInfo.systemName} ${iosInfo.systemVersion}';
        }

        final user = FirebaseAuth.instance.currentUser;
        final reporter = user != null ? (user.displayName ?? user.email ?? user.uid) : 'Anónimo';
        final timeStr = DateTime.now().toLocal().toString();

        finalDescription += '''

---
**Información de Diagnóstico (Automática):**
- **Reportado por:** $reporter
- **Hora Local:** $timeStr
- **Versión de la App:** ${packageInfo.version} (Build ${packageInfo.buildNumber})
- **Dispositivo:** $deviceModel
- **OS:** $osVersion
''';
      } catch (e) {
        print('Error gathering device info: $e');
      }

      if (screenshotBytes != null) {
        final imageUrl = await _uploadScreenshot(screenshotBytes, token);
        if (imageUrl != null) {
          finalDescription += '\n\n### Captura de pantalla\n![Captura]($imageUrl)';
        } else {
          finalDescription += '\n\n*(La captura de pantalla no se pudo subir)*';
        }
      }
    } else if (type == 'idea') {
      label = 'enhancement';
    } else if (type == 'problem') {
      label = 'neighborhood-issue';
    }

    final url = Uri.parse('https://api.github.com/repos/$_repoOwner/$_repoName/issues');
    
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/vnd.github.v3+json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'title': '[$type] $title',
        'body': finalDescription,
        'labels': [label],
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Error al crear issue en GitHub: ${response.statusCode} - ${response.body}');
    }
  }
}
