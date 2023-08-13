import 'package:all_flutter_testing/color.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  var _input = "";
  var _output = "";

  // save state ke shared preferences
  _loadState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _input = prefs.getString('input') ?? "";
      _output = prefs.getString('output') ?? "";
    });
  }

  // menyimpan data ke shared preferences
  _saveCalcState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("input", _input);
    await prefs.setString("output", _output);
  }

  onButtonClick(value) {
    if (value == "C") {
      _input = "";
      _output = "";
    } else if (value == "<") {
      if (_input.isNotEmpty) {
        _input = _input.substring(0, _input.length - 1);
      }
    } else if (value == "=") {
      var userInput = _input;
      userInput = _input.replaceAll("x", "*");
      Parser p = Parser();
      Expression expression = p.parse(userInput);
      ContextModel cm = ContextModel();
      var finalValue = expression.evaluate(EvaluationType.REAL, cm);
      _output = finalValue.toString();
      // menghilangkan koma belakang angka
      if (_output.endsWith(".0")) {
        _output = _output.substring(0, _output.length - 2);
      }
    } else if (value == "00" && _input.isEmpty) {
      _input = _input.replaceAll("00", "");
    } else {
      _input = _input + value;
    }
    setState(() {
      _saveCalcState(); //shared prefs function
    });
  }

  @override
  void initState() {
    _loadState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // input output area
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _input,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 226, 222, 222),
                      fontSize: 25,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    child: Text(
                      _output,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
          // button area
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                topLeft: Radius.circular(20),
              ),
              color: bgColor,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    wBuildButton(
                      bText: "C",
                      tBgColor: bColorTopSide,
                    ),
                    wBuildButton(bText: "<", tBgColor: bColorTopSide),
                    wBuildButton(bText: "%", tBgColor: bColorTopSide),
                    wBuildButton(bText: "/", tBgColor: bColorRightSide),
                  ],
                ),
                Row(
                  children: [
                    wBuildButton(bText: "7"),
                    wBuildButton(bText: "8"),
                    wBuildButton(bText: "9"),
                    wBuildButton(bText: "x", tBgColor: bColorRightSide),
                  ],
                ),
                Row(
                  children: [
                    wBuildButton(bText: "4"),
                    wBuildButton(bText: "5"),
                    wBuildButton(bText: "6"),
                    wBuildButton(bText: "-", tBgColor: bColorRightSide),
                  ],
                ),
                Row(
                  children: [
                    wBuildButton(bText: "1"),
                    wBuildButton(bText: "2"),
                    wBuildButton(bText: "3"),
                    wBuildButton(bText: "+", tBgColor: bColorRightSide),
                  ],
                ),
                Row(
                  children: [
                    wBuildButton(bText: "00"),
                    wBuildButton(bText: "0"),
                    wBuildButton(bText: ".", tBgColor: bColorRightSide),
                    wBuildButton(bText: "=", tBgColor: bColorRightSide),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget wBuildButton({
    bText,
    tBgColor = Colors.white,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(12),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            onPrimary: Colors.red,
            primary: bColor,
            padding: const EdgeInsets.all(20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () => onButtonClick(bText),
          child: Text(
            bText,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: tBgColor,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}
