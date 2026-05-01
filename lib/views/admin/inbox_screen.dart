import 'package:flutter/material.dart';
import '../../services/mock_database.dart';

class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final messages = MockDatabase.messages;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Inquiries'),
      ),
      body: messages.isEmpty
          ? const Center(child: Text('No messages yet.'))
          : ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.person)),
                    title: Text(message.senderName),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Vehicle: ${message.vehicleId}'),
                        Text(message.content),
                      ],
                    ),
                    isThreeLine: true,
                    trailing: Text(
                      '${message.timestamp.month}/${message.timestamp.day}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
