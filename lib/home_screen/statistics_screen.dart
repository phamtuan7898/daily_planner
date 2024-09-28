import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_planner/controller/settings_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TaskStatisticsScreen extends StatefulWidget {
  @override
  _TaskStatisticsScreenState createState() => _TaskStatisticsScreenState();
}

class _TaskStatisticsScreenState extends State<TaskStatisticsScreen> {
  int newTasks = 0;
  int inProgressTasks = 0;
  int completedTasks = 0;
  int finishedTasks = 0;

  @override
  void initState() {
    super.initState();
    _fetchTaskStatistics();
  }

  Future<void> _fetchTaskStatistics() async {
    QuerySnapshot tasksSnapshot =
        await FirebaseFirestore.instance.collection('tasks').get();

    int newTaskCount = 0;
    int inProgressCount = 0;
    int completedCount = 0;
    int finishedCount = 0;

    for (var doc in tasksSnapshot.docs) {
      String status = doc['status'];
      if (status == 'Mới tạo') {
        newTaskCount++;
      } else if (status == 'Thực hiện') {
        inProgressCount++;
      } else if (status == 'Thành công') {
        completedCount++;
      } else if (status == 'Kết thúc') {
        finishedCount++;
      }
    }

    setState(() {
      newTasks = newTaskCount;
      inProgressTasks = inProgressCount;
      completedTasks = completedCount;
      finishedTasks = finishedCount;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Listen to SettingsController for primary color changes
    final primaryColor = Provider.of<SettingsController>(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor, // Use primary color for AppBar
        title: Text('Thống kê công việc'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Text(
                'Biểu đồ công việc',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            _buildPieChart(),
            SizedBox(height: 20),
            _buildStatisticsCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildPieChart() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: AspectRatio(
        aspectRatio: 1.3,
        child: PieChart(
          PieChartData(
            sectionsSpace: 4,
            centerSpaceRadius: 50,
            startDegreeOffset: -90,
            borderData: FlBorderData(show: false),
            sections: _buildPieChartSections(),
            pieTouchData: PieTouchData(
              touchCallback: (FlTouchEvent event, pieTouchResponse) {
                setState(() {});
              },
            ),
          ),
          swapAnimationDuration:
              Duration(milliseconds: 600), // Smooth transition
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildPieChartSections() {
    return [
      PieChartSectionData(
        color: Colors.green,
        value: completedTasks.toDouble(),
        title:
            '${((completedTasks / _totalTasks()) * 100).toStringAsFixed(1)}%',
        radius: 80,
        titleStyle: TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      PieChartSectionData(
        color: Colors.blue,
        value: newTasks.toDouble(),
        title: '${((newTasks / _totalTasks()) * 100).toStringAsFixed(1)}%',
        radius: 70,
        titleStyle: TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      PieChartSectionData(
        color: Colors.orange,
        value: inProgressTasks.toDouble(),
        title:
            '${((inProgressTasks / _totalTasks()) * 100).toStringAsFixed(1)}%',
        radius: 75,
        titleStyle: TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      PieChartSectionData(
        color: Colors.red,
        value: finishedTasks.toDouble(),
        title: '${((finishedTasks / _totalTasks()) * 100).toStringAsFixed(1)}%',
        radius: 70,
        titleStyle: TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    ];
  }

  int _totalTasks() {
    return newTasks + inProgressTasks + completedTasks + finishedTasks;
  }

  Widget _buildStatisticsCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildStatisticRow('Công việc mới tạo', newTasks, Colors.blue),
              _buildStatisticRow(
                  'Công việc đang thực hiện', inProgressTasks, Colors.orange),
              _buildStatisticRow(
                  'Công việc hoàn thành', completedTasks, Colors.green),
              _buildStatisticRow(
                  'Công việc kết thúc', finishedTasks, Colors.red),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatisticRow(String title, int count, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          Row(
            children: [
              Text(
                count.toString(),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(width: 10),
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
