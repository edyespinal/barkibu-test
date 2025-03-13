import 'dart:convert';

import 'package:barkibu/components/comic_card.dart';
import 'package:barkibu/models/some.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Comic> comics = [];
  var latest = 3062;
  var page = (3062 / 10).floor();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: HomePageAppBar(),
      ),
      body: comicsList(),
      bottomNavigationBar: homePageBottomAppBar(),
    );
  }

  Future getComics() async {
    comics = [];

    for (var i = (page * 10) + 1; i <= (page * 10) + 10; i++) {
      var response = await http.get(Uri.https('xkcd.com', '$i/info.0.json'));
      var jsonData = jsonDecode(response.body);

      if (jsonData == null) {
        break;
      }

      final comic = Comic(
        title: jsonData['title'],
        number: jsonData['num'],
        day: jsonData['day'],
        month: jsonData['month'],
        year: jsonData['year'],
        image: jsonData['img'],
        description: jsonData['alt'],
      );

      comics.add(comic);
    }
  }

  FutureBuilder<dynamic> comicsList() {
    return FutureBuilder(
      future: getComics(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ListView.builder(
            itemCount: comics.length,
            padding: EdgeInsets.fromLTRB(10, 10, 10, 40),
            itemBuilder: (context, index) {
              return ComicCard(comics: comics, index: index);
            },
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  BottomAppBar homePageBottomAppBar() {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Builder(
            builder: (context) {
              if (page < 1) {
                return TextButton.icon(
                  icon: Icon(Icons.chevron_left_sharp, color: Colors.grey),
                  label: Text('Previous', style: TextStyle(color: Colors.grey)),
                  onPressed: () {},
                );
              }

              return TextButton.icon(
                icon: Icon(Icons.chevron_left_sharp),
                label: Text('Previous'),
                onPressed: () {
                  setState(() {
                    comics = [];
                    page--;
                  });
                },
              );
            },
          ),
          Text('Page'),
          DropdownButton(
            hint: Text(page.toString()),
            value: page,
            onChanged:
                (value) => setState(() {
                  comics = [];
                  page = value as int;
                }),
            items: List.generate(
              (latest / 10).floor() + 1,
              (index) =>
                  DropdownMenuItem(value: index, child: Text('${index + 1}')),
            ),
          ),
          Builder(
            builder: (context) {
              if (page >= (latest / 10).floor()) {
                return TextButton.icon(
                  icon: Icon(Icons.chevron_right_sharp, color: Colors.grey),
                  label: Text('Next', style: TextStyle(color: Colors.grey)),
                  onPressed: () {},
                );
              } else {
                return TextButton.icon(
                  iconAlignment: IconAlignment.end,
                  label: const Text('Next'),
                  icon: Icon(Icons.chevron_right_sharp),
                  onPressed: () {
                    setState(() {
                      comics = [];
                      page = page + 1;
                    });
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class HomePageAppBar extends StatelessWidget {
  const HomePageAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        'kxcd comics',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
    );
  }
}
