import 'package:flutter/material.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String displayText = '';
  List<String> calcLog = [];

  void addNumber(String number) {
    setState(() {
      final operators = ['+', '-', '×', '÷', '%'];

      // 전체 초기화
      if (number == 'C') {
        displayText = '';
        return;
      }

      // 백스페이스 기능
      if (number == 'BACKSPACE') {
        if (displayText.isNotEmpty) {
          if (displayText.contains("=")) {
            return;
          }

          displayText = displayText.substring(0, displayText.length - 1);
        }
        return;
      }

      // = 계산 처리
      if (number == '=') {
        if (displayText.isEmpty || displayText.contains("=")) return;

        try {
          String result = calculateExpression(displayText);
          displayText = displayText + '=' + result;
          calcLog.add(displayText);
        } catch (e) {
          displayText = 'Error';
        }
        return;
      }

      // 이미 계산 결과가 있는 상태에서 연산자 입력
      if (displayText.contains('=') && operators.contains(number)) {
        List<String> parts = displayText.split('=');
        if (parts.length == 2) {
          // 계산 결과를 새로운 시작점으로 사용
          displayText = parts[1] + number;
          return;
        }
      }

      // 이미 계산 결과가 있는 상태에서 숫자 입력 (새로운 계산 시작)
      if (displayText.contains('=') &&
          !operators.contains(number) &&
          number != '.') {
        displayText = number;
        return;
      }

      // 소수점 입력 시 앞에 숫자 필수
      if (number == '.') {
        if (displayText.isEmpty ||
            operators.contains(displayText[displayText.length - 1])) {
          displayText += '0.';
          return;
        }

        // 현재 숫자에 이미 소수점이 있는 경우 방지
        String lastOperand = displayText.split(RegExp(r'[+\-×÷]')).last;
        if (lastOperand.contains('.')) return;
      }

      // 숫자 0 입력 시 연속된 0 방지
      if (number == '0') {
        // 전체가 0일 때
        if (displayText == '0') return;

        // 연산자 뒤에 오는 숫자가 0일 때
        if (displayText.endsWith('0')) {
          String lastOperand = displayText.split(RegExp(r'[+\-×÷]')).last;
          if (lastOperand == '0') return;
        }
      } else {
        // 숫자 1-9 입력 시 앞에 0이 있으면 제거
        if (displayText.endsWith('0')) {
          String lastOperand = displayText.split(RegExp(r'[+\-×÷]')).last;
          if (lastOperand == '0') {
            displayText = displayText.substring(0, displayText.length - 1);
          }
        }
      }

      // 첫자리에 0 제한
      if (displayText == '' && number == '0') {
        displayText = '0';
        return;
      }

      // 연산자 입력 시
      if (operators.contains(number)) {
        if (displayText.isEmpty) return; // 숫자 없이 연산자 입력 방지
        String lastChar = displayText[displayText.length - 1];
        if (operators.contains(lastChar)) {
          // 마지막이 연산자면 덮어쓰기
          displayText =
              displayText.substring(0, displayText.length - 1) + number;
          return;
        }
      }

      // 일반 입력 추가
      displayText += number;
      print('calcLog : $calcLog');
    });
  }

  String calculateExpression(String expression) {
    // 간단한 계산기 로직 (사칙연산만)
    expression = expression.replaceAll('×', '*').replaceAll('÷', '/');

    // 정규식을 사용해서 숫자와 연산자 분리
    List<String> tokens = [];
    StringBuffer currentNumber = StringBuffer();

    // 연산자 분리 해서 tokens에 담기
    for (int i = 0; i < expression.length; i++) {
      String char = expression[i];
      if ('+-*/'.contains(char)) {
        if (currentNumber.isNotEmpty) {
          tokens.add(currentNumber.toString());
          currentNumber.clear();
        }
        tokens.add(char);
      } else {
        currentNumber.write(char);
      }
    }

    // 마지막 숫자 tokens에 추가
    if (currentNumber.isNotEmpty) {
      tokens.add(currentNumber.toString());
    }

    // 토큰이 3개 미만이면 계산 불가 (1+1 같이 최소 3자리 이어야 함)
    if (tokens.length < 3) return expression;

    // 곱셈, 나눗셈 먼저 계산
    for (int i = 1; i < tokens.length; i += 2) {
      if (tokens[i] == '*' || tokens[i] == '/') {
        double left = double.parse(tokens[i - 1]);
        double right = double.parse(tokens[i + 1]);
        double result = tokens[i] == '*' ? left * right : left / right;

        tokens[i - 1] = result.toString();
        tokens.removeAt(i);
        tokens.removeAt(i);
        i -= 2;
      }
    }

    // 덧셈, 뺄셈 계산
    for (int i = 1; i < tokens.length; i += 2) {
      if (tokens[i] == '+' || tokens[i] == '-') {
        double left = double.parse(tokens[i - 1]);
        double right = double.parse(tokens[i + 1]);
        double result = tokens[i] == '+' ? left + right : left - right;

        tokens[i - 1] = result.toString();
        tokens.removeAt(i);
        tokens.removeAt(i);
        i -= 2;
      }
    }

    double finalResult = double.parse(tokens[0]);
    return finalResult == finalResult.toInt()
        ? finalResult.toInt().toString()
        : finalResult.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('계산기'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        toolbarHeight: 40,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              height: 90,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  displayText.isEmpty ? '0' : displayText,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                NumberButton(btnText: 'C', onPressed: addNumber),
                const SizedBox(width: 80, height: 80), // 빈 공간
                NumberButton(btnText: '%', onPressed: addNumber),
                NumberButton(btnText: '+', onPressed: addNumber),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                NumberButton(btnText: '1', onPressed: addNumber),
                NumberButton(btnText: '2', onPressed: addNumber),
                NumberButton(btnText: '3', onPressed: addNumber),
                NumberButton(btnText: '-', onPressed: addNumber),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                NumberButton(btnText: '4', onPressed: addNumber),
                NumberButton(btnText: '5', onPressed: addNumber),
                NumberButton(btnText: '6', onPressed: addNumber),
                NumberButton(btnText: '×', onPressed: addNumber),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                NumberButton(btnText: '7', onPressed: addNumber),
                NumberButton(btnText: '8', onPressed: addNumber),
                NumberButton(btnText: '9', onPressed: addNumber),
                NumberButton(btnText: '÷', onPressed: addNumber),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                NumberButton(btnText: '0', onPressed: addNumber),
                NumberButton(btnText: '.', onPressed: addNumber),
                BackspaceButton(onPressed: () => addNumber('BACKSPACE')),
                NumberButton(btnText: '=', onPressed: addNumber),
              ],
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      bottomNavigationBar: const BottomAppBar(
        height: 40.0,
        color: Colors.green,
        child: SizedBox(height: 10.0),
      ),
    );
  }
}

class NumberButton extends StatelessWidget {
  final String btnText;
  final Function(String) onPressed;

  const NumberButton({
    super.key,
    required this.btnText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(2),
      child: ElevatedButton(
        onPressed: () => onPressed(btnText),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(80, 80),
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(20),
          backgroundColor: Colors.blueAccent,
          elevation: 5,
          shadowColor: Colors.grey,
          side: const BorderSide(color: Colors.white, width: 2),
        ),
        child: Text(
          btnText,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class BackspaceButton extends StatelessWidget {
  final VoidCallback onPressed;

  const BackspaceButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(2),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(80, 80),
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(20),
          backgroundColor: Colors.redAccent,
          elevation: 5,
          shadowColor: Colors.grey,
          side: const BorderSide(color: Colors.white, width: 2),
        ),
        child: const Icon(Icons.backspace, color: Colors.white, size: 24),
      ),
    );
  }
}
