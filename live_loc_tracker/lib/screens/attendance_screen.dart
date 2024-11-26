import 'package:flutter/material.dart';
import 'location_screen.dart'; // Import LocationScreen
import 'route_screen.dart'; // Import RouteScreen
import '../data/dummy_data.dart'; // Import member data

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Member> _members = members; // The list of members

    return Scaffold(
      appBar: AppBar(title: const Text('Attendance')),
      body: ListView.builder(
        itemCount: _members.length,
        itemBuilder: (context, index) {
          final member = _members[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(member.name, style: const TextStyle(fontSize: 18)),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.location_on, color: Colors.blue),
                    tooltip: 'View Live Location',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => LocationScreen(memberId: member.id),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.route, color: Colors.green),
                    tooltip: 'View Route',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RouteScreen(
                            startMemberId: member.id,
                            endMemberId: member.id,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
