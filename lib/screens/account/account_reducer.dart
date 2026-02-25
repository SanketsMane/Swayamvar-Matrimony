
import 'account_action.dart';
import 'account_state.dart';

AccountState account_reducer(AccountState state, dynamic action) {
  if (action is AccountInfoStoreAction) {

    return state.copyWith(
      profileData: action.payload!.data,
      error: '',
    );

  }

  if (action is AccountFailureAction) {
    return state.copyWith(
      error: action.error,
    );
  }

  return state;
}