import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'main.g.dart';

// Using riverpod_generator, we define Providers by annotating functions with @riverpod.
// In this example, riverpod_generator will use this function and generate a matching "fetchProductProvider".
// The following example would be the equivalent of a "FutureProvider.autoDispose.family"
@riverpod
Future<Album> fetchAlbum(FetchAlbumRef ref) async {
  final response = await http
      .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Album.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class Album {
  final int userId;
  final int id;
  final String title;

  const Album({
    required this.userId,
    required this.id,
    required this.title,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
    );
  }
}

void main() => runApp(const ProviderScope(child: MyAsyncValueRiverpodApp()));

class MyAsyncValueRiverpodApp extends ConsumerWidget {
  const MyAsyncValueRiverpodApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Riverpod AsyncValueFetch Data Example'),
        ),
        body: Center(
            child: ref.watch(fetchAlbumProvider)
                .when(data: (data) => Text(data.title),
                error: (e, __) => Text(e.toString()),
                loading: () => const CircularProgressIndicator())
        ),
      ),
    );
  }
}