class ApplicationModel {
  final String id;
  final String schemeId;
  final String? schemeName;
  final String status;
  final String? reason;
  final String? createdAt;
  final List<TimelineItem>? timeline;

  ApplicationModel({
    required this.id,
    required this.schemeId,
    this.schemeName,
    required this.status,
    this.reason,
    this.createdAt,
    this.timeline,
  });

  factory ApplicationModel.fromJson(Map<String, dynamic> json) {
    return ApplicationModel(
      id: json['id'].toString(),
      schemeId: json['scheme_id']?.toString() ?? '',
      schemeName: json['scheme_name'],
      status: json['status'] ?? 'pending',
      reason: json['reason'],
      createdAt: json['created_at'],
      timeline: json['timeline'] != null
          ? (json['timeline'] as List)
                .map((e) => TimelineItem.fromJson(e))
                .toList()
          : null,
    );
  }
}

class TimelineItem {
  final String status;
  final String? date;
  final bool completed;

  TimelineItem({required this.status, this.date, required this.completed});

  factory TimelineItem.fromJson(Map<String, dynamic> json) {
    return TimelineItem(
      status: json['status'] ?? '',
      date: json['date'],
      completed: json['completed'] ?? false,
    );
  }
}
