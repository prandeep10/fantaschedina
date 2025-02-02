import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Add Google Fonts for better typography
import 'predictions_screen.dart'; // Import the PredictionsScreen

void main() {
  runApp(const FantaSchedinaApp());
}

class FantaSchedinaApp extends StatelessWidget {
  const FantaSchedinaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FantaSchedina',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        textTheme: GoogleFonts.latoTextTheme(),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController pageController = PageController();
  late Timer _timer;

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
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (pageController.page == carouselItems.length - 1) {
        pageController.jumpToPage(0);
      } else {
        pageController.nextPage(
          duration: const Duration(milliseconds: 300),
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
                style: GoogleFonts.roboto(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 61, 70, 170),
                ),
              ),
            ),

            // Carousel for Updates
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
                              style: GoogleFonts.lato(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item["subtitle"]!,
                              style: GoogleFonts.lato(
                                color: Colors.white70,
                                fontSize: 16,
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
                        builder: (context) => const PredictionsScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
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
                style: GoogleFonts.roboto(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 61, 70, 170),
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
                      style: const TextStyle(
                          color: Color.fromARGB(255, 119, 118, 118)),
                    ),
                  ),
                  title: Text(
                    entry["name"],
                    style: const TextStyle(
                        color: Color.fromARGB(255, 199, 188, 188)),
                  ),
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
                style: GoogleFonts.roboto(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 61, 70, 170),
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
