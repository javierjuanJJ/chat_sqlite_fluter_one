import 'dart:js_interop';

class MessageGroup {
  late String _id;
  String name;
  String createdBy;
  List<String> members;

  String get id => _id;

  MessageGroup({
    required this.name,
    required this.createdBy,
    required this.members
  });
  toJson() => {
    'created_by': this.createdBy,
    'name': this.name,
    'members': this.members,
  };
  factory MessageGroup.fromJson(Map<String, dynamic> json) {
    var group = MessageGroup(name: json['name'], createdBy: json['created_by'], members: List<String>.from(json['members']));
    group._id = json['id'];
    return group;
  }
}