import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Namer App',
        theme: ThemeData(
          // if set to false, the appBar has a color and elevated look that Mitch Koko's tutorials have.
          // it is set to true by default (or if not specified)
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurpleAccent),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  var favs = <WordPair>[];
  void toggleFavorite() {
    if (favs.contains(current)) {
      favs.remove(current);
    } else {
      favs.add(current);
    }
    print(favs);
    notifyListeners();
  }

  void deleteFavorite(var toRemove) {
    favs.remove(toRemove);
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = FavoritesPage();
        break;
      default:
        throw UnimplementedError('This index does not exist: ${selectedIndex}');
    }

    return Scaffold(
      body: Row(
        children: [
          SafeArea(
            child: NavigationRail(
              extended: false,
              destinations: [
                NavigationRailDestination(
                  icon: Icon(Icons.home),
                  label: Text('Home'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.favorite),
                  label: Text('Favorites'),
                ),
              ],
              selectedIndex: selectedIndex,
              onDestinationSelected: (value) {
                setState(() {
                  selectedIndex = value;
                });
                //print('selected: $value');
              },
            ),
          ),
          Expanded(
            child: Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: page,
            ),
          ),
        ],
      ),
    );
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favs.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          WordCard(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class WordCard extends StatelessWidget {
  final WordPair pair;

  const WordCard({
    super.key,
    required this.pair,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        //padding: EdgeInsets.fromLTRB(left, top, right, bottom),
        padding: const EdgeInsets.all(20.0),
        child: Text(pair.asLowerCase,
            style: style, semanticsLabel: "${pair.first} ${pair.second}"),
      ),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // TO-DO:
    // pick words from fav list
    // display them either row or column
    var appState = context.watch<MyAppState>();
    final theme = Theme.of(context);

    if (appState.favs.isEmpty) {
      return Center(
        child: Text('No favorites yet.'),
      );
    }
    appState.favs.sort((a, b) => a.toString().compareTo(b.toString()));
    return Center(
        child: Padding(
      padding: const EdgeInsets.all(50.0),
      child: ListView(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var wp in appState.favs)
            ElevatedButton.icon(
                onPressed: () {
                  appState.deleteFavorite(wp);
                },
                icon: Icon(Icons.delete_outline),
                label: Text(
                  wp.toString(),
                  style: theme.textTheme.bodyLarge ?? TextStyle(fontSize: 20), // Set the desired font size
                )
              ),
        ],
      ),
    ));
  }
}

// class favoriteCard extends StatelessWidget {
//   const favoriteCard({super.key, required this.wordpair});
//   final wordpair;

//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return ElevatedButton.icon(
//         onPressed: () {},
//         icon: Icon(Icons.favorite),
//         label: Text(wordpair.toString()));
//   }
// }
