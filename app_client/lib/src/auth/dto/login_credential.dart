import 'package:string_validator/string_validator.dart' as validator;

class LoginCredential {
  var _email = Email('');
  void setEmail(String newEmail) => _email = Email(newEmail);
  Email get email => _email;

  var _password = Password('');
  void setPassword(String newEmail) => _password = Password(newEmail);
  Password get password => _password;

  String? validate() {
    String? validate = _email.validate();
    if (validate != null) {
      return validate;
    }

    validate = _password.validate();
    if (validate != null) {
      return validate;
    }
    return null;
  }
}

class Email {
  final String value;

  Email(this.value);

  String? validate() {
    if (value.isEmpty) {
      return 'campo email não pode ser vazio';
    }

    if (!validator.isEmail(value)) {
      return 'Isso não é um email';
    }
    return null;
  }
}

class Password {
  final String value;

  Password(this.value);

  String? validate() {
    if (value.isEmpty) {
      return ' campo Senha não pode ser vazio';
    }

    return null;
  }
}
