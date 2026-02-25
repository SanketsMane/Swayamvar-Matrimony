
import 'package:active_matrimonial_flutter_app/models_response/common_models/member_data.dart';
import 'package:flutter/material.dart';

class HomeState {
  bool? isFetching;
  List<MemberData>? homeDataList;
  String? error;
  int? currentIndex;
  PageController? controller;
  TextEditingController? reportController;

  HomeState({
    this.error,
    this.isFetching,
    this.homeDataList,
    this.currentIndex,
    this.controller,
    this.reportController,
  });

  factory HomeState.initial() {
    return HomeState(
      isFetching: false,
      error: '',
      currentIndex: 0,
      homeDataList: [],
      controller: PageController(initialPage: 0, viewportFraction: 1),
      reportController: TextEditingController(),
    );
  }
}