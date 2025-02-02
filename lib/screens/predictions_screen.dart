import 'package:flutter/material.dart';
import 'dart:async';

class PredictionsScreen extends StatefulWidget {
  const PredictionsScreen({super.key});

  @override
  _PredictionsScreenState createState() => _PredictionsScreenState();
}

class _PredictionsScreenState extends State<PredictionsScreen> {
  // User Statistics
  final Map<String, dynamic> userStats = {
    'position': '1a',
    'matches': 18,
    'totalPoints': 78,
    'weeklyPoints': 30,
    'lastWeek': {'guessed': '8/10', 'position': '1a', 'points': 3},
    'currentMatchday': '20ª', // Added for dynamic matchday display
  };

  // Match Data
  final List<Map<String, dynamic>> matches = [
    {
      'id': '1',
      'homeTeam': 'Roma',
      'awayTeam': 'Genoa',
      'date':
          '${DateTime.now().day + 1}/${DateTime.now().month}/${DateTime.now().year.toString().substring(2)}', // Tomorrow's date

      'kickoffTime': '20:45',
      'selectedPrediction': null,
      'predictions': {
        'C': <String>['Lukaku'],
        'G': <String>['CDK'],
        'V': <String>['Almqvist'],
        'L': <String>[],
      },
      'othersVisible': false,
    },
    {
      'id': '2',
      'homeTeam': 'Bologna',
      'awayTeam': 'Monza',
      'date':
          '${DateTime.now().day + 1}/${DateTime.now().month}/${DateTime.now().year.toString().substring(2)}',
      'kickoffTime': '18:30',
      'selectedPrediction': null,
      'predictions': {
        'C': <String>[],
        'G': <String>[],
        'V': <String>[],
        'L': <String>[],
      },
      'othersVisible': false,
    },
  ];

  // State variables
  int doubleChancesUsed = 0;
  static const int maxDoubleChances = 2;
  bool hasSubmittedPredictions = false;
  Timer? _timer;
  Duration? _timeUntilCutoff;

