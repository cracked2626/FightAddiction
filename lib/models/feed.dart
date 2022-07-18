import 'package:cloud_firestore/cloud_firestore.dart';

class Feed {
  final String? userName;
  final String? email;
  final String? userId;
  final String? story;
  final bool? isAnonymous;
  final String? heading;
  final Timestamp? timestamp;
  final int? length;
  final String? storyId;

  Feed({
    this.userName,
    this.email,
    this.userId,
    this.story,
    this.isAnonymous,
    this.heading,
    this.timestamp,
    this.length,
    this.storyId,
  });

  Feed.fromJson(Map json)
      : this(
          userName:
              json['userName'] != null ? json['userName'] as String : null,
          email: json['email'] != null ? json['email'] as String : null,
          userId: json['userId'] != null ? json['userId'] as String : null,
          story: json['story'] != null ? json['story'] as String : null,
          isAnonymous:
              json['isAnonymous'] != null ? json['isAnonymous'] as bool : false,
          heading: json['heading'] != null ? json['heading'] as String : null,
          timestamp: json['timestamp'] != null ? json['timestamp'] : null,
          length: json['length'] != null ? json['length'] as int : null,
          storyId: json['storyId'] != null ? json['storyId'] as String : null,
        );

  Map<String, Object?> toJson() {
    return {
      'userName': userName,
      'email': email,
      'userId': userId,
      'story': story,
      'isAnonymous': isAnonymous,
      'heading': heading,
      'timestamp': timestamp,
      'length': length,
      'storyId': storyId,
    };
  }
}
