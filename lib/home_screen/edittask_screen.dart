import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:daily_planner/controller/settings_controller.dart';

class EditTaskScreen extends StatefulWidget {
  final String taskId;
  final Map<String, dynamic> taskData;

  EditTaskScreen({required this.taskId, required this.taskData});

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late TextEditingController _titleController;
  late TextEditingController _dateController;
  late TextEditingController _locationController;
  late TextEditingController _timeController;
  late TextEditingController _moderatorController;
  late TextEditingController _notesController;
  late String _status;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.taskData['title']);
    _dateController = TextEditingController(text: widget.taskData['date']);
    _locationController =
        TextEditingController(text: widget.taskData['location']);
    _timeController = TextEditingController(text: widget.taskData['time']);
    _moderatorController =
        TextEditingController(text: widget.taskData['moderator']);
    _notesController = TextEditingController(text: widget.taskData['notes']);
    _status = widget.taskData['status'];
  }

  void _updateTask() {
    FirebaseFirestore.instance.collection('tasks').doc(widget.taskId).update({
      'title': _titleController.text,
      'date': _dateController.text,
      'location': _locationController.text,
      'time': _timeController.text,
      'moderator': _moderatorController.text,
      'notes': _notesController.text,
      'status': _status,
    }).then((_) {
      Navigator.pop(context);
    });
  }

  Future<void> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        _dateController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
      });
    }
  }

  Future<void> _selectTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        _timeController.text = pickedTime.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsController>(
      builder: (context, settingsController, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Chỉnh sửa công việc'),
            backgroundColor: settingsController.primaryColor,
            actions: [
              IconButton(
                icon: Icon(Icons.save),
                onPressed: _updateTask,
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Nội dung công việc',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.edit),
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: _dateController,
                  decoration: InputDecoration(
                    labelText: 'Ngày',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  readOnly: true,
                  onTap: _selectDate,
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: _timeController,
                  decoration: InputDecoration(
                    labelText: 'Thời gian',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.access_time),
                  ),
                  readOnly: true,
                  onTap: _selectTime,
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: _locationController,
                  decoration: InputDecoration(
                    labelText: 'Địa điểm',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.location_on),
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: _moderatorController,
                  decoration: InputDecoration(
                    labelText: 'Chủ trì',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: _notesController,
                  decoration: InputDecoration(
                    labelText: 'Ghi chú',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.note),
                  ),
                  maxLines: 3,
                ),
                SizedBox(height: 16.0),
                DropdownButtonFormField<String>(
                  value: _status.isNotEmpty &&
                          ['Tạo mới', 'Thực hiện', 'Thành công', 'Kết thúc']
                              .contains(_status)
                      ? _status
                      : null,
                  onChanged: (newValue) {
                    setState(() {
                      _status = newValue!;
                    });
                  },
                  items: ['Tạo mới', 'Thực hiện', 'Thành công', 'Kết thúc']
                      .map((status) {
                    return DropdownMenuItem(
                      value: status,
                      child: Text(status),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: 'Trạng thái công việc',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.flag),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
