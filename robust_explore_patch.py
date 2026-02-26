import re
import os

with open("lib/screens/home_pages/home/home.dart.bak", "r") as f:
    home_code = f.read()

# Methods to extract from home.dart.bak
# _buildActiveNow
# _buildHorizontalMatches
# _buildReelMatchCard
# _buildActionBtn
# _showFullProfileSheet

def extract_method(code, method_name):
    # Regex to capture the full method, assuming properly indented
    # We find the start of the method, then use a brace counter to find the end
    start_idx = code.find(f"  Widget {method_name}")
    if start_idx == -1:
        start_idx = code.find(f"  void {method_name}")
    if start_idx == -1:
        return ""
    
    brace_count = 0
    in_method = False
    for i in range(start_idx, len(code)):
        if code[i] == '{':
            if brace_count == 0:
                in_method = True
            brace_count += 1
        elif code[i] == '}':
            brace_count -= 1
            if brace_count == 0 and in_method:
                return code[start_idx:i+1]
    return ""

active_now = extract_method(home_code, "_buildActiveNow")
horizontal_matches = extract_method(home_code, "_buildHorizontalMatches")
reel_match = extract_method(home_code, "_buildReelMatchCard")
action_btn = extract_method(home_code, "_buildActionBtn")
profile_sheet = extract_method(home_code, "_showFullProfileSheet")

# Fix extracted methods for ExploreViewModel instead of HomeViewModel
active_now = active_now.replace("HomeViewModel", "ExploreViewModel")
horizontal_matches = horizontal_matches.replace("HomeViewModel", "ExploreViewModel")
reel_match = reel_match.replace("HomeViewModel", "ExploreViewModel")
action_btn = action_btn.replace("HomeViewModel", "ExploreViewModel")
profile_sheet = profile_sheet.replace("HomeViewModel", "ExploreViewModel")

# Fix _buildHorizontalMatches
horizontal_matches = horizontal_matches.replace("Widget _buildHorizontalMatches(BuildContext context, ExploreViewModel vm)", 
                                                "Widget _buildHorizontalMatches(BuildContext context, List<MemberData> matches, ExploreViewModel vm)")
horizontal_matches = horizontal_matches.replace("vm.activeMembers?.length ?? 0", "matches.length")
horizontal_matches = horizontal_matches.replace("vm.activeMembers![index]", "matches[index]")

# Small Match Card is missing, let's extract it
small_card = extract_method(home_code, "_buildSmallMatchCard")
small_card = small_card.replace("HomeViewModel", "ExploreViewModel")

# Fix ignoreUser missing inside _buildReelMatchCard
reel_match = reel_match.replace("if (vm.ignoreUser != null)", "if (false)")

all_extracted_methods = f"\n\n{active_now}\n\n{horizontal_matches}\n\n{small_card}\n\n{reel_match}\n\n{action_btn}\n\n{profile_sheet}\n\n"

# Now modify explore.dart
with open("lib/screens/home_pages/explore/explore.dart", "r") as f:
    explore_code = f.read()

# Original build method replacement
new_build = """
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ExploreViewModel>(
      converter: (store) => ExploreViewModel.fromStore(store),
      onInit: (store) => [
        store.dispatch(fetchPremiumMembersAction()),
        store.dispatch(fetchNewMembersAction()),
        if (store.state.basicSearchState?.searchText != null)
          _searchController.text = store.state.basicSearchState!.searchText!,
      ],
      builder: (_, vm) {
        if (vm.premiumMembersList == null || vm.newMemberList == null) {
           return Scaffold(
             backgroundColor: MyTheme.background,
             body: Column(
               children: [
                 _buildHeader(context, vm),
                 const Expanded(child: Center(child: CircularProgressIndicator(color: MyTheme.primary))),
               ],
             ),
           );
        }

        List<MemberData> rawMembers = [];
        rawMembers.addAll(vm.premiumMembersList!);
        rawMembers.addAll(vm.newMemberList!);
        
        final seen = <int>{};
        List<MemberData> uniqueMembers = rawMembers.where((m) {
          if (m.userId == null) return false;
          return seen.add(m.userId!);
        }).toList();

        List<MemberData> activeNowMatches = [];
        List<MemberData> newMatches = [];

        if (uniqueMembers.length >= 5) {
           activeNowMatches = uniqueMembers.take(5).toList();
           uniqueMembers = uniqueMembers.skip(5).toList();
        } else {
           activeNowMatches = uniqueMembers;
           uniqueMembers = [];
        }
        
        newMatches = uniqueMembers.take(8).toList();

        bool isSearching = vm.isFilterActive || _searchController.text.isNotEmpty;
        final searchResults = vm.searchList ?? [];

        return Scaffold(
          backgroundColor: MyTheme.background,
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(context, vm),
                      const SizedBox(height: 16),
                      _buildSearchSection(context, vm),
                      if (activeNowMatches.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        _buildActiveNow(context, activeNowMatches, vm),
                      ],
                      if (newMatches.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        _buildHorizontalMatches(context, newMatches, vm),
                        const SizedBox(height: 16),
                      ],
                      if (!isSearching) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                          child: Text("Hero Matches For You", style: Styles.h2),
                        ),
                      ]
                    ],
                  ),
                ),
              ];
            },
            body: isSearching
                ? SingleChildScrollView(child: _buildFilteredGrid(context, searchResults, vm))
                : (rawMembers.isEmpty 
                    ? _buildEmptyState()
                    : PageView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: rawMembers.length,
                        itemBuilder: (context, index) {
                          return _buildReelMatchCard(context, rawMembers[index], vm);
                        },
                      )
                  ),
          ),
        );
      },
    );
  }
"""

build_start = explore_code.find("  @override\n  Widget build(BuildContext context) {")
build_end = explore_code.find("  Widget _buildEmptyState() {")

if build_start != -1 and build_end != -1:
    explore_code = explore_code[:build_start] + new_build + "\n\n" + explore_code[build_end:]

# Ensure import for ProfileViewMiddleware
import_stmt = "import '../../../middleware/profile_view_middleware.dart';\n"
if "profile_view_middleware" not in explore_code:
    lines = explore_code.split("\\n")
    for i, line in enumerate(lines):
        if line.startswith("import '") and "express_interest_middleware.dart" in line:
            lines.insert(i + 1, import_stmt)
            break
    explore_code = "\\n".join(lines)

# Insert methods at end of _ExploreState class
class_end = explore_code.rfind("}\n\nclass ExploreViewModel {")
if class_end != -1:
    explore_code = explore_code[:class_end] + all_extracted_methods + explore_code[class_end:]

with open("lib/screens/home_pages/explore/explore.dart", "w") as f:
    f.write(explore_code)

print("PYTHON SCRIPT COMPLETED")
