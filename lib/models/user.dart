class User {
    User({
        this.email,
        this.firstName,
        this.lastName,
        this.cellphone,
        this.documentNumber,
        this.documentType,
        this.avatar,
    });

    String email;
    String firstName;
    String lastName;
    dynamic cellphone;
    dynamic documentNumber;
    dynamic documentType;
    dynamic avatar;

    factory User.fromJson(Map<String, dynamic> json) => User(
        email: json["email"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        cellphone: json["cellphone"],
        documentNumber: json["document_number"],
        documentType: json["document_type"],
        avatar: json["avatar"],
    );

    Map<String, dynamic> toJson() => {
        "email": email,
        "first_name": firstName,
        "last_name": lastName,
        "cellphone": cellphone,
        "document_number": documentNumber,
        "document_type": documentType,
        "avatar": avatar,
    };
  String toString() => '$firstName, $email,  $lastName, $cellphone';
}
