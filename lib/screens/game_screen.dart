import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class GameScreen extends StatefulWidget {
  final String level;

  const GameScreen({super.key, required this.level});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int currentRoomIndex = 0;
  int? selectedRoomIndex;
  int anomalyCount = 0;
  int remainingTime = 300;
  int wrongReports = 0;
  late Timer _timer;
  late Timer _countdownTimer;

  bool showWarningMessage = false;
  int countdown = 10;
  int? currentAnomalyRoomIndex;
  Set<int> reportedRooms = {};
  Set<int> fixedAnomalyRooms = {};

  final List<Map<String, dynamic>> rooms = [
    {
      'name': 'Kitchen',
      'image': 'assets/kitchen.jpg',
      'original_image': 'assets/kitchen.jpg',
      'anomaly_images': ['assets/kitchen_anomaly1.jpg']
    },
    {
      'name': 'Bedroom',
      'image': 'assets/bedroom.jpg',
      'original_image': 'assets/bedroom.jpg',
      'anomaly_images': [
        'assets/bedroom_anomaly1.jpg',
        'assets/bedroom_anomaly2.jpg'
      ]
    },
    {
      'name': 'Bathroom',
      'image': 'assets/bathroom.jpg',
      'original_image': 'assets/bathroom.jpg',
      'anomaly_images': [
        'assets/bathroom_anomaly1.jpg',
        'assets/bathroom_anomaly2.jpg',
        'assets/bathroom_anomaly3.jpg'
      ]
    },
    {
      'name': 'Living Room',
      'image': 'assets/living_room.gif',
      'original_image': 'assets/living_room.gif',
      'anomaly_images': ['assets/livingroom_anomaly1.jpg']
    },
  ];

  @override
  void initState() {
    super.initState();
    _startTimer();
    _startCountdownForWarning();
  }

  @override
  void dispose() {
    _timer.cancel();
    _countdownTimer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (remainingTime > 0) {
          remainingTime--;
        } else {
          timer.cancel();
          _endGame();
        }
      });
    });
  }

  void _startCountdownForWarning() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (countdown > 0) {
          countdown--;
        } else {
          timer.cancel();
          _triggerRandomAnomaly();
        }
      });
    });
  }

  void _triggerRandomAnomaly() {
    final availableRooms = List.generate(rooms.length, (index) => index)
        .where((index) =>
            index != currentAnomalyRoomIndex &&
            !fixedAnomalyRooms.contains(index))
        .toList();

    if (availableRooms.isEmpty) {
      _showAllAnomaliesFoundDialog();
      return;
    }

    final random = Random();
    final newAnomalyRoomIndex =
        availableRooms[random.nextInt(availableRooms.length)];

    setState(() {
      currentAnomalyRoomIndex = newAnomalyRoomIndex;
      final anomalyImages = rooms[newAnomalyRoomIndex]['anomaly_images'];
      rooms[newAnomalyRoomIndex]['image'] =
          anomalyImages[random.nextInt(anomalyImages.length)];
    });
  }

  void _showAllAnomaliesFoundDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Congratulations!'),
        content: const Text('You have found all the anomalies!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  void _showWrongReportMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Wrong Report'),
          content: const Text('There was no anomaly in that room.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _endGame() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Game Over'),
          content: Text(wrongReports >= 2
              ? 'You made two wrong reports. Game over!'
              : 'Time is up!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showReportDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.6),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Report Anomaly',
                      style: TextStyle(
                        fontFamily: 'Digital7',
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...rooms.asMap().entries.map((entry) {
                      int index = entry.key;
                      String name = entry.value['name']!;
                      return CheckboxListTile(
                        title: Text(
                          name,
                          style: const TextStyle(
                            fontFamily: 'Digital7',
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        value: selectedRoomIndex == index,
                        onChanged: (bool? value) {
                          setDialogState(() {
                            selectedRoomIndex = value! ? index : null;
                          });
                        },
                      );
                    }),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              fontFamily: 'Digital7',
                              color: Colors.white,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: selectedRoomIndex != null
                              ? () {
                                  if (selectedRoomIndex ==
                                      currentAnomalyRoomIndex) {
                                    Navigator.pop(context);
                                    _simulateReportProcess();
                                  } else {
                                    wrongReports++;
                                    Navigator.pop(context);
                                    _showWrongReportMessage();
                                    if (wrongReports >= 2) {
                                      _endGame();
                                    }
                                  }
                                }
                              : null,
                          child: const Text(
                            'Send',
                            style: TextStyle(
                              fontFamily: 'Digital7',
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _simulateReportProcess() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FixingAnomalyScreen(
          onFixCompleted: (isAnomalyFixed) {
            setState(() {
              if (isAnomalyFixed && currentAnomalyRoomIndex != null) {
                anomalyCount++;
                fixedAnomalyRooms.add(currentAnomalyRoomIndex!);

                // Restore the room to its original state
                rooms[currentAnomalyRoomIndex!]['image'] =
                    rooms[currentAnomalyRoomIndex!]['original_image'];

                // Reset current anomaly tracking
                currentAnomalyRoomIndex = null;

                // Restart countdown for next anomaly
                countdown = 10;
                _startCountdownForWarning();
              }
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              rooms[currentRoomIndex]['image']!,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 10,
            left: 10,
            child: Text(
              'Level: ${widget.level}',
              style: const TextStyle(
                fontFamily: 'Digital7',
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: Text(
              'Anomalies Fixed: $anomalyCount',
              style: const TextStyle(
                fontFamily: 'Digital7',
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 10,
            child: Text(
              'Time Left: ${_formatTime(remainingTime)}',
              style: const TextStyle(
                fontFamily: 'Digital7',
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
          if (countdown > 0)
            Positioned(
              top: 50,
              left: 10,
              child: Text(
                'Warning: Anomaly will appear in $countdown seconds!',
                style: const TextStyle(
                  fontFamily: 'Digital7',
                  fontSize: 18,
                  color: Colors.red,
                ),
              ),
            ),
          Positioned(
            bottom: 10,
            right: 10,
            child: TextButton(
              onPressed: _showReportDialog,
              child: const Text(
                'Report',
                style: TextStyle(
                  fontFamily: 'Digital7',
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            left: 10,
            child: IconButton(
              icon: const Icon(Icons.arrow_left, color: Colors.white),
              onPressed: () {
                setState(() {
                  currentRoomIndex =
                      (currentRoomIndex - 1 + rooms.length) % rooms.length;
                });
              },
              iconSize: 40,
            ),
          ),
          Positioned(
            bottom: 100,
            right: 10,
            child: IconButton(
              icon: const Icon(Icons.arrow_right, color: Colors.white),
              onPressed: () {
                setState(() {
                  currentRoomIndex = (currentRoomIndex + 1) % rooms.length;
                });
              },
              iconSize: 40,
            ),
          ),
        ],
      ),
    );
  }
}

class FixingAnomalyScreen extends StatelessWidget {
  final Function(bool) onFixCompleted;

  const FixingAnomalyScreen({super.key, required this.onFixCompleted});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      onFixCompleted(true);
      Navigator.pop(context);
    });

    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text(
          'Fixing Anomaly...',
          style: TextStyle(
            fontFamily: 'Digital7',
            fontSize: 30,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
