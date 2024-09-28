import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // For formatting date
import 'package:provider/provider.dart';
import 'package:daily_planner/controller/settings_controller.dart'; // Make sure to import your settings controller

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedModerator;
  String? _selectedStatus;
  DateTime? _selectedDate;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  // List of moderators
  final List<String> _moderators = ['Thanh Ngân', 'Hữu Nghĩa'];

  // Task status stages
  final List<String> _statuses = [
    'Mới tạo',
    'Thực hiện',
    'Thành công',
    'Kết thúc'
  ];

  // Function to pick a date
  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Save task to Firestore
  void _saveTask() {
    if (_formKey.currentState!.validate() && _selectedDate != null) {
      FirebaseFirestore.instance.collection('tasks').add({
        'title': _titleController.text,
        'location': _locationController.text,
        'moderator': _selectedModerator,
        'notes': _notesController.text,
        'status': _selectedStatus,
        'time': _timeController.text,
        'date': DateFormat('dd/MM/yyyy').format(_selectedDate!),
        'order':
            DateTime.now().millisecondsSinceEpoch, // Use timestamp for order
      }).then((_) {
        // Clear form fields after saving
        _clearFormFields();
      }).catchError((error) {
        // Handle errors if needed
        print("Failed to add task: $error");
      });
    }
  }

  // Clear form fields
  void _clearFormFields() {
    _titleController.clear();
    _locationController.clear();
    _notesController.clear();
    _timeController.clear();
    setState(() {
      _selectedDate = null;
      _selectedModerator = null;
      _selectedStatus = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsController>(
      builder: (context, settingsController, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Thêm Công Việc'),
            backgroundColor: settingsController.primaryColor,
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildTextField(
                      controller: _titleController,
                      label: 'Nội dung công việc',
                      icon: Icons.title,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập nội dung công việc';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),

                    _buildTextField(
                      controller: _locationController,
                      label: 'Địa điểm',
                      icon: Icons.location_on,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập địa điểm';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),

                    _buildTextField(
                      controller: _timeController,
                      label: 'Thời gian',
                      icon: Icons.access_time,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập thời gian';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),

                    _buildTextField(
                      controller: _notesController,
                      label: 'Ghi chú',
                      icon: Icons.note,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập ghi chú';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),

                    _buildDropdownField(
                      label: 'Chủ trì',
                      value: _selectedModerator,
                      items: _moderators,
                      onChanged: (value) {
                        setState(() {
                          _selectedModerator = value;
                        });
                      },
                      validator: (value) =>
                          value == null ? 'Vui lòng chọn chủ trì' : null,
                    ),
                    SizedBox(height: 16),

                    _buildDropdownField(
                      label: 'Trạng thái',
                      value: _selectedStatus,
                      items: _statuses,
                      onChanged: (value) {
                        setState(() {
                          _selectedStatus = value;
                        });
                      },
                      validator: (value) =>
                          value == null ? 'Vui lòng chọn trạng thái' : null,
                    ),
                    SizedBox(height: 16),

                    // Date Picker
                    Card(
                      child: ListTile(
                        title: Text(_selectedDate == null
                            ? 'Chọn ngày'
                            : DateFormat('dd/MM/yyyy').format(_selectedDate!)),
                        trailing: IconButton(
                          icon: Icon(Icons.calendar_today),
                          onPressed: _pickDate,
                        ),
                      ),
                    ),
                    SizedBox(height: 32),

                    SizedBox(
                      width: double
                          .infinity, // Make the button span the full width
                      child: ElevatedButton(
                        onPressed: _saveTask,
                        child: Text(
                          'Thêm công việc',
                          style: TextStyle(
                              color: Colors.white), // Set text color to black
                        ),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: settingsController
                              .primaryColor, // Set text color when pressed
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ).copyWith(
                          elevation: ButtonStyleButton.allOrNull(
                              0.0), // Remove elevation if needed
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String? Function(String?) validator,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(), // Add border here
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).primaryColor),
            ),
          ),
          validator: validator,
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required String? Function(String?) validator,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.arrow_drop_down),
        title: DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(), // Add border here
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).primaryColor),
            ),
          ),
          value: value,
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
          validator: validator,
        ),
      ),
    );
  }
}
