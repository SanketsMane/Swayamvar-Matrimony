import 'package:active_matrimonial_flutter_app/redux/libs/auth/vertify_state.dart';

VerifyState? verify_reducer(VerifyState? state, dynamic action) {
  if (action is VLoader) {
    return loader(state!, action);
  }
  return state;
}

class VLoader {}

VerifyState loader(VerifyState state, VLoader action) {
  state.vloader = !state.vloader!;
  return state;
}
