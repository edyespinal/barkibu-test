import 'package:barkibu/models/some.dart';
import 'package:flutter/material.dart';

class ComicDetailsPage extends StatelessWidget {
  const ComicDetailsPage({super.key, required this.comic});

  final Comic comic;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          'Comic ${comic.number.toString()}',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 80),
          child: Column(
            spacing: 16,
            children: [
              Text(
                comic.title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Image.network(
                comic.image,
                loadingBuilder: (
                  BuildContext context,
                  Widget child,
                  ImageChunkEvent? loadingProgress,
                ) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return Center(
                    child: CircularProgressIndicator(
                      value:
                          loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                    ),
                  );
                },
              ),
              Text(comic.description),
              Text(
                'Published: ${comic.day}/${comic.month}/${comic.year}',
                style: TextStyle(
                  fontWeight: FontWeight.w200,
                  fontStyle: FontStyle.italic,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
