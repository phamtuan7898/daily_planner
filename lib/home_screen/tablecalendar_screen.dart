import 'package:daily_planner/firebase/firebase_service.dart';
import 'package:daily_planner/model/Task_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import Provider
import 'package:table_calendar/table_calendar.dart';
import 'package:daily_planner/controller/settings_controller.dart'; // Import SettingsController

class CalendarViewScreen extends StatefulWidget {
  @override
  _CalendarViewScreenState createState() => _CalendarViewScreenState();
}

class _CalendarViewScreenState extends State<CalendarViewScreen> {
  List<Task> _tasks = [];
  DateTime _selectedDate = DateTime.now(); // Ngày đã chọn
  late String selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = "${_selectedDate.day.toString().padLeft(2, '0')}/"
        "${_selectedDate.month.toString().padLeft(2, '0')}/"
        "${_selectedDate.year}";
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    FirebaseService firebaseService = FirebaseService();
    List<Task> tasks = await firebaseService.fetchTasksByDate(selectedDate);
    setState(() {
      _tasks = tasks;
    });
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDate = selectedDay;
      selectedDate = "${selectedDay.day.toString().padLeft(2, '0')}/"
          "${selectedDay.month.toString().padLeft(2, '0')}/"
          "${selectedDay.year}";
      _loadTasks(); // Tải lại công việc cho ngày đã chọn
    });
  }

  @override
  Widget build(BuildContext context) {
    // Access the settingsController to get the current primary color
    final settingsController = Provider.of<SettingsController>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Tasks for $selectedDate",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: settingsController.primaryColor, // Set AppBar color
        elevation: 2,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TableCalendar(
              firstDay: DateTime.now().subtract(Duration(days: 365)),
              lastDay: DateTime.now().add(Duration(days: 365)),
              focusedDay: _selectedDate,
              selectedDayPredicate: (day) => isSameDay(day, _selectedDate),
              onDaySelected: _onDaySelected,
              headerStyle: HeaderStyle(
                titleCentered: true,
                formatButtonVisible: false,
                titleTextStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: settingsController.primaryColor.withOpacity(0.6),
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: settingsController.primaryColor,
                  shape: BoxShape.circle,
                ),
                outsideDaysVisible: false,
                defaultTextStyle: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ),
          Expanded(
            child: _tasks.isEmpty
                ? Center(
                    child: Text(
                      "No tasks for this day",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                      ),
                    ),
                  )
                : ListView.builder(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: _tasks.length,
                    itemBuilder: (context, index) {
                      Task task = _tasks[index];
                      return Card(
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                task.title,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: settingsController.primaryColor,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    color: Colors.grey[600],
                                    size: 20,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    "Time: ${task.time}",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    color: Colors.grey[600],
                                    size: 20,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    "Location: ${task.location}",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Icon(
                                    Icons.notes,
                                    color: Colors.grey[600],
                                    size: 20,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    "Notes: ${task.notes}",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
