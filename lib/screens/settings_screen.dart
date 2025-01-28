import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = false;
  bool _isNotificationEnabled = false;
  bool _isLocationEnabled = false;
  bool _isSoundEnabled = false;
  bool _isVibrationEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              title: Text('Dark Mode'),
              trailing: Switch(
                value: _isDarkMode,
                onChanged: (value) {
                  setState(() {
                    _isDarkMode = value;
                    _theme = value ? ThemeData.dark() : ThemeData.light();
                  });
                },
              ),
            ),
            ListTile(
              title: Text('Notifications'),
              trailing: Switch(
                value: _isNotificationEnabled,
                onChanged: (value) {
                  setState(() {
                    _isNotificationEnabled = value;
                  });
                },
              ),
            ),
            ListTile(
              title: Text('Location Services'),
              trailing: Switch(
                value: _isLocationEnabled,
                onChanged: (value) {
                  setState(() {
                    _isLocationEnabled = value;
                  });
                },
              ),
            ),
            ListTile(
              title: Text('Sound Effects'),
              trailing: Switch(
                value: _isSoundEnabled,
                onChanged: (value) {
                  setState(() {
                    _isSoundEnabled = value;
                  });
                },
              ),
            ),
            ListTile(
              title: Text('Vibration'),
              trailing: Switch(
                value: _isVibrationEnabled,
                onChanged: (value) {
                  setState(() {
                    _isVibrationEnabled = value;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  ThemeData _theme = ThemeData.light();

  void _changeTheme(bool value) {
    setState(() {
      _theme = value ? ThemeData.dark() : ThemeData.light();
    });
  }
}
