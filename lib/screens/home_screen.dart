import 'dart:async';
import 'package:flutter/material.dart';
import 'predictions_screen.dart'; // Import the PredictionsScreen

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController pageController = PageController();
  late Timer _timer;

  // Dummy data simulating backend responses
  final List<Map<String, String>> carouselItems = [
    {
      "title": "Welcome to FantaSchedina!",
      "subtitle": "Get started with your predictions today.",
      "image": "assets/a2.jpg",
    },
    {
      "title": "Tip of the Day",
      "subtitle": "Always double-check your predictions!",
      "image": "assets/a3.jpg",
    },
    {
      "title": "Weekly Update",
      "subtitle": "New competitions are live now!",
      "image": "assets/a1.jpg",
    },
  ];

  final List<Map<String, dynamic>> leaderboard = [
    {"name": "John Doe", "points": 120, "rank": 1},
    {"name": "Jane Smith", "points": 110, "rank": 2},
    {"name": "Alex Johnson", "points": 105, "rank": 3},
  ];

  final List<Map<String, String>> recentPredictions = [
    {"match": "Team A vs Team B", "status": "Won", "points": "+5"},
    {"match": "Team C vs Team D", "status": "Lost", "points": "-3"},
    {"match": "Team E vs Team F", "status": "Pending", "points": "N/A"},
  ];

  @override
  void initState() {
    super.initState();
    // Start the auto-sliding timer
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (pageController.page == carouselItems.length - 1) {
        pageController.jumpToPage(0);
      } else {
        pageController.nextPage(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Hello, John! 👋",
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: 26,
                      color: Colors.blue.shade900,
                    ),
              ),
            ),

            // Carousel for Updates (Using PageView)
            Container(
              height: 200,
              child: PageView.builder(
                controller: pageController,
                itemCount: carouselItems.length,
                itemBuilder: (context, index) {
                  final item = carouselItems[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: AssetImage(item["image"]!),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                          colors: [Colors.black54, Colors.transparent],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item["title"]!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    blurRadius: 2.0,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item["subtitle"]!,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // PUT PREDICTIONS Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PredictionsScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade900,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'PUT PREDICTIONS',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Leaderboard Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Leaderboard 🏆",
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: 22,
                      color: Colors.blue.shade900,
                    ),
              ),
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: leaderboard.length,
              itemBuilder: (context, index) {
                final entry = leaderboard[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.yellow.shade700,
                    child: Text(
                      entry["rank"].toString(),
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                  title: Text(entry["name"]),
                  subtitle: Text("Points: ${entry["points"]}"),
                  trailing: Icon(
                    Icons.emoji_events,
                    color: index == 0
                        ? Colors.yellow.shade700
                        : (index == 1
                            ? Colors.grey.shade500
                            : Colors.brown.shade400),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),

            // Recent Predictions
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Recent Predictions 📈",
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: 22,
                      color: Colors.blue.shade900,
                    ),
              ),
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: recentPredictions.length,
              itemBuilder: (context, index) {
                final prediction = recentPredictions[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(prediction["match"]!),
                    subtitle: Text("Status: ${prediction["status"]}"),
                    trailing: Text(
                      prediction["points"]!,
                      style: TextStyle(
                        color: prediction["status"] == "Won"
                            ? Colors.green
                            : (prediction["status"] == "Lost"
                                ? Colors.red
                                : Colors.orange),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
