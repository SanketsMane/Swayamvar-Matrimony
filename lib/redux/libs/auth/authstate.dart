// import 'package:active_matrimonial_flutter_app/models_response/common_models/user.dart';
//
// class AuthState{
//   User? userData;
//   AuthState({this.userData});
//   AuthState update(User user){
//     return AuthState(userData: userData);
//   }
// }

import 'package:active_matrimonial_flutter_app/models_response/common_models/user.dart';

// ⚙️ IMPROVEMENT: Add a copyWith method to AuthState for safe updates.
class AuthState {
  final User? userData;

  const AuthState({this.userData});

  AuthState copyWith({User? userData}) {
    return AuthState(userData: userData ?? this.userData);
  }
}

// ACTION CLASSES
class AuthData {
  final User data;
  AuthData(this.data);
}

class ClearAuthData {}

// ✨ NEW: The action to update only the deactivation status.
class UpdateDeactivatedStatusAction {
  final int newStatus;
  UpdateDeactivatedStatusAction({required this.newStatus});
}
