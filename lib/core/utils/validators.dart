class Validators {
  static String? validateName(String value) {
    if (value.isEmpty) return 'Ім’я не може бути порожнім';
    if (RegExp(r'\\d').hasMatch(value)) return 'Ім’я не повинно містити цифри';
    return null;
  }

  static String? validateEmail(String value) {
    if (value.isEmpty || !value.contains('@')) {
      return 'Невірна електронна адреса';
    }
    return null;
  }

  static String? validatePassword(String value) {
    if (value.length < 6) return 'Пароль має бути не менше 6 символів';
    return null;
  }
}
