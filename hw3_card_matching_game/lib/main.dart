import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';

// The main function is the entry point of the application.
void main() {
  runApp(
    // ChangeNotifierProvider is used for state management in the app.
    ChangeNotifierProvider(
      create: (context) => GameProvider(), // Provides the GameProvider to the widget tree.
      child: MyApp(),
    ),
  );
}

// The main widget of the application.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Card Matching Game', // Title of the application.
      theme: ThemeData(primarySwatch: Colors.blue), // Sets the theme color.
      home: GameScreen(), // The home screen of the app is GameScreen.
    );
  }
}

// The main screen for the game, which is stateful.
class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState(); // Creates the state for GameScreen.
}

// The state class for GameScreen, which manages the game state.
class _GameScreenState extends State<GameScreen> {
  late Timer timer; // Timer for tracking elapsed time.
  int timeElapsed = 0; // Tracks time elapsed in seconds.
  bool isGameOver = false; // Flag to check if the game is over.

  @override
  void initState() {
    super.initState();
    startTimer(); // Starts the timer when the screen is initialized.
  }

  // Function to start a periodic timer that increments timeElapsed.
  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!isGameOver) { // Only update if the game is not over.
        setState(() {
          timeElapsed++; // Increment the elapsed time.
        });
      }
    });
  }

  @override
  void dispose() {
    timer.cancel(); // Cancel the timer when the widget is disposed.
    super.dispose();
  }

  // Function to check if the player has won the game.
  void checkWinCondition(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    // Check if all cards are face up.
    if (gameProvider.cards.every((card) => card.isFaceUp)) {
      // Show victory message
      setState(() {
        isGameOver = true; // Set the game as over.
      });
      timer.cancel(); // Stop the timer.
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('You Win!'), // Title of the dialog.
          content: Text('Your score: ${gameProvider.score}\nTime taken: $timeElapsed seconds'), // Victory message with score and time.
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog.
                restartGame(); // Restart the game logic.
              },
              child: Text('Restart'), // Button to restart the game.
            ),
          ],
        ),
      );
    }
  }

  // Function to restart the game.
  void restartGame() {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    setState(() {
      gameProvider.resetGame(); // Reset the game state.
      timeElapsed = 0; // Reset the timer.
      isGameOver = false; // Reset game over status.
      timer.cancel(); // Stop any running timer.
      startTimer(); // Restart the timer.
    });
  }

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Card Matching Game'), // App bar title.
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text('Score: ${gameProvider.score}'), // Display current score in the app bar.
            ),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Time Elapsed: $timeElapsed seconds', // Display the timer.
              style: TextStyle(fontSize: 18),
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, // Defines a grid with 4 columns.
              ),
              itemBuilder: (context, index) {
                return FlipCard(
                  isFaceUp: gameProvider.cards[index].isFaceUp, // Card's current state (face up or down).
                  frontDesign: gameProvider.cards[index].frontDesign, // Card's front design.
                  backDesign: gameProvider.cards[index].backDesign, // Card's back design.
                  onTap: () {
                    gameProvider.flipCard(index); // Flip the card on tap.
                    checkWinCondition(context); // Check for win condition after flipping.
                  },
                );
              },
              itemCount: gameProvider.cards.length, // Number of cards in the game.
            ),
          ),
        ],
      ),
    );
  }
}

// CardModel represents a single card in the game.
class CardModel {
  final String frontDesign; // Design shown when the card is face up.
  final String backDesign; // Design shown when the card is face down.
  bool isFaceUp; // Flag to indicate if the card is face up.

  CardModel({required this.frontDesign, required this.backDesign, this.isFaceUp = false}); // Constructor for CardModel.
}

// GameProvider manages the state of the game.
class GameProvider with ChangeNotifier {
  List<CardModel> cards = []; // List to hold all the cards in the game.
  int score = 0; // Player's score.
  List<int> selectedCardIndices = []; // Stores indices of currently selected cards.
  bool isCheckingMatch = false; // Flag to check if a match is being evaluated.

