
class TranslationHelper {
  static const Map<String, String> _translations = {
    // Auth & Signup Errors
    "An user exists with this email": "या ईमेलसह आधीच एक वापरकर्ता अस्तित्वात आहे",
    "An user exists with this phone": "या फोन नंबरसह आधीच एक वापरकर्ता अस्तित्वात आहे",
    "The email has already been taken.": "हा ईमेल आधीच वापरला गेला आहे",
    "The phone has already been taken.": "हा फोन नंबर आधीच वापरला गेला आहे",
    "The password confirmation does not match.": "पासवर्ड पुष्टीकरण जुळत नाही",
    "The password must be at least 8 characters.": "पासवर्ड किमान ८ अक्षरांचा असावा",
    "Registration Successful. Please verify your email.": "नोंदणी यशस्वी. कृपया तुमचा ईमेल सत्यापित करा",
    "Registration Successful. Please verify your phone number.": "नोंदणी यशस्वी. कृपया तुमचा फोन नंबर सत्यापित करा",
    "Invalid login credentials": "लॉगिन माहिती चुकीची आहे",
    "Please verify your account": "कृपया तुमचे खाते सत्यापित करा",
    "Your account is deactivated": "तुमचे खाते निष्क्रिय केले आहे",
    
    // Recovery / Verification
    "Verification code sent to your email": "सत्यापन कोड तुमच्या ईमेलवर पाठवला आहे",
    "Verification code sent to your phone": "सत्यापन कोड तुमच्या फोनवर पाठवला आहे",
    "Invalid verification code": "अवैध सत्यापन कोड",
    "Password reset successful": "पासवर्ड रिसेट यशस्वी झाला",
    
    // Generic
    "Something went wrong": "काहीतरी चुकले",
    "Success": "यशस्वी",
    "Error": "त्रुटी",
  };

  static String translate(dynamic msg) {
    if (msg == null) return "";
    if (msg is! String) return msg.toString();
    
    // Try exact match
    if (_translations.containsKey(msg)) {
      return _translations[msg]!;
    }
    
    // Try case-insensitive or partial match if needed (optional)
    // For now, exact match is safer
    return msg;
  }
}
// author: Sanket
