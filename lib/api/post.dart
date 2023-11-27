// ignore_for_file: non_constant_identifier_names

class Post {
  final String? email;
  final String? passwd;
  final String? token;

  Post({
    required this.email,
    required this.passwd,
    this.token,
  });

    factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      email: json['email'] as String?,
      passwd: json['passwd'] as String?,
      token: json['token'] as String?,
    );
  }

}

class PostSocial {
  final String? fullname;
  final String? email;
  final String? reg_type;
  final String? token;

  PostSocial({
    required this.fullname,
    required this.email,
    required this.reg_type,
    this.token,
  });

    factory PostSocial.fromJson(Map<String, dynamic> json) {
    return PostSocial(
      fullname: json['fullname'] as String?,
      email: json['email'] as String?,
      reg_type: json['reg_type'] as String?,
      token: json['token'] as String?,
    );
  }

}


class PostReg {
  final String? fullname;
  final String? mob_phone;
  final String? email;
  final String? passwd;
  final String? token;

  PostReg({
    required this.fullname,
    required this.email,
    required this.passwd,
    required this.mob_phone,
    this.token,
  });

    factory PostReg.fromJson(Map<String, dynamic> json) {
    return PostReg(
      fullname: json['fullname'] as String?,
      email: json['email'] as String?,
      passwd: json['passwd'] as String?,
      mob_phone: json['mob_phone'] as String?,
      token: json['token'] as String?,
    );
  }

}



class PostToken {
  final String? userId;
  final String? email;


  PostToken({
    required this.userId,
    required this.email,
  });

  factory PostToken.fromJson(Map<String, dynamic> json) {
    return PostToken(
      userId: json['userId'] as String?,
      email: json['email'] as String?
    );
  }

}