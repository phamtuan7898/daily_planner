import 'package:daily_planner/controller/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'reminder_settings_screen.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final settingsController = Provider.of<SettingsController>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Cài đặt',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: settingsController.primaryColor,
        elevation: 5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section Title for Personalization
              _buildSectionTitle('Tùy chỉnh giao diện'),
              Divider(),

              // Primary Color Setting
              ListTile(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                title: Text(
                  'Màu chính',
                  style: TextStyle(fontSize: 16),
                ),
                trailing: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: settingsController.primaryColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade300, width: 2),
                  ),
                ),
                onTap: () {
                  _selectPrimaryColor(context);
                },
              ),

              // Font Family Setting
              ListTile(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                title: Text(
                  'Font chữ',
                  style: TextStyle(fontSize: 16),
                ),
                onTap: () {
                  _selectFontFamily(context);
                },
              ),

              // Dark Mode Toggle
              Consumer<SettingsController>(
                builder: (context, settingsController, child) {
                  return SwitchListTile(
                    title: Text(
                      'Chế độ tối',
                      style: TextStyle(fontSize: 16),
                    ),
                    value: settingsController.isDarkMode,
                    onChanged: (bool value) {
                      settingsController.toggleDarkMode();
                    },
                    activeColor: settingsController.primaryColor,
                  );
                },
              ),

              SizedBox(height: 20),

              // Section Title for Reminder Settings
              _buildSectionTitle('Cài đặt nhắc nhở'),
              Divider(),

              // Reminder Settings Navigation
              ListTile(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                title: Text(
                  'Cài đặt nhắc nhở',
                  style: TextStyle(fontSize: 16),
                ),
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ReminderSettingsScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Method to open the color picker
  void _selectPrimaryColor(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Chọn màu chính'),
          content: SingleChildScrollView(
            child: ColorPickerWidget(
              onColorSelected: (color) {
                Provider.of<SettingsController>(context, listen: false)
                    .changePrimaryColor(color);
                Navigator.of(context).pop();
              },
            ),
          ),
        );
      },
    );
  }

  // Method to open the font selection dialog
  void _selectFontFamily(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Chọn font chữ'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Roboto'),
                onTap: () {
                  Provider.of<SettingsController>(context, listen: false)
                      .changeFontFamily('Roboto');
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text('Arial'),
                onTap: () {
                  Provider.of<SettingsController>(context, listen: false)
                      .changeFontFamily('Arial');
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text('Times New Roman'),
                onTap: () {
                  Provider.of<SettingsController>(context, listen: false)
                      .changeFontFamily('Times New Roman');
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Helper method to create a section title
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.grey[700],
        ),
      ),
    );
  }
}

class ColorPickerWidget extends StatelessWidget {
  final Function(Color) onColorSelected;

  const ColorPickerWidget({required this.onColorSelected});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ColorTile(Colors.red, onColorSelected),
        ColorTile(Colors.green, onColorSelected),
        ColorTile(Colors.blue, onColorSelected),
        ColorTile(Colors.orange, onColorSelected),
        ColorTile(Colors.purple, onColorSelected),
      ],
    );
  }
}

class ColorTile extends StatelessWidget {
  final Color color;
  final Function(Color) onColorSelected;

  const ColorTile(this.color, this.onColorSelected);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onColorSelected(color),
      child: Container(
        margin: EdgeInsets.all(4.0),
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Center(
          child: Icon(
            Icons.check,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
