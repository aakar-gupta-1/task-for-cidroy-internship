import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cidroy/Models/album.dart';
import 'dart:convert';
import 'widgets/charts/stacked_bar_chart.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<Album> fetchAlbum() async {
    final response = await http.get('https://eflask-app-api.herokuapp.com/');

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return Album.fromJson(jsonResponse[0]);
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<Album> futureAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task for Cidroy Internship'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<Album>(
              future: futureAlbum,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ChartsDemo(snapshot.data);
                    // Text(snapshot.data.hourly[0]['10am'].toString());
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                // By default, show a loading spinner.
                return CircularProgressIndicator();
              },
            ),
          ),
        ],
      ),
    );
  }
}
