import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:responsi_124220026/data/restaurantModel.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailPage extends StatefulWidget {
  final int id;

  DetailPage({required this.id, required Restaurants resto});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Map<String, dynamic> restoData = {};

  @override
  void initState() {
    super.initState();
    fetchArticleData();
  }

  Future<void> fetchArticleData() async {
    try {
      final url = Uri.parse('https://restaurant-api.dicoding.dev/list/${widget.id}/');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          restoData = jsonDecode(response.body);
        });
      } else {
        throw Exception('Failed to load article data');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(restoData['name'] ?? 'Restaurant Detail'),
      ),
      body: restoData.isEmpty
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                restoData['pictureId'] ?? '',
                fit: BoxFit.cover,
                width: double.infinity,
                height: 200,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    child: Center(
                      child: Icon(Icons.broken_image, size: 50),
                    ),
                  );
                },
              ),
              SizedBox(height: 16),
              Text(
                restoData['name'] ?? '',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                restoData['description'] ?? 'Unknown Source',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(height: 8),
              Text(
                'city: ${restoData['city'] ?? ''}',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              SizedBox(height: 16),
              Text(restoData['description'] ?? ''),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}