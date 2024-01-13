import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_w10_d61_custom_painter/contants/gaps.dart';
import 'package:flutter_w10_d61_custom_painter/contants/sizes.dart';

class HomeScreenCustomPainter extends StatefulWidget {
  const HomeScreenCustomPainter({super.key});

  @override
  State<HomeScreenCustomPainter> createState() =>
      _HomeScreenCustomPainterState();
}

class _HomeScreenCustomPainterState extends State<HomeScreenCustomPainter>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: Duration(seconds: initialSeconds * tickMilliseconds ~/ 1000),
  );

  late final Animation<double> _progress =
      Tween(begin: 0.0, end: 2.0).animate(_animationController);

  final int initialSeconds = 600;
  late int totalSeconds = initialSeconds;

  // 1000 으로 하면 정상. 테스트를 위해, 100배 빠르게 설정. ( 100 = 1000 / 10 )
  final int tickMilliseconds = 10;

  bool isRunning = false;
  late Timer timer;

  void onTick(Timer timer) {
    print("${_animationController.value} / ${_progress.value}");
    if (totalSeconds == 0) {
      _onStopPressed();
    } else {
      setState(() {
        totalSeconds = totalSeconds - 1;
      });
    }
  }

  void _onStartPressed() {
    timer = Timer.periodic(
      Duration(milliseconds: tickMilliseconds),
      onTick,
    );

    setState(() {
      isRunning = true;
      _animationController.forward(
          from: (initialSeconds - totalSeconds) / initialSeconds);
    });
  }

  void _onPausePressed() {
    timer.cancel();

    setState(() {
      isRunning = false;
      _animationController.stop();
    });
  }

  void _onResetPressed() {
    setState(() {
      totalSeconds = initialSeconds;
      _animationController.forward(
          from: (initialSeconds - totalSeconds) / initialSeconds);
    });
  }

  void _onStopPressed() {
    setState(() {
      totalSeconds = initialSeconds;
      _animationController.value = 0.0;
      _onPausePressed();
    });
  }

  String formatTime(int seconds) {
    var duration = Duration(seconds: seconds);
    return duration.toString().split(".").first.substring(2, 7);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Flexible(
            child: Container(),
          ),
          Flexible(
              child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedBuilder(
                animation: _progress,
                builder: (context, child) => CustomPaint(
                  size: Size(
                    MediaQuery.of(context).size.width * 0.8,
                    MediaQuery.of(context).size.width * 0.8,
                  ),
                  painter: ArcPainter(
                    context: context,
                    progress: _progress.value,
                  ),
                ),
              ),
              Text(
                formatTime(totalSeconds),
                style: const TextStyle(
                  fontSize: Sizes.size60,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          )),
          Flexible(
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: _onResetPressed,
                    padding: const EdgeInsets.all(Sizes.size10),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(Colors.grey.shade200),
                    ),
                    icon: const Icon(
                      Icons.restart_alt,
                      color: Colors.grey,
                      size: Sizes.size28,
                    ),
                  ),
                  Gaps.h20,
                  IconButton(
                    onPressed: isRunning ? _onPausePressed : _onStartPressed,
                    padding: const EdgeInsets.all(Sizes.size24),
                    style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(
                          Theme.of(context).primaryColor),
                    ),
                    icon: Icon(
                      isRunning
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: Sizes.size52,
                    ),
                  ),
                  Gaps.h20,
                  IconButton(
                    onPressed: _onStopPressed,
                    padding: const EdgeInsets.all(Sizes.size10),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(Colors.grey.shade200),
                    ),
                    icon: const Icon(
                      Icons.stop_rounded,
                      color: Colors.grey,
                      size: Sizes.size28,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ArcPainter extends CustomPainter {
  final BuildContext context;
  final double progress;

  ArcPainter({
    required this.context,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(
      size.width / 2,
      size.height / 2,
    );

    const startingAngle = -0.5 * pi;

    final circlePaint = Paint()
      ..color = Colors.grey.shade200
      ..style = PaintingStyle.stroke
      ..strokeWidth = Sizes.size24;

    final circleRadius = size.width / 2;

    canvas.drawCircle(
      center,
      circleRadius,
      circlePaint,
    );

    final arcRect = Rect.fromCircle(
      center: center,
      radius: circleRadius,
    );

    final arcPainter = Paint()
      ..color = Theme.of(context).primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = Sizes.size24
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      arcRect,
      startingAngle,
      progress * pi,
      false,
      arcPainter,
    );
    //
    //
  }

  @override
  bool shouldRepaint(covariant ArcPainter oldDelegate) {
    return true;
  }
}
