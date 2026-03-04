import 'package:active_matrimonial_flutter_app/redux/store.dart';
import 'package:active_matrimonial_flutter_app/screens/home_pages/home/home_action.dart';
import 'package:active_matrimonial_flutter_app/screens/home_pages/home/home_state.dart';
import 'package:active_matrimonial_flutter_app/screens/ignore/add_ignore_middleware.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

final homeReducer = combineReducers<HomeState>([
  TypedReducer<HomeState, HomeFetchingAction>(_homeFetching).call,
  TypedReducer<HomeState, HomeStoreAction>(_homeStore).call,
  TypedReducer<HomeState, HomeFailureAction>(_homeFailure).call,
  TypedReducer<HomeState, AddToIgnoreListFromHome>(_addToIgnore).call,
  TypedReducer<HomeState, SetCurrentIndex>(_setCurrentIndex).call,
  TypedReducer<HomeState, GoNextPage>(_goNextPage).call,
  TypedReducer<HomeState, GoPrevPage>(_goPrevPage).call,
]);

HomeState _homeFetching(HomeState state, HomeFetchingAction action) {
  state.isFetching = true;
  return state;
}

HomeState _homeStore(HomeState state, HomeStoreAction action) {
  state.isFetching = false;
  state.homeDataList = action.payload?.data;
  state.heroMatch = action.payload?.heroMatch;
  state.verified = action.payload?.verified;
  state.activeNow = action.payload?.activeNow;
  state.newMatches = action.payload?.newMatches;
  return state;
}

HomeState _homeFailure(HomeState state, HomeFailureAction action) {
  state.isFetching = false;
  state.error = action.error;
  return state;
}

HomeState _addToIgnore(HomeState state, AddToIgnoreListFromHome action) {
  store.dispatch(addIgnoreMiddleware(userId: action.user.userId!));
  state.homeDataList!.remove(action.user);
  return state;
}

HomeState _setCurrentIndex(HomeState state, SetCurrentIndex action) {
  state.currentIndex = action.payload;
  return state;
}

HomeState _goNextPage(HomeState state, GoNextPage action) {
  if (state.homeDataList != null &&
      state.currentIndex! < state.homeDataList!.length - 1) {
    state.controller!.nextPage(
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }
  return state;
}

HomeState _goPrevPage(HomeState state, GoPrevPage action) {
  if (state.currentIndex! > 0) {
    state.controller!.previousPage(
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }
  return state;
}
