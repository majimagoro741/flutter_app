import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // 用來格式化日期

void main() {
  runApp(const BMICalculator());
}

class BMICalculator extends StatelessWidget {
  const BMICalculator({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BMI 計算器',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const BMIScreen(),
    );
  }
}

class BMIScreen extends StatefulWidget {
  const BMIScreen({super.key});

  @override
  State<BMIScreen> createState() => _BMIScreenState();
}

class _BMIScreenState extends State<BMIScreen> {
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  String result = "";
  List<Map<String, String>> history = []; // 儲存歷史紀錄

  void calculateBMI() {
    final height = double.tryParse(heightController.text);
    final weight = double.tryParse(weightController.text);

    if (height == null || weight == null || height <= 0 || weight <= 0) {
      setState(() {
        result = "請輸入有效的身高與體重";
      });
      return;
    }

    final bmi = weight / ((height / 100) * (height / 100));
    String bmiResult = "你的 BMI 是：${bmi.toStringAsFixed(2)}";

    final now = DateTime.now();
    final formattedTime = DateFormat('yyyy-MM-dd HH:mm').format(now);

    setState(() {
      result = bmiResult;
      history.insert(0, {
        "time": formattedTime,
        "bmi": bmi.toStringAsFixed(2),
      });
    });
  }

  void clearHistory() {
    setState(() {
      history.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("BMI 計算器")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: heightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "身高 (cm)"),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: weightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "體重 (kg)"),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: calculateBMI,
                    child: const Text("計算"),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: clearHistory,
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text("清除紀錄"),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(result, style: const TextStyle(fontSize: 20)),
              const SizedBox(height: 30),
              const Text(
                "歷史紀錄",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ...history.map((record) => Card(
                    child: ListTile(
                      leading: const Icon(Icons.history),
                      title: Text("BMI：${record['bmi']}"),
                      subtitle: Text(record['time'] ?? ""),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
