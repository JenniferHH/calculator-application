import 'package:flutter/material.dart';

void main() => runApp(CalculatorApp());

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  void _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 5));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => CalculatorView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedLogo(),
      ),
    );
  }
}

class AnimatedLogo extends StatefulWidget {
  const AnimatedLogo({super.key});

  @override
  State<AnimatedLogo> createState() => _AnimatedLogoState();
}

class _AnimatedLogoState extends State<AnimatedLogo> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    )..repeat(reverse: true);
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: const Image(
        image: AssetImage('assets/logo.png'),
        width: 500.0,
      ),
    );
  }
}
class CalculatorView extends StatefulWidget {
  @override
  _CalculatorViewState createState() => _CalculatorViewState();
}

class _CalculatorViewState extends State<CalculatorView> {
  String _output = "0";
  String _input = "";
  List<double> _numbers = [];
  List<String> _operators = [];

  void _buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "C") {
        _input = "";
        _output = "0";
        _numbers.clear();
        _operators.clear();
      } else if (buttonText == "=") {
        if (_input.isNotEmpty) {
          _numbers.add(double.tryParse(_input) ?? 0.0);
          _input = "";

          double result = _calculate();
          _output = result.toString();
          _numbers.clear();
          _operators.clear();
        }
      } else if (["+", "-", "*", "/"].contains(buttonText)) {
        if (_input.isNotEmpty) {
          _numbers.add(double.tryParse(_input) ?? 0.0);
          _input = "";
        }
        _operators.add(buttonText);
      } else if (buttonText == "CE") {
        if (_input.isNotEmpty) {
          _input = _input.substring(0, _input.length - 1);
          _output = _input.isEmpty ? "0" : _input;
        }
      } else if (_output.length == 8) {
        _output = "ERROR";
      } else if (_output == "ERROR"){
        _output == 0;
      }
      else {
        _input += buttonText;
        _output = _input;
      }

    });
  }

  double _calculate() {
    if (_numbers.isEmpty) return 0.0;

    double result = _numbers[0];

    for (int i = 0; i < _operators.length; i++) {
      String operator = _operators[i];
      double nextNumber = _numbers[i + 1];

      switch (operator) {
        case "*":
          result *= nextNumber;
          break;
        case "/":
          if (nextNumber != 0) {
            result /= nextNumber;
          } else {
            result = double.infinity;
          }
          break;
        case "+":
          result += nextNumber;
          break;
        case "-":
          result -= nextNumber;
          break;
      }
    }

    return result;
  }


  Widget _buildButton(String buttonText) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () => _buttonPressed(buttonText),
        child: Text(
          buttonText,
          style: TextStyle(fontSize: 20.0),
        ),
    style: ElevatedButton.styleFrom(
           backgroundColor: Colors.amber,
           foregroundColor: Colors.black,
            fixedSize: Size(105.0, 105.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
         ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(50.0),
            alignment: Alignment.centerRight,
            child: Text(
              _output,
              style: TextStyle(
                  fontSize: 50.0,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: Divider(
              color: Colors.black,

            ),
          ),
          Column(
            children: [
              Row(
                children: <Widget>[
                  _buildButton("7"),
                  _buildButton("8"),
                  _buildButton("9"),
                  _buildButton("/"),
                ],
              ),
              Row(
                children: <Widget>[
                  _buildButton("4"),
                  _buildButton("5"),
                  _buildButton("6"),
                  _buildButton("*"),
                ],
              ),
              Row(
                children: <Widget>[
                  _buildButton("1"),
                  _buildButton("2"),
                  _buildButton("3"),
                  _buildButton("-"),
                ],
              ),
              Row(
                children: <Widget>[
                  _buildButton("CE"),
                  _buildButton("0"),
                  _buildButton("C"),
                  _buildButton("+"),
                ],
              ),
              Row(
                children: <Widget>[
                  _buildButton("="),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
