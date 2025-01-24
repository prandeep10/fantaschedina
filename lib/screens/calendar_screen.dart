import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue.shade900,
        textTheme: TextTheme(
          titleLarge: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          bodyMedium: TextStyle(fontSize: 16, color: Colors.black),
        ),
      ),
      home: CalendarScreen(),
    );
  }
}

class CalendarScreen extends StatelessWidget {
  final List<Map<String, dynamic>> matchdays = [
    {
      "matchday": "FOOTBALL MATCHDAY 1",
      "date": "2025-01-25",
      "scores": [
        {"user": "John Doe", "score": 25},
        {"user": "Jane Smith", "score": 20},
        {"user": "Alex Johnson", "score": 18},
      ]
    },
    {
      "matchday": "FOOTBALL MATCHDAY 2",
      "date": "2025-02-01",
      "scores": [
        {"user": "John Doe", "score": 30},
        {"user": "Jane Smith", "score": 25},
        {"user": "Alex Johnson", "score": 28},
      ]
    },
    {
      "matchday": "FOOTBALL MATCHDAY 3",
      "date": "2025-02-05",
      "scores": [
        {"user": "John Doe", "score": 15},
        {"user": "Jane Smith", "score": 22},
        {"user": "Alex Johnson", "score": 20},
      ]
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Matchday Calendar'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: matchdays.length,
          itemBuilder: (context, index) {
            final matchday = matchdays[index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 10),
              elevation: 5,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          MatchdayDetailsScreen(matchday: matchday),
                    ),
                  );
                },
                child: ListTile(
                  contentPadding: EdgeInsets.all(16.0),
                  title: Text(
                    matchday["matchday"],
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  subtitle: Text('Date: ${matchday["date"]}'),
                  trailing: Icon(Icons.arrow_forward),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class MatchdayDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> matchday;

  MatchdayDetailsScreen({required this.matchday});

  @override
  Widget build(BuildContext context) {
    // Safely find the highest scorer
    final highestScorer = matchday["scores"].fold<Map<String, dynamic>>(
      matchday["scores"].first,
      (highest, score) => score["score"] > highest["score"] ? score : highest,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(matchday["matchday"]),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Matchday Scores',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 16),
            ...matchday["scores"].map<Widget>((score) {
              bool isHighest = score == highestScorer;
              return Card(
                color: isHighest ? Colors.green.shade100 : Colors.white,
                margin: EdgeInsets.symmetric(vertical: 8),
                elevation: 3,
                child: ListTile(
                  title: Text(score["user"]),
                  trailing: Text(
                    '${score["score"]} points',
                    style: TextStyle(
                      fontWeight:
                          isHighest ? FontWeight.bold : FontWeight.normal,
                      color: isHighest ? Colors.green : Colors.black,
                    ),
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
