import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'random_word.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _textController = TextEditingController();// to handle the input field content
  final FocusNode _focusNode = FocusNode(); // To make keyboard always focus on Input

  final List<String> _guesses = [];
  RandomWord wordGenerator = RandomWord();
  late String _targetWord; // Declare but don't initialize until initState() because we cant

  int _attempts = 0;
  bool _gameOver = false;
  String _feedbackMessage = 'Enter your guess to start the game!';


  @override
  void initState() {
    super.initState();
    _targetWord = wordGenerator.getWord(); // Initialize the word here
  }

  //Improves history Interface for feedback
  List<Color> _getFeedbackColors(String guess) {
    List<Color> feedbackColors = List<Color>.filled(5, Colors.grey);//All incorrect initial state
    List<bool> targetUsed = List<bool>.filled(5, false);

    //correct case
    for (int i = 0; i < guess.length; i++) {
      if (guess[i] == _targetWord[i]) {
        feedbackColors[i] = Colors.green;
        targetUsed[i] = true;
      }
    }

    //misplaced case
    for (int i = 0; i < guess.length; i++) {
      if (feedbackColors[i] != Colors.green) {
        for (int j = 0; j < _targetWord.length; j++) {
          if (!targetUsed[j] && guess[i] == _targetWord[j]) {
            feedbackColors[i] = Colors.yellow;
            targetUsed[j] = true;
            break;
          }
        }
      }
    }

    return feedbackColors;
  }

  //Submission Function implement to be able to use Enter key as submit
  void _submitGuess() {
    final userGuess = _textController.text.toUpperCase();
    if (userGuess.length == 5) {
      setState(() {
        _guesses.add(userGuess);
        _attempts++;
        if (userGuess == _targetWord) {
          _feedbackMessage = 'Congratulations! You guessed the word!';
          _gameOver = true;
        } else if (_attempts >= 6) {
          _feedbackMessage = 'Game Over! The word was $_targetWord.';
          _gameOver = true;
        } else {
          _feedbackMessage = 'Incorrect guess: $userGuess';
        }
      });

      _textController.clear(); // Clear the input field
      _focusNode.requestFocus(); // Refocus the input field
    } else {
      setState(() {
        _feedbackMessage = 'Please enter a 5-letter word.';
      });
      _focusNode.requestFocus(); // Ensure focus remains on the text field
    }
  }


  // Reset the game state
  void _resetGame() {
    setState(() {
      _guesses.clear();
      _attempts = 0;
      _gameOver = false;
      _feedbackMessage = 'Enter your guess to start the game!';
      _textController.clear();
      _targetWord = wordGenerator.getWord();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Wordle',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          // Attempts Counter
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Attempts: $_attempts / 6',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          // Feedback Message
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              _feedbackMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
          ),

          // Guess History (Centered)
          Expanded(
            child: Center(
              child: _guesses.isEmpty
                  ? const Text(
                'Guess history will appear here',
                style: TextStyle(fontSize: 18),
              )
                  : ListView.builder(//to create a scrollable array
                shrinkWrap: true,
                itemCount: _guesses.length,
                itemBuilder: (context, index) {
                  final guess = _guesses[index];
                  final feedbackColors = _getFeedbackColors(guess);
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(guess.length, (i) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4.0),
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: feedbackColors[i], // Apply feedback color
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: Text(
                            guess[i],
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        );
                      }),
                    ),
                  );
                },
              ),
            ),
          ),

          // Input and Button
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 300,
              child: TextField(
                controller: _textController,
                focusNode: _focusNode,
                textAlign: TextAlign.center,
                enabled: !_gameOver,
                inputFormatters: [
                  TextInputFormatter.withFunction(
                    // to make the input always uppercase even if i don't press capslock
                        (oldValue, newValue) => TextEditingValue(
                      text: newValue.text.toUpperCase(),
                      selection: newValue.selection,
                    ),
                  ),
                ],
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter your guess',
                  hintText: 'Type a 5-letter word',
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                ),
                onSubmitted: (value) {
                  _submitGuess();
                },
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: ElevatedButton(
              onPressed: _gameOver
                  ? null // Disable button when the game is over
                  : () {
                final userGuess = _textController.text.toUpperCase();
                if (userGuess.length == 5) {
                  setState(() {
                    _guesses.add(userGuess);
                    _attempts++;
                    if (userGuess == _targetWord) {
                      _feedbackMessage = 'Congratulations! You guessed the word!';
                      _gameOver = true;
                    } else if (_attempts >= 6) {
                      _feedbackMessage = 'Game Over! The word was $_targetWord.';
                      _gameOver = true;
                    } else {
                      _feedbackMessage = 'Incorrect guess: $userGuess';
                    }
                  });

                  _textController.clear(); // Clear the input after every guess
                } else {
                  setState(() {
                    _feedbackMessage = 'Please enter a 5-letter word.';
                  });
                }
              },
              child: const Text('Submit Guess'),
            ),
          ),

          // Only show "Play Again" if the game is over
          if (_gameOver)
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: ElevatedButton(
                onPressed: _resetGame, // Call the reset function
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // Red color for reset
                ),
                child: const Text('Play Again',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
