import 'dart:async';
import 'package:flutter/material.dart';

import '../controllers/game_controller.dart';
import '../widgets/brightpick_app_bar.dart';
import '../widgets/game_info_panel.dart';
import '../widgets/warehouse_grid.dart';
import '../widgets/robot_controls.dart';
import '../widgets/ai_insight_panel.dart';
import '../widgets/performance_panel.dart';

class WarehouseGamePage extends StatefulWidget {
  const WarehouseGamePage({super.key});

  @override
  State<WarehouseGamePage> createState() => _WarehouseGamePageState();
}

class _WarehouseGamePageState extends State<WarehouseGamePage> {
  final GameController game = GameController();
  Timer? aiTimer;

  @override
  void initState() {
    super.initState();

    aiTimer = Timer.periodic(
      const Duration(milliseconds: 450),
          (_) {
        if (game.aiModeEnabled) {
          setState(() {
            game.runAiStep();
          });
        }
      },
    );
  }

  @override
  void dispose() {
    aiTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BrightPickAppBar(game: game),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: Column(
                  children: [
                    GameInfoPanel(game: game),
                    const SizedBox(height: 16),
                    Expanded(
                      child: WarehouseGrid(game: game),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              SizedBox(
                width: 280,
                child: Column(
                  children: [
                    const SizedBox(height: 80),
                    RobotControls(
                      aiEnabled: game.aiModeEnabled,
                      onToggleAi: () {
                        setState(() {
                          game.toggleAiMode();
                        });
                      },
                      onMoveUp: () {
                        setState(() {
                          game.moveRobot(-1, 0);
                        });
                      },
                      onMoveDown: () {
                        setState(() {
                          game.moveRobot(1, 0);
                        });
                      },
                      onMoveLeft: () {
                        setState(() {
                          game.moveRobot(0, -1);
                        });
                      },
                      onMoveRight: () {
                        setState(() {
                          game.moveRobot(0, 1);
                        });
                      },
                      onReset: () {
                        setState(() {
                          game.reset();
                        });
                      },
                    ),
                    const SizedBox(height: 24),
                    PerformancePanel(game: game),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}