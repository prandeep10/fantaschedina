import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue.shade900,
        textTheme: TextTheme(
          titleLarge: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade900,
          ),
          bodyMedium: const TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        cardTheme: CardTheme(
          elevation: 5,
          margin: const EdgeInsets.symmetric(vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      home: const CalendarScreen(),
    );
  }
}

// Model class for scores
class UserScore {
  final String user;
  final int score;

  const UserScore({required this.user, required this.score});

  factory UserScore.fromJson(Map<String, dynamic> json) {
    return UserScore(
      user: json['user'] as String,
      score: json['score'] as int,
    );
  }
}

// Model class for matchday
class Matchday {
  final String title;
  final String date;
  final List<UserScore> scores;

  const Matchday({
    required this.title,
    required this.date,
    required this.scores,
  });

  factory Matchday.fromJson(Map<String, dynamic> json) {
    return Matchday(
      title: json['matchday'] as String,
      date: json['date'] as String,
      scores: (json['scores'] as List)
          .map((score) => UserScore.fromJson(score as Map<String, dynamic>))
          .toList(),
    );
  }
}

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  static final List<Matchday> matchdays = [
    Matchday.fromJson({
      "matchday": "FOOTBALL MATCHDAY 1",
      "date": "2025-01-25",
      "scores": [
        {"user": "John Doe", "score": 25},
        {"user": "Jane Smith", "score": 20},
        {"user": "Alex Johnson", "score": 18},
      ]
    }),
    Matchday.fromJson({
      "matchday": "FOOTBALL MATCHDAY 2",
      "date": "2025-02-01",
      "scores": [
        {"user": "John Doe", "score": 30},
        {"user": "Jane Smith", "score": 25},
        {"user": "Alex Johnson", "score": 28},
      ]
    }),
    Matchday.fromJson({
      "matchday": "FOOTBALL MATCHDAY 3",
      "date": "2025-02-05",
      "scores": [
        {"user": "John Doe", "score": 15},
        {"user": "Jane Smith", "score": 22},
        {"user": "Alex Johnson", "score": 20},
      ]
    }),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1E3A8A), Color(0xFF2563EB)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text(
          'Matchday Calendar',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade50,
              Colors.white,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: matchdays.length,
            itemBuilder: (context, index) {
              final matchday = matchdays[index];
              return MatchdayCard(matchday: matchday);
            },
          ),
        ),
      ),
    );
  }
}

class MatchdayCard extends StatelessWidget {
  final Matchday matchday;

  const MatchdayCard({super.key, required this.matchday});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MatchdayDetailsScreen(matchday: matchday),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    matchday.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                    color: Colors.blue,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Date: ${matchday.date}',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MatchdayDetailsScreen extends StatelessWidget {
  final Matchday matchday;

  const MatchdayDetailsScreen({super.key, required this.matchday});

  @override
  Widget build(BuildContext context) {
    final highestScorer = matchday.scores.reduce(
      (curr, next) => curr.score > next.score ? curr : next,
    );

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1E3A8A), Color(0xFF2563EB)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text(
          matchday.title,
          style: const TextStyle(color: Colors.white),
        ),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade50,
              Colors.white,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Matchday Scores',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: matchday.scores.length,
                  itemBuilder: (context, index) {
                    final score = matchday.scores[index];
                    final isHighest = score == highestScorer;
                    return ScoreCard(
                      score: score,
                      isHighest: isHighest,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ScoreCard extends StatelessWidget {
  final UserScore score;
  final bool isHighest;

  const ScoreCard({
    super.key,
    required this.score,
    required this.isHighest,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isHighest ? Colors.green.shade50 : Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: isHighest ? 4 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isHighest
            ? BorderSide(color: Colors.green.shade200, width: 1)
            : BorderSide.none,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          score.user,
          style: TextStyle(
            fontWeight: isHighest ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isHighest ? Colors.green.shade100 : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '${score.score} points',
            style: TextStyle(
              fontWeight: isHighest ? FontWeight.bold : FontWeight.normal,
              color: isHighest ? Colors.green.shade700 : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}
