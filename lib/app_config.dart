var this_year = DateTime.now().year.toString();
class AppConfig {
  // configure this
  static String copyright_text = "Developed By Sanket Mane $this_year"; //it will show in your splash screen
  static String app_name = "Swayamvar";                   //it will show in your splash screen
  static String purshase_code = 'your_purchase_code';         // enter your purchase_code here
  static const bool HTTPS = true;                              // Sanket: production uses HTTPS
  static const DOMAIN_PATH = "swayamvarmatrimony.in";          // Sanket: production domain


  // do not configure these below
  static const String API_ENDPATH = "api";
  static const String PROTOCOL = HTTPS ? "https://" : "http://";
  static const String RAW_BASE_URL = "$PROTOCOL$DOMAIN_PATH";
  static const String BASE_URL = "$RAW_BASE_URL/$API_ENDPATH";
}
