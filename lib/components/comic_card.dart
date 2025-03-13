import 'package:barkibu/models/some.dart';
import 'package:barkibu/pages/comics/details.dart';
import 'package:flutter/material.dart';

class ComicCard extends StatelessWidget {
  const ComicCard({super.key, required this.comics, required this.index});

  final List<Comic> comics;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ComicDetailsPage(comic: comics[index]),
              ),
            );
          },
          trailing: Text(
            comics[index].number.toString(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          title: Text(
            comics[index].title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            '${comics[index].day}/${comics[index].month}/${comics[index].year}',
          ),
        ),
      ),
    );
  }
}
