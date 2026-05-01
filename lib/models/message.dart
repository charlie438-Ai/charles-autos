class Message {
  final String id;
  final String vehicleId;
  final String senderName;
  final String senderEmail;
  final String senderPhone;
  final String content;
  final DateTime timestamp;

  Message({
    required this.id,
    required this.vehicleId,
    required this.senderName,
    required this.senderEmail,
    required this.senderPhone,
    required this.content,
    required this.timestamp,
  });
}
