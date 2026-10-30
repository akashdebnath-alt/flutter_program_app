class Program {
  final String id;
  final String title;
  final String mentor;
  final int durationWeeks;
  final String description;
  final String startDate;
  final String schedule;
  final String eligibility;

  const Program({
    this.id = '',
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
      id: (json['id'] ?? json['title']).toString(),
      title: json['title'] as String,
      mentor: json['mentor'] as String,
      durationWeeks: json['durationWeeks'] as int,
      description: json['description'] as String,
      startDate: json['startDate'] as String,
      schedule: json['schedule'] as String,
      eligibility: json['eligibility'] as String,
    );
  }

  Program copyWith({
    String? title,
    String? mentor,
    int? durationWeeks,
    String? description,
    String? startDate,
    String? schedule,
    String? eligibility,
  }) {
    return Program(
      id: id,
      title: title ?? this.title,
      mentor: mentor ?? this.mentor,
      durationWeeks: durationWeeks ?? this.durationWeeks,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      schedule: schedule ?? this.schedule,
      eligibility: eligibility ?? this.eligibility,
    );
  }
}