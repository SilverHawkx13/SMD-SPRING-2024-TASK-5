class Post {
  final int postId;
  final int id;
  final String name;
  final String email;
  final String body;

  Post({
    required this.postId,
    required this.id,
    required this.name,
    required this.email,
    required this.body,
  });

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        postId: json['postId'],
        id: json['id'],
        name: json['name'],
        email: json['email'],
        body: json['body'],
      );
}
