import 'package:active_matrimonial_flutter_app/redux/app/app_state.dart';
import 'package:redux/redux.dart';

// Sanket: Centralized Redux store holder to break circular dependencies
// This file only defines the variable. It MUST be initialized in main.dart
// using store_init.dart to avoid circular imports.

Store<AppState>? _store;

Store<AppState> get store {
  if (_store == null) {
    print("Sanket: Store getter called while _store is null.");
    print(StackTrace.current);
    throw Exception(
      "Sanket: Redux Store accessed before initialization. "
      "Ensure initStore() is called in main() before any widget building.",
    );
  }
  return _store!;
}

set store(Store<AppState> value) {
  _store = value;
}
