class Program {
  final String title;
  final String mentor;
  final int durationWeeks;
  final String description;
  final String startDate;
  final String schedule;
  final String eligibility;

  const Program({
    required this.title,
    required this.mentor,
    required this.durationWeeks,
    required this.description,
    required this.startDate,
    required this.schedule,
    required this.eligibility,
  });

  factory Program.fromJson(Map<String, dynamic> json) {
    return Program(
      title: json['title'] as String,
      mentor: json['mentor'] as String,
      durationWeeks: json['durationWeeks'] as int,
      description: json['description'] as String,
      startDate: json['startDate'] as String,
      schedule: json['schedule'] as String,
      eligibility: json['eligibility'] as String,
    );
  }
}