class StudyArgs {
  final String id;
  final String title;
  final String goal;
  final bool ethicalBoard;
  final double collected;
  final double target;
  final DateTime? endsAt;

  const StudyArgs({
    required this.id,
    required this.title,
    required this.goal,
    required this.collected,
    required this.target,
    this.ethicalBoard = false,
    this.endsAt,
  });
}
