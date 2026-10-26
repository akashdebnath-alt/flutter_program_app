class FeedbackEntry {
  final String programTitle;
  final String name;
  final String email;
  final int rating;
  final String comments;

  const FeedbackEntry({
    required this.programTitle,
    required this.name,
    required this.email,
    required this.rating,
    required this.comments,
  });
}