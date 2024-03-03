import 'package:fetch_app/post.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fetch App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeWidget(),
    );
  }
}


class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  Future<Post?>? post;

  void clickGetButton() {
    setState(() {
      post = fetchPost();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Center(
          child: Text('Fetch App'),
        ),
      ),
      body: SizedBox(
        height: 500,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FutureBuilder<Post?>(
              future: post,
              builder: (context, snapshot){
                if (snapshot.connectionState == ConnectionState.waiting){
                  return const CircularProgressIndicator();
                } else if (snapshot.connectionState == ConnectionState.none){
                  return Container();
                } else {
                  if (snapshot.hasData){
                    return buildDataWidget(context, snapshot);
                  } else if (snapshot.hasError){
                    return Text('${snapshot.error}');
                  } else {
                    return Container();
                  }
                }
              },
            ),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: () => clickGetButton(),
                child: const Text("GET"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildDataWidget(BuildContext context, AsyncSnapshot<Post?> snapshot) {
  final post = snapshot.data;
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Padding(
        padding: const EdgeInsets.all(15),
        child: Text('Post ID: ${post?.postId ?? ''}'),
      ),
      Padding(
        padding: const EdgeInsets.all(8),
        child: Text('ID: ${post?.id ?? ''}'),
      ),
      Padding(
        padding: const EdgeInsets.all(8),
        child: Text('Name: ${post?.name ?? ''}'),
      ),
      Padding(
        padding: const EdgeInsets.all(8),
        child: Text('Email: ${post?.email ?? ''}'),
      ),
      Padding(
        padding: const EdgeInsets.all(8),
        child: Text('Body: ${post?.body ?? ''}'),
      ),
    ],
  );
}


Future<Post> fetchPost() async {
  final uri = Uri.parse('https://jsonplaceholder.typicode.com/comments/1');
  final response = await http.get(uri);

  if(response.statusCode == 200){
    return Post.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load post');
  }
}


