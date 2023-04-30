import 'package:applied_sciences/utils.dart';
import 'package:equatable/equatable.dart';
import 'package:isar/isar.dart';

part 'user.g.dart';

@Collection(accessor: 'Users', ignore: {'props', 'hashCode', 'stringify'})
class User extends Equatable {
  final Id? id;

  final String name;

  @Index(unique: true, caseSensitive: false)
  final String email;

  final String password;

  final bool enabled;

  final DateTime? at;

  const User({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    this.enabled = true,
    this.at,
  });

  User.fromJson(JsonMap json)
      : id = json['id'],
        name = json['name'],
        email = json['email'],
        password = json['password'],
        enabled = json['enabled'],
        at = DateTime.tryParse(json['at']);

  User copyWith({
    int? id,
    String? name,
    String? email,
    String? password,
    bool? enabled,
    DateTime? at,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      enabled: enabled ?? this.enabled,
      at: at ?? this.at,
    );
  }

  @ignore
  JsonMap get toJson => {
        'id': id,
        'name': name,
        'email': email,
        'password': password,
        'enabled': enabled,
        'at': at?.toIso8601String(),
      };

  @override
  String toString() => 'User${Utils.getPrettyString(toJson)}';

  @ignore
  @override
  List<Object?> get props => [
        id,
        name,
        email,
        password,
        enabled,
    at,
      ];
}
