import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async'; // Import for Timer

void main() {
  runApp(const Digivice());
}

class Digivice extends StatelessWidget {
  const Digivice({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Digimon Pet',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: const DigiHomePage(),
    );
  }
}

class DigiHomePage extends StatefulWidget {
  const DigiHomePage({super.key});

  @override
  _DigiHomePageState createState() => _DigiHomePageState();
}

class _DigiHomePageState extends State<DigiHomePage> {
  // Digimon's stats
  int mood = 50;
  int hunger = 50;
  int energy = 50;
  int life = 100;
  int maxLife = 100;

  // Digimon's RPG stats
  int str = 10;
  int intelligence = 10;
  int dex = 10;
  int luck = 10;

  // Random number generator
  final Random random = Random();

  // Digimon's current evolution stage
  String evolutionStage = "Baby";
  bool hasEvolved = false;

  // Timer for updating stats
  Timer? timer;
  DateTime lastUpdateTime = DateTime.now();

  // Stat change limits
  static const int playMin = 1;
  static const int playMax = 3;
  static const int trainMin = 5;
  static const int trainMax = 10;
  static const int rookieMin = 2;
  static const int rookieMax = 10;
  static const int championMin = 5;
  static const int championMax = 20;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(minutes: 1), (Timer t) => updateStats());
  }

  // Update stats based on elapsed time
  void updateStats() {
    DateTime now = DateTime.now();
    Duration elapsed = now.difference(lastUpdateTime);
    lastUpdateTime = now;

    setState(() {
      // Decrease hunger and mood based on elapsed time
      hunger = (hunger - (elapsed.inMinutes * 2)).clamp(0, 100);
      mood = (mood - (elapsed.inMinutes * 1)).clamp(0, 100);

      // Regain life over time
      if (life < maxLife) {
        life = (life + (elapsed.inMinutes * 1)).clamp(0, maxLife);
      }

      // Check if hunger affects life
      if (hunger <= 0) {
        life = (life - (elapsed.inMinutes * 1)).clamp(0, maxLife);
      }
    });
  }

  // Helper method for random stat changes
  int randomStatChange(int min, int max) {
    return random.nextInt(max - min + 1) + min;
  }

  // Helper method for clamping
  int clampStat(int value, int min, int max) {
    return value.clamp(min, max);
  }

  // Digimon's Evolution Function
  void evolve() {
    if (!hasEvolved) {
      setState(() {
        if (mood > 80 && energy > 70) {
          evolutionStage = "Champion";
          str += randomStatChange(championMin, championMax);
          intelligence += randomStatChange(championMin, championMax);
          dex += randomStatChange(championMin, championMax);
          luck += randomStatChange(championMin, championMax);
          maxLife = 150;
        } else if (mood > 50 && energy > 50) {
          evolutionStage = "Rookie";
          str += randomStatChange(rookieMin, rookieMax);
          intelligence += randomStatChange(rookieMin, rookieMax);
          dex += randomStatChange(rookieMin, rookieMax);
          luck += randomStatChange(rookieMin, rookieMax);
        }
        hasEvolved = true;
      });
    }  
  }

  // Play function
  void play() {
    setState(() {
      mood = clampStat(mood + 10, 0, 100);
      hunger = clampStat(hunger - 5, 0, 100);
      energy -= 10;
      str += randomStatChange(playMin, playMax);
      dex += randomStatChange(playMin, playMax);
      evolve();
    });
  }

  // Feed function
  void feed() {
    setState(() {
      mood = clampStat(mood + 5, 0, 100);
      hunger = clampStat(hunger + 10, 0, 100);
      energy += 10;
    });
  }

  // Train function
  void train() {
    setState(() {
      if (mood > 0) {
        mood = clampStat(mood - 10, 0, 100);
        hunger = clampStat(hunger - 15, 0, 100);
        energy -= 15;
        str += randomStatChange(trainMin, trainMax);
        intelligence += randomStatChange(trainMin, trainMax);
        dex += randomStatChange(trainMin, trainMax);
        evolve();
      }
    });
  }

  // Reset function
  void reset() {
    setState(() {
      mood = 50;
      hunger = 50;
      energy = 50;
      life = 100;
      maxLife = 100;
      str = 1;
      intelligence = 1;
      dex = 1;
      luck = 1;
      evolutionStage = "Baby";
      hasEvolved = false; // Reset evolution state
    });
  }

  // Change of look depending on evolution stage and death
  Widget digimonImg() {
    if (life <= 0) {
      return Image.asset('assets/Death.png', height: 100, width: 100);
    } else {
      switch (evolutionStage) {
        case "Baby":
          return Image.asset('assets/Baby.webp', height: 100, width: 100);
        case "Rookie":
          return Image.asset('assets/Rookie.webp', height: 100, width: 100);
        case "Champion":
          return Image.asset('assets/Champion.jfif', height: 100, width: 100);
        default:
          return Image.asset('assets/Baby.webp', height: 100, width: 100);
      }
    }
  }

  @override
  void dispose() {
    timer?.cancel(); // Cancel the timer when disposing
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Digimon'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            digimonImg(),
            Text('Stage: $evolutionStage', style: theme.textTheme.headlineSmall),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text('Mood: $mood', style: theme.textTheme.bodyLarge),
                    Text('Hunger: $hunger', style: theme.textTheme.bodyLarge),
                    Text('HP: $life', style: theme.textTheme.bodyLarge),
                  ],
                ),
                const SizedBox(width: 40),
                Column(
                  children: [
                    Text('Strength: $str', style: theme.textTheme.bodyLarge),
                    Text('Intelligence: $intelligence', style: theme.textTheme.bodyLarge),
                    Text('Dexterity: $dex', style: theme.textTheme.bodyLarge),
                    Text('Luck: $luck', style: theme.textTheme.bodyLarge),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: theme.primaryColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: life > 0 ? play : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Play'),
              ),
              ElevatedButton(
                onPressed: life > 0 ? feed : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Feed'),
              ),
              ElevatedButton(
                onPressed: (life > 0 && mood > 0) ? train : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Train'),
              ),
              ElevatedButton(
                onPressed: reset,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Reset'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
