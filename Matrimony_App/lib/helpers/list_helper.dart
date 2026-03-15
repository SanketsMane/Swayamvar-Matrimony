
import '../models_response/common_models/member_data.dart';

class ListHelper {
  // Sanket: Helper for cleaning up lists with duplicate user IDs
  static List<MemberData> deduplicate(List<MemberData>? list) {
    if (list == null) return [];
    final seen = <int>{};
    return list.where((m) => seen.add(m.userId ?? 0)).toList();
  }
}
