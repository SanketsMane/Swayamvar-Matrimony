import 'package:active_matrimonial_flutter_app/models_response/manage_profile/get_manage_profile/life_style_get_response.dart';
import 'package:active_matrimonial_flutter_app/redux/libs/manage_profile/manage_profiles_state/life_style_state.dart';

class IsLoading {}

class LifeStyleSaveChanges {}

LifeStyleState? life_style_reducer(LifeStyleState? state, dynamic action) {
  if (action is IsLoading) {
    state?.isLoading = !(state?.isLoading ?? false);
    return state!;
  }

  if (action is LifeStyleSaveChanges) {
    state?.saveChanges = !(state?.saveChanges ?? false);
    return state!;
  }

  if (action is LifeStyleGetResponse) {
    if (state != null) {
      state.lifeStyleGetResponse = LifeStyleGetResponse(
        data: action.data,
        result: action.result,
      );
    }
    return state!;
  }

  return state;
}