  @override
  void initState() {
    super.initState();
    _setupTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _setupTimer() {
    // Find earliest match time and set cutoff 5 minutes before
    final firstMatchDateTime = _findEarliestMatchTime();
    final cutoffTime = firstMatchDateTime.subtract(const Duration(minutes: 5));

    _updateRemainingTime(cutoffTime);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateRemainingTime(cutoffTime);
    });
  }

  DateTime _findEarliestMatchTime() {
    DateTime? earliest;

    for (var match in matches) {
      final matchDateTime = _parseDateTime(match['date'], match['kickoffTime']);
      if (earliest == null || matchDateTime.isBefore(earliest)) {
        earliest = matchDateTime;
      }
    }

    return earliest ?? DateTime.now();
  }

  DateTime _parseDateTime(String date, String time) {
    final parts = date.split('/');
    final timeParts = time.split(':');

    return DateTime(
      2000 + int.parse(parts[2]),
      int.parse(parts[1]),
      int.parse(parts[0]),
      int.parse(timeParts[0]),
      int.parse(timeParts[1]),
    );
  }

  void _updateRemainingTime(DateTime cutoffTime) {
    final now = DateTime.now();
    if (now.isBefore(cutoffTime)) {
      setState(() {
        _timeUntilCutoff = cutoffTime.difference(now);
      });
    } else {
      setState(() {
        _timeUntilCutoff = null;
      });
      _timer?.cancel();
    }
  }

  String _formatDuration(Duration? duration) {
    if (duration == null) return 'Predictions Closed';

    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void _handlePrediction(String matchId, String prediction) {
    if (_timeUntilCutoff == null) return;

    setState(() {
      final matchIndex = matches.indexWhere((m) => m['id'] == matchId);
      if (matchIndex != -1) {
        // Clear previous prediction if exists
        matches[matchIndex]['selectedPrediction'] = prediction;
      }
    });
  }

  void _handleDoubleChance(String matchId, String prediction) {
    if (_timeUntilCutoff == null || doubleChancesUsed >= maxDoubleChances)
      return;

    setState(() {
      final matchIndex = matches.indexWhere((m) => m['id'] == matchId);
      if (matchIndex != -1) {
        if (matches[matchIndex]['selectedPrediction'] == prediction) {
          // Deselect if already selected
          matches[matchIndex]['selectedPrediction'] = null;
          doubleChancesUsed--;
        } else if (matches[matchIndex]['selectedPrediction'] == null) {
          // Select new double chance
          matches[matchIndex]['selectedPrediction'] = prediction;
          doubleChancesUsed++;
        }
      }
    });
  }

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
        title: const Text('Serie A Predictions'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildStandingCard(),
              const SizedBox(height: 20),
              _buildPredictionsCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStandingCard() {
    return Card(
      elevation: 8,
      child: Column(
        children: [
          Container(
            color: Colors.blue.shade900,
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'My Standing Serie A',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                CircleAvatar(
                  backgroundColor: Colors.blue.shade500,
                  radius: 25,
                  child: Text(
                    '#${userStats['position']}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatBox('Position', userStats['position'].toString()),
                    _buildStatBox('Matches', userStats['matches'].toString()),
                    _buildStatBox(
                        'Points', userStats['totalPoints'].toString()),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'My Last Week - Matchday ${userStats['currentMatchday']}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatBox(
                      'Guessed',
                      userStats['lastWeek']['guessed'].toString(),
                    ),
                    _buildStatBox(
                      'Position',
                      userStats['lastWeek']['position'].toString(),
                    ),
                    _buildStatBox(
                      'Points',
                      userStats['lastWeek']['points'].toString(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPredictionsCard() {
    return Card(
      elevation: 8,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            color: Colors.green.shade600,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text(
                  'PUT PREDICTIONS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Time remaining: ${_formatDuration(_timeUntilCutoff)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Double chances remaining: ${maxDoubleChances - doubleChancesUsed}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          if (_timeUntilCutoff != null)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: matches.length,
              itemBuilder: (context, index) => _buildMatchCard(matches[index]),
            )
          else
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Predictions are closed for this matchday',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatBox(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: Colors.blue.shade900,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchCard(Map<String, dynamic> match) {
    final bool isSelected = match['selectedPrediction'] != null;
    final String matchId = match['id'];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  match['homeTeam'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
              Expanded(
                child: Text(
                  ' vs ',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  match['awayTeam'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${match['date']} ${match['kickoffTime']}',
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 12),

          // Single predictions row
          Row(
            children: [
              _buildPredictionButton(
                matchId: matchId,
                label: '1',
                prediction: '1',
                isSelected: match['selectedPrediction'] == '1',
                color: Colors.blue.shade500,
              ),
              const SizedBox(width: 8),
              _buildPredictionButton(
                matchId: matchId,
                label: 'X',
                prediction: 'X',
                isSelected: match['selectedPrediction'] == 'X',
                color: Colors.grey.shade500,
              ),
              const SizedBox(width: 8),
              _buildPredictionButton(
                matchId: matchId,
                label: '2',
                prediction: '2',
                isSelected: match['selectedPrediction'] == '2',
                color: Colors.red.shade500,
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Double chance row
          Row(
            children: [
              _buildDoubleChanceButton(
                matchId: matchId,
                label: '1X',
                prediction: '1X',
                isSelected: match['selectedPrediction'] == '1X',
              ),
              const SizedBox(width: 8),
              _buildDoubleChanceButton(
                matchId: matchId,
                label: '12',
                prediction: '12',
                isSelected: match['selectedPrediction'] == '12',
              ),
              const SizedBox(width: 8),
              _buildDoubleChanceButton(
                matchId: matchId,
                label: 'X2',
                prediction: 'X2',
                isSelected: match['selectedPrediction'] == 'X2',
              ),
            ],
          ),

          if (hasSubmittedPredictions && match['othersVisible']) ...[
            const SizedBox(height: 16),
            _buildPredictionsList(match['predictions']),
          ],
        ],
      ),
    );
  }

  Widget _buildPredictionButton({
    required String matchId,
    required String label,
    required String prediction,
    required bool isSelected,
    required Color color,
  }) {
    return Expanded(
      child: ElevatedButton(
        onPressed: _timeUntilCutoff != null
            ? () => _handlePrediction(matchId, prediction)
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? color.withOpacity(0.8) : color,
        ),
        child: Text(
          label,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildDoubleChanceButton({
    required String matchId,
    required String label,
    required String prediction,
    required bool isSelected,
  }) {
    final bool canUseDoubleChance =
        doubleChancesUsed < maxDoubleChances || isSelected;

    return Expanded(
      child: ElevatedButton(
        onPressed: _timeUntilCutoff != null && canUseDoubleChance
            ? () => _handleDoubleChance(matchId, prediction)
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isSelected ? Colors.purple.shade300 : Colors.purple.shade500,
        ),
        child: Text(
          label,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildPredictionsList(Map<String, dynamic> predictions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        const Text(
          'Other Players\' Predictions:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildPredictionTypeColumn('Capocannoniere', predictions['C']),
            _buildPredictionTypeColumn('Golden Boot', predictions['G']),
            _buildPredictionTypeColumn('MVP', predictions['V']),
            _buildPredictionTypeColumn('Legend', predictions['L']),
          ],
        ),
      ],
    );
  }

  Widget _buildPredictionTypeColumn(String title, List<String> predictions) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade900,
          ),
        ),
        const SizedBox(height: 4),
        ...predictions
            .map((pred) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text(
                    pred,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                    ),
                  ),
                ))
            .toList(),
        if (predictions.isEmpty)
          Text(
            'No predictions',
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
          ),
      ],
    );
  }
}
