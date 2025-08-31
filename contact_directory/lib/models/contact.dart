

class Contact {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String website;

  Contact(this.id, this.name, this.email, this.phone, this.website);

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      json['id'],
      json['name'],
      json['email'],
      json['phone'],
      json['website'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'website': website,
    };
  }
}