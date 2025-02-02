import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey.shade100,
      ),
      home: StandingsScreen(),
    );
  }
}

class StandingsScreen extends StatefulWidget {
  const StandingsScreen({super.key});
  @override
  _StandingsScreenState createState() => _StandingsScreenState();
}

class _StandingsScreenState extends State<StandingsScreen> {
  // Dummy data for standings
  final List<Map<String, dynamic>> competitions = [
    {
      "competition": "League A",
      "standings": [
        {"player": "John Doe", "matchdayPoints": 25, "totalPoints": 150},
        {"player": "Jane Smith", "matchdayPoints": 30, "totalPoints": 140},
        {"player": "Alex Johnson", "matchdayPoints": 15, "totalPoints": 135},
        {"player": "Chris Brown", "matchdayPoints": 20, "totalPoints": 130},
      ]
    },
    {
      "competition": "League B",
      "standings": [
        {"player": "Emily Clark", "matchdayPoints": 35, "totalPoints": 200},
        {"player": "Michael Green", "matchdayPoints": 25, "totalPoints": 195},
        {"player": "Sophia Lewis", "matchdayPoints": 40, "totalPoints": 190},
        {"player": "Ryan Wilson", "matchdayPoints": 20, "totalPoints": 185},
      ]
    }
  ];

  String selectedCompetition = "League A";

  @override
  Widget build(BuildContext context) {
    // Get standings for the selected competition
    final standings = competitions.firstWhere(
      (comp) => comp["competition"] == selectedCompetition,
      orElse: () => competitions[0],
    )["standings"];

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
        title: Text("Championship Standings"),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              // Refresh logic here
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Standings refreshed")),
              );
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Dropdown to switch between competitions
            DropdownButton<String>(
              value: selectedCompetition,
              isExpanded: true,
              items: competitions.map((comp) {
                return DropdownMenuItem<String>(
                  value: comp["competition"],
                  child: Text(
                    comp["competition"],
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.amberAccent),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCompetition = value!;
                });
              },
            ),
            SizedBox(height: 16),
            // Standings table
            Expanded(
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Rankings",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Divider(),
                      Expanded(
                        child: ListView.builder(
                          itemCount: standings.length,
                          itemBuilder: (context, index) {
                            final player = standings[index];
                            final bool isLoggedInUser = player["player"] ==
                                "John Doe"; // Example condition
                            return Card(
                              color: isLoggedInUser
                                  ? Colors.blue.shade100
                                  : Colors.white,
                              elevation: 2,
                              margin: EdgeInsets.symmetric(vertical: 8),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.blue.shade700,
                                  child: Text(
                                    "${index + 1}",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                title: Text(
                                  player["player"],
                                  style: TextStyle(
                                    fontWeight: isLoggedInUser
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                                subtitle: Text(
                                    "Matchday Points: ${player["matchdayPoints"]}"),
                                trailing: Text(
                                  "Total: ${player["totalPoints"]}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.blue.shade900,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
