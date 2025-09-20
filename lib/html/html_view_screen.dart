import 'package:ezyvalet/authintiction/service/token_service.dart';
import 'package:ezyvalet/constants/app_colors.dart';
import 'package:ezyvalet/screens/service/HtmlApiService.dart';
import 'package:flutter/material.dart';
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

    String? response = await HtmlApiService.fetchHtmlContent(widget.url ?? "", token);

    if (response == null || response.isEmpty) return null;

    response = response.trim();

    if ((response.startsWith("[") && response.endsWith("]")) ||
        (response.startsWith("{") && response.endsWith("}"))) {
      response = response.substring(1, response.length - 1);
    }

    response = response.replaceAll(RegExp(r'"?id"?\s*:\s*"?[\w-]+"?,?'), "");

    response = response.replaceAll("privacy_policy", "");
    response = response.replaceAll("terms_and_conditions", "");

    response = response.replaceAll(RegExp(r'^"+|"+$'), "");

    return response.trim();
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

