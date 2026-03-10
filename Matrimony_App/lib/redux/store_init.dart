import 'package:active_matrimonial_flutter_app/redux/app/app_state.dart';
import 'package:active_matrimonial_flutter_app/redux/app/reducer.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:active_matrimonial_flutter_app/redux/store.dart';

// Sanket: Centeralized Redux store initialization
// This breaks circular dependencies by being the only file that imports both store holder and reducers.
void initStore() {
  print("Sanket: Initializing Store");
  store = Store<AppState>(
    reducer,
    initialState: AppState.initialState(),
    middleware: [thunkMiddleware],
  );
}
