import 'package:active_matrimonial_flutter_app/main.dart';
import 'package:active_matrimonial_flutter_app/redux/libs/manage_profile/manage_profiles_state/education_state.dart';
import 'package:active_matrimonial_flutter_app/repository/education_repository.dart';
import 'package:flutter/material.dart';

import '../manage_profile_middleware/manage_profile_get_middlewares.dart';

class IsLoading {}

class EducationStatusAction {
  bool? status;
  var id;

  EducationStatusAction({this.status, this.id});
}

class Edusavechanges {}

class EduDelete {
  var item;

  EduDelete({this.item});
}

enum EducationLoader { update, delete }

enum EducationReset { list }

EducationState education_reducer(EducationState? state, dynamic action) {
  state ??= EducationState.initialState();
  if (action is EducationStatusAction) {
    return status_toggler(state, action);
  }
  if (action is IsLoading) {
    return loader(state, action);
  }
  if (action is Edusavechanges) {
    return edu_save_changes(state, action);
  }

  if (action == EducationLoader.update) {
    return update_changes(state, action);
  }
  if (action == EducationReset.list) {
    return reset_list(state, action);
  }
  if (action is EduDelete) {
    return delete_education_item(state, action);
  }
  if (action == EducationLoader.delete) {
    return delete(state, action);
  }
  return state;
}

status_toggler(EducationState? state, dynamic action) {
  EducationRepository()
      .postEducationStatus(id: action.id, status: action.status);
  return state;
}

delete(EducationState state, dynamic action) {
  state.isDelete = !state.isDelete!;
  return state;
}

delete_education_item(EducationState state, EduDelete action) {
  state.list.remove(action.item);
  // Ensure controllers are cleared after deletion
  state.degreeController?.clear();
  state.institutionController?.clear();
  state.startController?.clear();
  state.endController?.clear();

  store.dispatch(educationGetMiddleware());
  return state;
}

reset_list(EducationState state, dynamic action) {
  state.list.clear();
  state.degreeController?.clear();
  state.institutionController?.clear();
  state.startController?.clear();
  state.endController?.clear();

  state.saveChanges = false;
  state.update_changes = false;

  debugPrint("Resetting education state: ${state.toString()}");

  return state;
}

update_changes(EducationState state, dynamic action) {
  state.update_changes = !state.update_changes!;
  return state;
}

edu_save_changes(EducationState state, Edusavechanges action) {
  state.saveChanges = !state.saveChanges!; // Toggle saveChanges flag
  return state;
}

loader(EducationState state, IsLoading action) {
  state.isLoading = true;
  return state;
}
