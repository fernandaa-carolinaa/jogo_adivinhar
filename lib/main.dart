import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: SelectDifficultyPage(),
  ));
}

class SelectDifficultyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selecione a Dificuldade'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GuessNumberGame(difficulty: Difficulty.easy, minNumber: 1, maxNumber: 10)),
                );
              },
              child: Text('Fácil (1 - 10)'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GuessNumberGame(difficulty: Difficulty.medium, minNumber: 1, maxNumber: 100)),
                );
              },
              child: Text('Médio (1 - 100)'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GuessNumberGame(difficulty: Difficulty.hard, minNumber: 1, maxNumber: 1000)),
                );
              },
              child: Text('Difícil (1 - 1000)'),
            ),
          ],
        ),
      ),
    );
  }
}

enum Difficulty {
  easy,
  medium,
  hard,
}

class GuessNumberGame extends StatefulWidget {
  final Difficulty difficulty;
  final int minNumber;
  final int maxNumber;
  GuessNumberGame({required this.difficulty, required this.minNumber, required this.maxNumber});

  @override
  _GuessNumberGameState createState() => _GuessNumberGameState();
}

class _GuessNumberGameState extends State<GuessNumberGame> {
  late int _numeroAleatorio;
  late int _tentativas;
  late int _palpite;
  late String _feedback;

  @override
  void initState() {
    super.initState();
    _iniciarJogo();
  }

  void _iniciarJogo() {
    setState(() {
      Random random = Random();
      _numeroAleatorio = random.nextInt(widget.maxNumber - widget.minNumber + 1) + widget.minNumber;
      _tentativas = 0;
      _palpite = 0;
      _feedback = 'Tente adivinhar o número entre ${widget.minNumber} e ${widget.maxNumber}';
    });
  }

  void _adivinharNumero() {
    setState(() {
      _tentativas++;
      if (_palpite == _numeroAleatorio) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => WinScreen(attempts: _tentativas, onRestart: _iniciarJogo)),
        );
      } else if (_tentativas >= 5) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoseScreen(onRestart: _iniciarJogo)),
        );
      } else if (_palpite < _numeroAleatorio) {
        _feedback = 'Tente um número maior.';
      } else {
        _feedback = 'Tente um número menor.';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jogo da Adivinhação'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _feedback,
              style: TextStyle(fontSize: 20.0),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.0),
            TextField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _palpite = int.tryParse(value) ?? 0;
                });
              },
              decoration: InputDecoration(
                hintText: 'Digite seu palpite',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _adivinharNumero,
              child: Text('Adivinhar'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () => _iniciarJogo(),
              child: Text('Reiniciar Jogo'),
            ),
          ],
        ),
      ),
    );
  }
}

class WinScreen extends StatelessWidget {
  final int attempts;
  final VoidCallback onRestart;

  WinScreen({required this.attempts, required this.onRestart});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Você Ganhou!'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Parabéns! Você acertou em $attempts tentativas.',
              style: TextStyle(fontSize: 20.0),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: onRestart,
              child: Text('Reiniciar Jogo'),
            ),
          ],
        ),
      ),
    );
  }
}

class LoseScreen extends StatelessWidget {
  final VoidCallback onRestart;

  LoseScreen({required this.onRestart});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Você Perdeu!'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Você Perdeu!',
              style: TextStyle(fontSize: 20.0),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: onRestart,
              child: Text('Reiniciar Jogo'),
            ),
          ],
        ),
      ),
    );
  }
}
