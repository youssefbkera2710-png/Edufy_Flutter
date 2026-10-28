
import 'dart:convert';

User userFromMap(String str) => User.fromMap(json.decode(str));

String userToMap(User data) => json.encode(data.toMap());

class User {
    final int? id;
    final String? name;
    final String? email;
    final String? role;
    final String? phone;
    final dynamic avatar;
    final bool? isActive;
    final String? createdAt;

    User({
        this.id,
        this.name,
        this.email,
        this.role,
        this.phone,
        this.avatar,
        this.isActive,
        this.createdAt,
    });

    User copyWith({
        int? id,
        String? name,
        String? email,
        String? role,
        String? phone,
        dynamic avatar,
        bool? isActive,
        String? createdAt,
    }) => 
        User(
            id: id ?? this.id,
            name: name ?? this.name,
            email: email ?? this.email,
            role: role ?? this.role,
            phone: phone ?? this.phone,
            avatar: avatar ?? this.avatar,
            isActive: isActive ?? this.isActive,
            createdAt: createdAt ?? this.createdAt,
        );

    factory User.fromMap(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        role: json["role"],
        phone: json["phone"],
        avatar: json["avatar"],
        isActive: json["is_active"],
        createdAt: json["created_at"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "email": email,
        "role": role,
        "phone": phone,
        "avatar": avatar,
        "is_active": isActive,
        "created_at": createdAt,
    };
}