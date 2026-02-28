import 'package:active_matrimonial_flutter_app/redux/store.dart';

class PercentageCalculator {
  var data;

  PercentageCalculator({this.data});

  getPercentage() {
    dynamic map = data;

    Map jsonData = map.toJson();
    var percentage;
    int completed;
    Map? finalData;

    jsonData.forEach((key, value) {
      if (value == false) {
        percentage = 0.0;
      } else if (value == true) {
        finalData = data.data.toJson();
        completed = finalData!.length;
        finalData!.forEach((key, value) {
          if (value == null || value == "") {
            completed--;
          }
        });

        percentage = ((completed / finalData!.length) * 100) / 100;

        var twoDecimalValue = percentage.toStringAsFixed(2); // '2.35'
        percentage = double.parse(twoDecimalValue);
      }
    });
    return percentage;
  }

  getBasicPercentage() {
    var percentage;
    int completed;
    Map? jsonData;

    if (data == null) {
      percentage = 0.0;
    } else {
      jsonData = data.toJson();
      jsonData!.forEach((key, value) {
        completed = jsonData!.length;
        jsonData.forEach((key, value) {
          if (value == null || value == "") {
            completed--;
          }
        });
        percentage = ((completed / jsonData.length) * 100) / 100;

        var twoDecimalValue = percentage.toStringAsFixed(2); // '2.35'
        percentage = double.parse(twoDecimalValue);
      });
    }

    return percentage;
  }

  getEducationPercentage() {
    double percentage;

    if (store.state.manageProfileCombineState!.educationState!.list.isEmpty) {
      percentage = 0.0;
    } else {
      percentage =
          (store.state.manageProfileCombineState!.educationState!.list.length /
              store
                  .state
                  .manageProfileCombineState!
                  .educationState!
                  .list
                  .length) *
          100 /
          100;
      var twodec = percentage.toStringAsFixed(2);
      percentage = double.parse(twodec);
    }
    return percentage;
  }

  getCareerPercentage() {
    double percentage;

    if (store.state.manageProfileCombineState!.careerState!.list.isEmpty) {
      percentage = 0.0;
    } else {
      percentage =
          (store.state.manageProfileCombineState!.careerState!.list.length /
              store.state.manageProfileCombineState!.careerState!.list.length) *
          100 /
          100;
      var twodec = percentage.toStringAsFixed(2);
      percentage = double.parse(twodec);
    }
    return percentage;
  }
}
