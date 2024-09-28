import 'package:daily_planner/controller/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReminderSettingsScreen extends StatefulWidget {
  @override
  _ReminderSettingsScreenState createState() => _ReminderSettingsScreenState();
}

class _ReminderSettingsScreenState extends State<ReminderSettingsScreen> {
  bool isReminderEnabled = true; // State for the reminder switch
  TimeOfDay? selectedTime; // State to store selected reminder time

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsController>(
      builder: (context, settingsController, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Reminder Settings'),
            backgroundColor: settingsController.primaryColor,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Manage Reminders',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 20),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 5,
                  child: ListTile(
                    leading:
                        Icon(Icons.notifications_active, color: Colors.teal),
                    title: Text('Enable Reminder Notifications'),
                    trailing: Switch(
                      value: isReminderEnabled,
                      activeColor: Colors.teal,
                      onChanged: (bool value) {
                        setState(() {
                          isReminderEnabled = value;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 5,
                  child: ListTile(
                    leading: Icon(Icons.access_time, color: Colors.teal),
                    title: Text('Select Reminder Time'),
                    subtitle: Text(
                      selectedTime != null
                          ? 'Selected: ${selectedTime!.format(context)}'
                          : 'No time selected',
                      style: TextStyle(color: Colors.grey),
                    ),
                    onTap: () {
                      _selectTime(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }
}
