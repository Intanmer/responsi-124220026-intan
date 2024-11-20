import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'data/restaurantModel.dart';
import 'detail.dart';
import 'services/authServices.dart';

class DaftarPage extends StatefulWidget {
  @override
  _DaftarPageState createState() => _DaftarPageState();
}

class _DaftarPageState extends State<DaftarPage> {
  String _username = '';
  late Future<ClassName> resto;

  Future<ClassName> fetchResto() async {
    String username = await AuthServices.getUsername();
    setState(() {
      _username = username;
    });
    final response = await http.get(Uri.parse('https://restaurant-api.dicoding.dev/list'));
    if (response.statusCode == 200) {
      return ClassName.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load agents');
    }

    
  }

  @override
  void initState() {
    super.initState();
    resto = fetchResto();
    _loadUsername();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hai, $_username'),
        backgroundColor: Colors.purple,
      ),
      body: FutureBuilder<ClassName>(
        future: resto,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final restoList = snapshot.data!.restaurants!;
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: restoList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPage(resto: restoList[index], id: 1,),
                      ),
                    );
                  },
                  child: Card(
                    child: Column(
                      children: [
                        Image.network(restoList[index] as String, height: 100),
                        SizedBox(height: 10),
                        Text(restoList[index] as String, style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class _loadUsername {
}
