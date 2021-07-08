import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: Calc(),
    );
  }
}

class Calc extends StatefulWidget {
  Calc({Key key}) : super(key: key);

  @override
  _CalcState createState() => _CalcState();
}

class _CalcState extends State<Calc> {
  String _expression = "0";
  String _history1 = "";
  String _history2 = "";
  String _history3 = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Spacer(),
          historyWidget(4, _history3),
          historyWidget(5, _history2),
          historyWidget(6, _history1),
          historyWidget(7, _expression),
          Container(
            color: Colors.blueGrey,
            height: 2,
            width: MediaQuery.of(context).size.width * 0.90,
          ),
          Expanded(
            flex: 25,
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      calcButton("C", Colors.orange),
                      calcButton("⌫", Colors.orange),
                      calcButton("%", Colors.orange),
                      calcButton("÷", Colors.orange),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      calcButton("7", Colors.white),
                      calcButton("8", Colors.white),
                      calcButton("9", Colors.white),
                      calcButton("×", Colors.orange),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      calcButton("4", Colors.white),
                      calcButton("5", Colors.white),
                      calcButton("6", Colors.white),
                      calcButton("-", Colors.orange),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      calcButton("1", Colors.white),
                      calcButton("2", Colors.white),
                      calcButton("3", Colors.white),
                      calcButton("+", Colors.orange),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      calcButton("000", Colors.white),
                      calcButton("0", Colors.white),
                      calcButton(".", Colors.white),
                      calcButton("=", Colors.yellow),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget historyWidget(historyFlex, text) {
    return Expanded(
      flex: historyFlex,
      child: GestureDetector(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.90,
          child: FittedBox(
            alignment: Alignment.bottomRight,
            fit: BoxFit.contain,
            child: Text(text, style: GoogleFonts.lato()),
          ),
        ),
        onTap: () {
          setState(() {
            _expression = text;
          });
        },
      ),
    );
  }

  Widget calcButton(buttonText, buttonColor) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        child: Text(
          buttonText,
          textAlign: TextAlign.center,
          style: GoogleFonts.lato(
            textStyle: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: buttonColor),
          ),
        ),
        onTap: () {
          buttonPressed(buttonText);
        },
      ),
    );
  }

  void buttonPressed(buttonText) {
    setState(() {
      if (buttonText == "C") {
        if (_expression == "0") {
          _history1 = "";
          _history2 = "";
          _history3 = "";
        } else {
          _expression = "0";
        }
      } else if (buttonText == "⌫") {
        if (_expression.length > 1) {
          _expression = _expression.substring(0, _expression.length - 1);
        } else {
          _expression = "0";
        }
      } else if (buttonText == "%") {
        try {
          _expression = (double.parse(_expression) * 0.01).toString();
        } catch (e) {
          print("ERROR");
        }
      } else if (buttonText == "=") {
        _expression = _expression.replaceAll('×', '*');
        _expression = _expression.replaceAll('÷', '/');

        Parser p = Parser();
        Expression exp = p.parse(_expression);
        ContextModel cm = ContextModel();
        try {
          _expression = exp.evaluate(EvaluationType.REAL, cm).toString();
          _history3 = _history2;
          _history2 = _history1;
          _history1 = _expression;
          _expression = "0";
        } catch (e) {
          print("EXP ERROR");
        }
      } else {
        if (_expression == "0") {
          _expression = buttonText;
        } else {
          _expression += buttonText;
        }
      }
    });
  }
}