  GameProvider() {
    initializeCards(); // Initialize cards when the provider is created.
  }

  // Function to initialize the cards.
  void initializeCards() {
    // Create pairs of cards.
    List<String> designs = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];
    for (var design in designs) {
      cards.add(CardModel(frontDesign: design, backDesign: 'Card', isFaceUp: false)); // Add first card of the pair.
      cards.add(CardModel(frontDesign: design, backDesign: 'Card', isFaceUp: false)); // Add second card of the pair.
    }
    cards.shuffle(); // Shuffle the cards randomly.
  }

  // Function to flip a card at the specified index.
  void flipCard(int index) {
    // Prevent flipping if a match is being checked or the card is already face up.
    if (isCheckingMatch || cards[index].isFaceUp) return;

    cards[index].isFaceUp = true; // Set the card as face up.
    notifyListeners(); // Notify listeners to update the UI.

    selectedCardIndices.add(index); // Add the index of the flipped card.

    // Check for matches if two cards are selected.
    if (selectedCardIndices.length == 2) {
      isCheckingMatch = true; // Set flag to indicate a match check is in progress.
      checkMatch(selectedCardIndices[0], selectedCardIndices[1]); // Check if the two selected cards match.
    }
  }

  // Function to check if the two selected cards match.
  void checkMatch(int firstIndex, int secondIndex) {
    // If they match, increase the score and clear selected indices.
    if (cards[firstIndex].frontDesign == cards[secondIndex].frontDesign) {
      score += 10; // Increase score for a match.
      selectedCardIndices.clear(); // Clear the list of selected card indices.
      isCheckingMatch = false; // Reset the match checking flag.
      notifyListeners(); // Notify UI to update the score.
    } else {
      // If they don't match, hide both cards after a delay.
      Future.delayed(Duration(seconds: 1), () {
        cards[firstIndex].isFaceUp = false; // Hide the first card.
        cards[secondIndex].isFaceUp = false; // Hide the second card.
        selectedCardIndices.clear(); // Clear the selected indices.
        isCheckingMatch = false; // Reset the match checking flag.
        notifyListeners(); // Notify UI to update.

        // Decrease score for an incorrect match.
        if (score > 0) {
          score -= 1; // Deduct score if there's an incorrect match.
        }
      });
    }
  }

  // Function to reset the game state.
  void resetGame() {
    score = 0; // Reset the score to zero.
    selectedCardIndices.clear(); // Clear the list of selected card indices.
    isCheckingMatch = false; // Reset the match checking flag.

    // Clear existing cards and re-initialize.
    cards.clear(); // Clear existing cards.
    initializeCards(); // Create a new set of cards.
    notifyListeners(); // Notify the UI to update.
  }
}

// FlipCard is a stateless widget that represents a single card.
class FlipCard extends StatelessWidget {
  final bool isFaceUp; // Indicates if the card is face up.
  final String frontDesign; // The front design of the card.
  final String backDesign; // The back design of the card.
  final Function onTap; // Function to call when the card is tapped.

  FlipCard({
    required this.isFaceUp,
    required this.frontDesign,
    required this.backDesign,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(), // Call the onTap function when the card is tapped.
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300), // Animation duration for flipping.
        decoration: BoxDecoration(
          color: isFaceUp ? Colors.white : Colors.blue, // Change color based on card state.
          borderRadius: BorderRadius.circular(10), // Rounded corners.
          boxShadow: [
            BoxShadow(
              color: Colors.black26, // Shadow color.
              blurRadius: 6, // Blur radius for shadow.
              offset: Offset(0, 3), // Offset for shadow.
            ),
          ],
        ),
        alignment: Alignment.center, // Center align the content.
        child: Center(
          child: Text(
            isFaceUp ? frontDesign : backDesign, // Show front or back design based on the state.
            style: TextStyle(
              fontSize: 24, // Font size for the card text.
              fontWeight: FontWeight.bold, // Bold text.
              color: isFaceUp ? Colors.black : Colors.white, // Change text color based on state.
            ),
          ),
        ),
      ),
    );
  }
}
