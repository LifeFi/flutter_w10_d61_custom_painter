import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int initialSeconds = 1500;
  static const restingSeconds = 300;
  late int totalSeconds = initialSeconds;

  bool isRunning = false;
  bool isResting = false;
  int totalRounds = 0;
  int totalGoals = 0;
  late Timer timer;

  void onTick(Timer timer) {
    if (totalSeconds == 0) {
      setState(() {
        if (isResting) {
          isResting = false;
          totalSeconds = initialSeconds;
        } else {
          totalSeconds = initialSeconds;
          totalRounds = totalRounds + 1;
        }

        if (totalRounds == 4) {
          totalSeconds = restingSeconds;
          isResting = true;
          totalGoals = totalGoals + 1;
          if (totalRounds == 12) {
            totalSeconds = initialSeconds;
            totalRounds = 0;
            totalGoals = 0;
            _onPausePressed();
          }
          totalRounds = 0;
        }
      });
    } else {
      setState(() {
        totalSeconds = totalSeconds - 1;
      });
    }
  }

  void _onStartPressed() {
    timer = Timer.periodic(
      const Duration(milliseconds: 5), // 영상 녹화 위해 원래 주기 1초에서 변경.
      onTick,
    );
    setState(() {
      isRunning = true;
    });
  }

  void _onPausePressed() {
    timer.cancel();
    if (kDebugMode) {
      print(totalSeconds);
    }
    setState(() {
      isRunning = false;
    });
  }

  String formatMinutes(int seconds) {
    var duration = Duration(seconds: seconds);
    return duration.toString().split(".").first.substring(2, 4);
  }

  String formatSeconds(int seconds) {
    var duration = Duration(seconds: seconds);
    return duration.toString().split(".").first.substring(5, 7);
  }

  void _onPressInitalSeconds(int time) {
    initialSeconds = time * 60;
    _onPressReset();
  }

  void _onPressReset() {
    setState(() {
      totalSeconds = initialSeconds;
      totalRounds = 0;
      totalGoals = 0;
      isResting = false;
      _onPausePressed();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 55,
            ),
            const Flexible(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 40,
                ),
                child: SizedBox(
                  height: 600,
                  child: Text(
                    "POMOTIMER",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        top: -10,
                        left: 10,
                        child: Container(
                          height: 170,
                          width: 115,
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(7)),
                        ),
                      ),
                      Positioned(
                        top: -5,
                        left: 5,
                        child: Container(
                          height: 170,
                          width: 125,
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(7)),
                        ),
                      ),
                      Container(
                        height: 170,
                        width: 135,
                        alignment: const Alignment(0, 0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(7)),
                        child: Text(
                          formatMinutes(totalSeconds),
                          style: TextStyle(
                              fontSize: 70,
                              fontWeight: FontWeight.w700,
                              color: isResting
                                  ? Colors.blue
                                  : Theme.of(context).colorScheme.background),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 150,
                    width: 30,
                    alignment: const Alignment(0, 0),
                    child: Text(
                      ":",
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.w700,
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
                  ),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        top: -10,
                        left: 10,
                        child: Container(
                          height: 170,
                          width: 115,
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(7)),
                        ),
                      ),
                      Positioned(
                        top: -5,
                        left: 5,
                        child: Container(
                          height: 170,
                          width: 125,
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(7)),
                        ),
                      ),
                      Container(
                        height: 170,
                        width: 135,
                        alignment: const Alignment(0, 0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Text(
                          formatSeconds(totalSeconds),
                          style: TextStyle(
                              fontSize: 70,
                              fontWeight: FontWeight.w700,
                              color: isResting
                                  ? Colors.blue
                                  : Theme.of(context).colorScheme.background),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Flexible(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 30,
                ),
                child: Center(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (var time in [15, 20, 25, 30, 35])
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 7),
                            child: GestureDetector(
                              onTap: () => _onPressInitalSeconds(time),
                              child: Container(
                                height: 50,
                                width: 60,
                                alignment: const Alignment(0, 0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: time * 60 == initialSeconds
                                      ? Colors.white
                                      : null,
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.5),
                                    width: 3,
                                  ),
                                ),
                                child: Text(
                                  "$time",
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w600,
                                    color: time * 60 == initialSeconds
                                        ? Theme.of(context)
                                            .colorScheme
                                            .background
                                        : Colors.white.withOpacity(0.7),
                                  ),
                                ),
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 100,
                  ),
                  IconButton(
                      onPressed: isRunning ? _onPausePressed : _onStartPressed,
                      iconSize: 110,
                      color: Colors.white,
                      icon: Icon(isRunning
                          ? Icons.pause_circle_filled_sharp
                          : Icons.play_circle_sharp)),
                  IconButton(
                      onPressed: _onPressReset,
                      iconSize: 70,
                      color: Colors.white.withOpacity(0.5),
                      icon: const Icon(Icons.restore)),
                ],
              ),
            ),
            Flexible(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Text(
                          "$totalRounds/4",
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 25,
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "ROUND",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          "$totalGoals/12",
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 25,
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "GOAL",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    )
                  ],
                )),
          ],
        ));
  }
}
