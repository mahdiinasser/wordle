import 'dart:math';

class RandomWord {

  final List<String> _wordList = [
    'APPLE', 'BRAVE', 'CRANE', 'CRISP', 'CROWN', 'DEALS', 'DELTA', 'EAGER',
    'EARLY', 'EAGER', 'FLOOR', 'FRESH', 'GREEN', 'HAPPY', 'HEART', 'HONEY',
    'HOUSE', 'HURRY', 'LIGHT', 'LUCKY', 'MAGIC', 'MONEY', 'NICEY', 'NIGHT',
    'NORTH', 'PARTY', 'PEACE', 'PLANT', 'POWER', 'REACH', 'RIGHT', 'SHARE',
    'SLEEP', 'SPEED', 'STORM', 'STORY', 'STRIKE', 'STYLE', 'THINK', 'TRAIN',
  ];

  final Random _random = Random();


  String getWord() {
    int index = _random.nextInt(_wordList.length);
    return _wordList[index];
  }
}
