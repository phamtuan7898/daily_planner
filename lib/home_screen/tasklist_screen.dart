import 'package:daily_planner/addtask_screen.dart';
import 'package:daily_planner/controller/settings_controller.dart';
import 'package:daily_planner/home_screen/edittask_screen.dart';
import 'package:daily_planner/home_screen/statistics_screen.dart';
import 'package:daily_planner/home_screen/taskdetail_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<DocumentSnapshot> _tasks = [];
  List<DocumentSnapshot> _displayTasks = [];

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('tasks')
        .orderBy('order')
        .snapshots()
        .listen((snapshot) {
      setState(() {
        _tasks = snapshot.docs;
        _displayTasks = List.from(_tasks);
      });
    });
  }

  void _navigateToAddTask() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddTaskScreen()),
    );
  }

  void _navigateToTaskStatistics() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaskStatisticsScreen()),
    );
  }

  void _deleteTask(String taskId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Xóa công việc'),
          content: Text('Bạn có chắc chắn muốn xóa công việc này không?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('tasks')
                    .doc(taskId)
                    .delete();
                Navigator.of(context).pop();
              },
              child: Text('Xóa'),
            ),
          ],
        );
      },
    );
  }

  void _editTask(String taskId, Map<String, dynamic> taskData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            EditTaskScreen(taskId: taskId, taskData: taskData),
      ),
    );
  }

  void _viewTaskDetails(String taskId, Map<String, dynamic> taskData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            TaskDetailScreen(taskData: taskData, taskId: taskId),
      ),
    );
  }

  void _onReorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex -= 1;
    final DocumentSnapshot task = _displayTasks.removeAt(oldIndex);
    _displayTasks.insert(newIndex, task);
    setState(() {});

    for (int i = 0; i < _displayTasks.length; i++) {
      String taskId = _displayTasks[i].id;
      FirebaseFirestore.instance.collection('tasks').doc(taskId).update({
        'order': i,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsController>(
      builder: (context, settingsController, child) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(
              'Danh sách công việc',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: settingsController.primaryColor,
            actions: [
              IconButton(
                icon: Icon(Icons.bar_chart),
                onPressed: _navigateToTaskStatistics,
              ),
            ],
          ),
          body: _displayTasks.isEmpty
              ? Center(
                  child: Text(
                    'Không có công việc nào.',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                )
              : ReorderableListView.builder(
                  itemCount: _displayTasks.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot taskSnapshot = _displayTasks[index];
                    Map<String, dynamic> taskData =
                        taskSnapshot.data()! as Map<String, dynamic>;

                    return Card(
                      key: ValueKey(taskSnapshot.id),
                      margin: EdgeInsets.all(8.0),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(16.0),
                        title: Text(
                          taskData['title'] ?? 'Không có tiêu đề',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        subtitle: Text(
                          'Ngày: ${taskData['date'] ?? 'Không có ngày'}, Địa điểm: ${taskData['location'] ?? 'Không có địa điểm'}',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        onTap: () {
                          _viewTaskDetails(taskSnapshot.id, taskData);
                        },
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                _editTask(taskSnapshot.id, taskData);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                _deleteTask(taskSnapshot.id);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  onReorder: _onReorder,
                ),
          floatingActionButton: FloatingActionButton(
            onPressed: _navigateToAddTask,
            child: Icon(Icons.add),
            tooltip: 'Thêm công việc',
          ),
        );
      },
    );
  }
}
