import 'package:daily_planner/controller/settings_controller.dart';
import 'package:daily_planner/home_screen/edittask_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TaskDetailScreen extends StatelessWidget {
  final Map<String, dynamic>
      taskData; // Task data passed from the TaskListScreen
  final String taskId; // Task ID from Firestore

  TaskDetailScreen({required this.taskData, required this.taskId});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsController>(
      builder: (context, settingsController, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(taskData['title']),
            backgroundColor: settingsController.primaryColor,
            actions: [
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditTaskScreen(
                        taskId: taskId,
                        taskData: taskData,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade50, Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailCard('Ngày', taskData['date']),
                    _buildDetailCard('Địa điểm', taskData['location']),
                    _buildDetailCard('Thời gian', taskData['time']),
                    _buildDetailCard('Chủ trì', taskData['moderator']),
                    _buildDetailCard('Ghi chú', taskData['notes']),
                    _buildDetailCard('Trạng thái', taskData['status']),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailCard(String title, String? value) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              value ?? 'Không có dữ liệu',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
