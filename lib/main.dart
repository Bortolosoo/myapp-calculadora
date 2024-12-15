import 'package:flutter/material.dart';

void main() {
  runApp(const CalculadoraApp());
}

class CalculadoraApp extends StatelessWidget {
  const CalculadoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String displayText = ''; // Exibe o texto da expressão.
  String resultText = ''; // Exibe o resultado.

  void clear() {
    setState(() {
      displayText = '';
      resultText = '';
    });
  }

  void appendText(String text) {
    setState(() {
      displayText += text;
    });
  }

  void calculateResult() {
    try {
      final result = _evaluateExpression(displayText);
      setState(() {
        resultText = result.toString();
      });
    } catch (e) {
      setState(() {
        resultText = 'Erro';
      });
    }
  }

  // Função para avaliar a expressão
  double _evaluateExpression(String expression) {
    try {
      final sanitizedExpression = expression.replaceAll('×', '*').replaceAll('÷', '/');
      final result = _calculate(sanitizedExpression);
      return result;
    } catch (e) {
      return double.nan;
    }
  }

  // Função para calcular a expressão respeitando a precedência das operações
  double _calculate(String expression) {
    // Primeiro, resolvemos multiplicação e divisão (dois primeiros operadores de maior precedência)
    final multiplicationAndDivision = RegExp(r'(\d+(\.\d+)?)([*/])(\d+(\.\d+)?)');
    while (true) {
      final match = multiplicationAndDivision.firstMatch(expression);
      if (match == null) break;

      final num1 = double.parse(match.group(1)!);
      final num2 = double.parse(match.group(4)!);
      final operator = match.group(3);

      double result; // A variável precisa ser inicializada corretamente
      if (operator == '*') {
        result = num1 * num2;
      } else if (operator == '/') {
        if (num2 == 0) {
          throw Exception('Erro: divisão por zero');
        }
        result = num1 / num2;
      } else {
        // Se não encontrar operador, lancar erro
        throw Exception('Operador desconhecido');
      }

      // Substitui a operação realizada pelo resultado
      expression = expression.replaceFirst(match.group(0)!, result.toString());
    }

    // Depois, resolvemos adição e subtração (os operadores de menor precedência)
    final additionAndSubtraction = RegExp(r'(\d+(\.\d+)?)([+-])(\d+(\.\d+)?)');
    while (true) {
      final match = additionAndSubtraction.firstMatch(expression);
      if (match == null) break;

      final num1 = double.parse(match.group(1)!);
      final num2 = double.parse(match.group(4)!);
      final operator = match.group(3);

      double result; // A variável precisa ser inicializada corretamente
      if (operator == '+') {
        result = num1 + num2;
      } else if (operator == '-') {
        result = num1 - num2;
      } else {
        // Se não encontrar operador, lancar erro
        throw Exception('Operador desconhecido');
      }

      // Substitui a operação realizada pelo resultado
      expression = expression.replaceFirst(match.group(0)!, result.toString());
    }

    return double.parse(expression); // Retorna o resultado final da expressão.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Container(
          width: 300,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      displayText,
                      style: const TextStyle(fontSize: 24),
                    ),
                    Text(
                      resultText,
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              GridView.count(
                crossAxisCount: 4,
                shrinkWrap: true,
                children: [
                  buildButton('7'),
                  buildButton('8'),
                  buildButton('9'),
                  buildButton('÷'),
                  buildButton('4'),
                  buildButton('5'),
                  buildButton('6'),
                  buildButton('×'),
                  buildButton('1'),
                  buildButton('2'),
                  buildButton('3'),
                  buildButton('-'),
                  buildButton('0'),
                  buildButton('.'),
                  buildButton('='),
                  buildButton('+'),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: clear,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    child: Text(
                      'Limpar',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.refresh),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }

  Widget buildButton(String text) {
    return ElevatedButton(
      onPressed: () {
        if (text == '=') {
          calculateResult();
        } else {
          appendText(text);
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue[100],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: SizedBox(
        width: 60,
        height: 60,
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue[900],
            ),
          ),
        ),
      ),
    );
  }
}
