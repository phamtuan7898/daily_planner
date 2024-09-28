class Task {
  String date;
  String location;
  String moderator;
  String notes;
  String status;
  String time;
  String title;
  int order; // Add an 'order' field to manage task order

  Task({
    required this.date,
    required this.location,
    required this.moderator,
    required this.notes,
    required this.status,
    required this.time,
    required this.title,
    required this.order, // Include order in the constructor
  });

  // Method to convert from Map<String, dynamic> to a Task object
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      date: json['date'],
      location: json['location'],
      moderator: json['moderator'],
      notes: json['notes'],
      status: json['status'],
      time: json['time'],
      title: json['title'],
      order: json['order'], // Add the order field
    );
  }

  // Method to convert a Task object to Map<String, dynamic>
  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'location': location,
      'moderator': moderator,
      'notes': notes,
      'status': status,
      'time': time,
      'title': title,
      'order': order, // Include the order field
    };
  }
}
