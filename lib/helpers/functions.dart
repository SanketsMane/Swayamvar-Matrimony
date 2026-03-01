import '../redux/store.dart';

bool get isOtpSystem => store.state.addonState!.data?.otpSystem ?? false;
