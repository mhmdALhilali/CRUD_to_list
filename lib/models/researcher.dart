class Researcher {
  final String id;
  String name;
  String email;
  String specialty;
  String university;
  String phoneNumber;

  Researcher({
    required this.id,
    required this.name,
    required this.email,
    required this.specialty,
    required this.university,
    required this.phoneNumber,
  });

  // Convert to Map for easier handling
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'specialty': specialty,
      'university': university,
      'phoneNumber': phoneNumber,
    };
  }

  // Create from Map
  factory Researcher.fromMap(Map<String, dynamic> map) {
    return Researcher(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      specialty: map['specialty'],
      university: map['university'],
      phoneNumber: map['phoneNumber'],
    );
  }

  // Copy with method for updates
  Researcher copyWith({
    String? name,
    String? email,
    String? specialty,
    String? university,
    String? phoneNumber,
  }) {
    return Researcher(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      specialty: specialty ?? this.specialty,
      university: university ?? this.university,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }
}