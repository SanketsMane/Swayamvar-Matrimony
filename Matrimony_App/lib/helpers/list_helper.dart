
import '../models_response/common_models/member_data.dart';

class ListHelper {
  // Sanket: Helper for cleaning up lists with duplicate user IDs
  static List<MemberData> deduplicate(List<MemberData>? list) {
    if (list == null) return [];
    final seen = <int>{};
    return list.where((m) => seen.add(m.userId ?? 0)).toList();
  }

  // Sanket: Deduplicate multiple lists against a shared 'seen' set to prevent repeats across categories
  static List<MemberData> deduplicateGlobal(List<MemberData>? list, Set<int> seenIds) {
    if (list == null) return [];
    return list.where((m) => seenIds.add(m.userId ?? 0)).toList();
  }
}
