import 'dart:convert';
import 'package:ezyvalet/authintiction/service/token_service.dart';
import 'package:ezyvalet/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

class HtmlFromApiScreen extends StatefulWidget {
  final String title;
  final String? url;

  const HtmlFromApiScreen({
    Key? key,
    required this.title,
    this.url,
  }) : super(key: key);

  @override
  State<HtmlFromApiScreen> createState() => _HtmlFromApiScreenState();
}

class _HtmlFromApiScreenState extends State<HtmlFromApiScreen> {
  late Future<String?> _htmlFuture;
  final TokenService _tokenService = TokenService();

  @override
  void initState() {
    super.initState();
    _htmlFuture = _loadHtml();
  }

  Future<String?> _loadHtml() async {
    final token = await _tokenService.getAccessToken();

    if (token == null || token.isEmpty) {
      throw Exception("Token not found. Please login again.");
    }

    return ApiService.fetchHtmlContent(widget.url ?? "", token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: AppColors.highlight,
          elevation: 1,
          iconTheme: const IconThemeData(color: AppColors.white),
          title: Text(
        widget.title,
        style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.white),
      )),
      body: FutureBuilder<String?>(
        future: _htmlFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error Loading Content\n${snapshot.error}",
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No content available"));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: HtmlWidget(snapshot.data!),
          );
        },
      ),
    );
  }
}

class ApiService {
  static Future<String?> fetchHtmlContent(String url, String token) async {
    try {
      final response = await http.get(
        Uri.parse(url), // 👈 yaha widget.url ka value aayega
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        return utf8.decode(response.bodyBytes); // 👈 unicode safe
      } else if (response.statusCode == 401) {
        throw Exception("Unauthorized! Token expired or invalid");
      } else {
        throw Exception(
            "Failed to load content. Status: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }
}
