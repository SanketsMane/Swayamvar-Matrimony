import 'package:active_matrimonial_flutter_app/redux/app/app_state.dart';
import 'package:active_matrimonial_flutter_app/screens/search_screens/search_action.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

import '../../repository/search_repository.dart';

ThunkAction<AppState> searchMiddleware({
  dynamic age,
  dynamic to,
  dynamic religion,
  dynamic motherTongue,
  dynamic memberCode,
  dynamic maritalStatus,
  dynamic caste,
  dynamic subCaste,
  dynamic profession,
  dynamic country,
  dynamic state,
  dynamic city,
  dynamic minHeight,
  dynamic maxHeight,
  dynamic memberType,
  dynamic education,
  dynamic income,
  dynamic manglik,
  dynamic intercaste,
  dynamic disability,
  dynamic withPhoto,
  dynamic recentlyJoined,
  dynamic searchText,
}) {
  return (Store<AppState> store) async {
    try {
      var data = await SearchRepository().search(
        age: age,
        to: to,
        religion: religion,
        motherTongue: motherTongue,
        maritalStatus: maritalStatus,
        memberCode: memberCode,
        caste: caste,
        subCaste: subCaste,
        profession: profession,
        country: country,
        state: state,
        city: city,
        minHeight: minHeight,
        maxHeight: maxHeight,
        memberType: memberType,
        education: education,
        income: income,
        manglik: manglik,
        intercaste: intercaste,
        disability: disability,
        withPhoto: withPhoto,
        recentlyJoined: recentlyJoined,
        searchText: searchText,
      );

      store.dispatch(SearchStoreAction(payload: data));
    } catch (e) {
      //debugPrint(e);
      store.dispatch(SearchFailureAction(error: e.toString()));
      return;
    }
  };
}
