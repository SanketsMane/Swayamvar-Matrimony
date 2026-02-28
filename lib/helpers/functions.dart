import '../redux/store.dart';
import 'package:active_matrimonial_flutter_app/redux/store.dart';

bool get isOtpSystem => store.state.addonState!.data?.otpSystem ?? false;
