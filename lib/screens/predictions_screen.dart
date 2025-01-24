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
      home: PredictionsScreen(),
    );
  }
}

class PredictionsScreen extends StatefulWidget {
  @override
  _PredictionsScreenState createState() => _PredictionsScreenState();
}

class _PredictionsScreenState extends State<PredictionsScreen> {
  final List<Map<String, dynamic>> matches = [
    {
      "homeTeam": "AC Milan",
      "awayTeam": "Inter Milan",
      "homeLogo": "https://via.placeholder.com/50",
      "awayLogo": "https://via.placeholder.com/50",
      "prediction": null,
    },
    {
      "homeTeam": "Juventus",
      "awayTeam": "Napoli",
      "homeLogo": "https://via.placeholder.com/50",
      "awayLogo": "https://via.placeholder.com/50",
      "prediction": null,
    },
    {
      "homeTeam": "Roma",
      "awayTeam": "Lazio",
      "homeLogo": "https://via.placeholder.com/50",
      "awayLogo": "https://via.placeholder.com/50",
      "prediction": null,
    },
  ];

  Future<void> submitPredictions() async {
    if (matches.every((match) => match["prediction"] != null)) {
      // Simulate backend call
      await Future.delayed(Duration(seconds: 2));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Predictions submitted successfully!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please complete all predictions!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Predictions"),
        backgroundColor: Colors.blue.shade900,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: matches.length,
              itemBuilder: (context, index) {
                final match = matches[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 16),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Column(
                                children: [
                                  Image.network(
                                    match["homeLogo"],
                                    width: 50,
                                    height: 50,
                                    errorBuilder:
                                        (context, error, stackTrace) => Icon(
                                            Icons.image,
                                            size: 50,
                                            color: Colors.grey),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    match["homeTeam"],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                "VS",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Column(
                                children: [
                                  Image.network(
                                    match["awayLogo"],
                                    width: 50,
                                    height: 50,
                                    errorBuilder:
                                        (context, error, stackTrace) => Icon(
                                            Icons.image,
                                            size: 50,
                                            color: Colors.grey),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    match["awayTeam"],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    match["prediction"] = match["homeTeam"];
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green.shade700,
                                ),
                                child: Text("Home"),
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    match["prediction"] = "Draw";
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey.shade600,
                                ),
                                child: Text("Draw"),
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    match["prediction"] = match["awayTeam"];
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red.shade700,
                                ),
                                child: Text("Away"),
                              ),
                            ),
                          ],
                        ),
                        if (match["prediction"] != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              "Prediction: ${match["prediction"]}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade900,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: submitPredictions,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade900,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                "Submit Predictions",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
