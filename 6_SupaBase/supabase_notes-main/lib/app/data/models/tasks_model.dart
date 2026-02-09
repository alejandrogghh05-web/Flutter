class Tasks {
  int? id;
  int? userId;
  String? title;
  String? description;
  bool? completed;
  String? dueDate;
  String? priority;
  String? createdAt;

  Tasks({
    this.id,
    this.userId,
    this.title,
    this.description,
    this.completed,
    this.dueDate,
    this.priority,
    this.createdAt,
  });

  Tasks.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    title = json['title'];
    description = json['description'];
    completed = json['completed'];
    dueDate = json['due_date'];
    priority = json['priority'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['title'] = title;
    data['description'] = description;
    data['completed'] = completed;
    data['due_date'] = dueDate;
    data['priority'] = priority;
    data['created_at'] = createdAt;
    return data;
  }

  static List<Tasks> fromJsonList(List? data) {
    if (data == null || data.isEmpty) return [];
    return data.map((e) => Tasks.fromJson(e)).toList();
  }
}