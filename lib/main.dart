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
        Container(
          height: MediaQuery.of(context).size.height * 0.05,
        ),
        historyWidget(0.06, _history3, 30.0),
        historyWidget(0.11, _history2, 35.0),
        historyWidget(0.13, _history1, 45.0),
        historyWidget(0.14, _expression, 55.0),
        Container(
          color: Colors.blueGrey,
          height: MediaQuery.of(context).size.height * 0.001,
          width: MediaQuery.of(context).size.width * 0.90,
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Row(
                children: [
                  calcButton("C", Colors.orange),
                  calcButton("⌫", Colors.orange),
                  calcButton("%", Colors.orange),
                  calcButton("÷", Colors.orange),
                ],
              ),
              Row(
                children: [
                  calcButton("7", Colors.white),
                  calcButton("8", Colors.white),
                  calcButton("9", Colors.white),
                  calcButton("×", Colors.orange),
                ],
              ),
              Row(
                children: [
                  calcButton("4", Colors.white),
                  calcButton("5", Colors.white),
                  calcButton("6", Colors.white),
                  calcButton("-", Colors.orange),
                ],
              ),
              Row(
                children: [
                  calcButton("1", Colors.white),
                  calcButton("2", Colors.white),
                  calcButton("3", Colors.white),
                  calcButton("+", Colors.orange),
                ],
              ),
              Row(
                children: [
                  calcButton("000", Colors.white),
                  calcButton("0", Colors.white),
                  calcButton(".", Colors.white),
                  calcButton("=", Colors.yellow),
                ],
              ),
            ],
          ),
        ),
      ],
    ));
  }

  Widget historyWidget(historyHeight, text, textSize) {
    return GestureDetector(
      child: Container(
        alignment: Alignment.bottomRight,
        height: MediaQuery.of(context).size.height * historyHeight,
        width: MediaQuery.of(context).size.width * 0.90,
        child: FittedBox(
          fit: BoxFit.cover,
          child: Text(text, style: GoogleFonts.lato(textStyle: TextStyle(fontSize: textSize))),
        ),
      ),
      onTap: () {
        setState(() {
          _expression = text;
        });
      },
    );
  }

  Widget calcButton(buttonText, buttonColor) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height * 0.10,
        width: MediaQuery.of(context).size.width * 0.25,
        child: Text(
          buttonText,
          style: GoogleFonts.lato(
            textStyle: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: buttonColor),
          ),
        ),
      ),
      onTap: () {
        buttonPressed(buttonText);
      },
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
        if (_expression.length > 0) {
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
