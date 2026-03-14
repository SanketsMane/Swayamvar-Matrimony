class PrivacyHelper {
  /// Masks a name according to the pattern: keep first (len-3) chars, add '**', keep last char.
  /// Example: Sanket -> San**t, Priya -> Pr**a
  static String maskName(String? name, {bool isVisible = false}) {
    if (name == null || name.isEmpty || name.toLowerCase() == 'null') return "";
    if (isVisible) return name;

    int len = name.length;
    if (len <= 2) return name;
    if (len == 3) return "${name[0]}*${name[2]}";

    int keepStart = len - 3;
    if (keepStart < 1) keepStart = 1;

    String start = name.substring(0, keepStart);
    String end = name.substring(len - 1);
    return "$start**$end";
  }

  /// Masks a phone number.
  /// Example: 9199223344 -> **********
  static String maskPhone(String? phone, {bool isVisible = false}) {
    if (phone == null || phone.isEmpty || phone.toLowerCase() == 'null') return "";
    if (isVisible) return phone;
    return "**********";
  }

  /// Masks sensitive address details like Postal Code.
  static String maskSensitive(String? value, {bool isVisible = false}) {
    if (value == null || value.isEmpty || value.toLowerCase() == 'null') return "";
    if (isVisible) return value;
    return "****";
  }
}
