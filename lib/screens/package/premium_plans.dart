// Sanket: Consolidated Membership Plans screen — premium 2026 design system
import 'package:active_matrimonial_flutter_app/const/my_theme.dart';
import 'package:active_matrimonial_flutter_app/helpers/navigator_push.dart';
import 'package:active_matrimonial_flutter_app/screens/core.dart';
import 'package:active_matrimonial_flutter_app/screens/package/package_middlewares.dart';
import 'package:active_matrimonial_flutter_app/screens/payment_methods/payment.dart';
import 'package:flutter/material.dart';

class PremiumPlans extends StatefulWidget {
  const PremiumPlans({super.key});

  @override
  State<PremiumPlans> createState() => _PremiumPlansState();
}

class _PremiumPlansState extends State<PremiumPlans> {
  int _selectedPackageId = -1;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, PremiumPlansViewModel>(
      converter: (store) => PremiumPlansViewModel.fromStore(store),
      onInit: (store) {
        store.dispatch(Reset.packageList);
        store.dispatch(packageListMiddleware());
      },
      builder: (_, vm) {
        return Scaffold(
          backgroundColor: MyTheme.background,
          appBar: _buildHeader(context),
          body:
              vm.fetch!
                  ? const Center(
                    child: CircularProgressIndicator(color: MyTheme.primary),
                  )
                  : Stack(
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            _buildHeroSection(),
                            _buildPlansList(vm),
                            const SizedBox(height: 16),
                            _buildComparisonTable(vm),
                            const SizedBox(
                              height: 100,
                            ), // Space for sticky button
                          ],
                        ),
                      ),
                      _buildStickyUpgradeButton(vm),
                    ],
                  ),
        );
      },
    );
  }

  PreferredSizeWidget _buildHeader(BuildContext context) {
    return AppBar(
      backgroundColor: MyTheme.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: MyTheme.text_primary),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        "Membership Plans",
        style: TextStyle(
          color: MyTheme.text_primary,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(color: MyTheme.border, height: 1),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        children: [
          const Text(
            "Find Your Perfect Life Partner ❤️",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: MyTheme.text_primary,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Upgrade your membership to connect faster and access premium features.",
            textAlign: TextAlign.center,
            style: TextStyle(color: MyTheme.text_secondary, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildPlansList(PremiumPlansViewModel vm) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: vm.list!.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final package = vm.list![index];
        final isGold =
            package.name.toString().toLowerCase().contains('gold') ||
            index == 1;
        final isSelected = _selectedPackageId == package.packageId;

        return GestureDetector(
          onTap: () => setState(() => _selectedPackageId = package.packageId),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: MyTheme.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color:
                    isSelected
                        ? MyTheme.primary
                        : (isGold
                            ? MyTheme.primary.withOpacity(0.5)
                            : MyTheme.border),
                width: isSelected || isGold ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          package.name,
                          style: const TextStyle(
                            color: MyTheme.text_primary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          package.price == 0 ? "Free" : package.priceText,
                          style: const TextStyle(
                            color: MyTheme.primary,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    if (isGold)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: MyTheme.primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          "Most Popular",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Divider(color: MyTheme.border),
                ),
                _buildFeatureRow(
                  "${package.expressInterest} Interests per month",
                ),
                const SizedBox(height: 10),
                _buildFeatureRow("${package.contact} Contact Views"),
                const SizedBox(height: 10),
                _buildFeatureRow(
                  package.autoProfileMatch == 1
                      ? "Priority Matches"
                      : "Basic Matches",
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFeatureRow(String label) {
    return Row(
      children: [
        const Icon(Icons.check_circle, color: MyTheme.success, size: 18),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(color: MyTheme.text_primary, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildComparisonTable(PremiumPlansViewModel vm) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: MyTheme.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Features Comparison",
            style: TextStyle(
              color: MyTheme.text_primary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          _comparisonHeader(vm),
          const Divider(height: 32),
          _comparisonRow("Interests", vm),
          const SizedBox(height: 12),
          _comparisonRow("Contacts", vm),
          const SizedBox(height: 12),
          _comparisonRow("Chat Access", vm),
        ],
      ),
    );
  }

  Widget _comparisonHeader(PremiumPlansViewModel vm) {
    return Row(
      children: [
        const Expanded(
          flex: 2,
          child: Text(
            "Feature",
            style: TextStyle(color: MyTheme.text_secondary, fontSize: 12),
          ),
        ),
        ...vm.list!
            .take(3)
            .map(
              (p) => Expanded(
                child: Text(
                  p.name.toString().split(' ')[0],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: MyTheme.text_secondary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
      ],
    );
  }

  Widget _comparisonRow(String feature, PremiumPlansViewModel vm) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            feature,
            style: const TextStyle(color: MyTheme.text_primary, fontSize: 13),
          ),
        ),
        ...vm.list!
            .take(3)
            .map(
              (p) => const Expanded(
                child: Icon(Icons.check, color: MyTheme.success, size: 16),
              ),
            ),
      ],
    );
  }

  Widget _buildStickyUpgradeButton(PremiumPlansViewModel vm) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.fromLTRB(
          16,
          16,
          16,
          16 + MediaQuery.of(context).padding.bottom,
        ),
        decoration: BoxDecoration(
          color: MyTheme.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () => _handlePurchase(vm),
          style: ElevatedButton.styleFrom(
            backgroundColor: MyTheme.primary,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          child: const Text(
            "Upgrade Now",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  void _handlePurchase(PremiumPlansViewModel vm) {
    if (_selectedPackageId == -1) {
      store.dispatch(
        ShowMessageAction(
          msg: "Please select a plan first",
          color: MyTheme.failure,
        ),
      );
      return;
    }

    final selectedPackage = vm.list!.firstWhere(
      (p) => p.packageId == _selectedPackageId,
    );

    if (vm.isDeactivated!) {
      store.dispatch(
        ShowMessageAction(
          msg: "Please reactivate your account",
          color: MyTheme.failure,
        ),
      );
      return;
    }

    if (!store.state.userVerifyState!.isApprove!) {
      store.dispatch(
        ShowMessageAction(
          msg: "Please verify your account",
          color: MyTheme.failure,
        ),
      );
    } else {
      if (selectedPackage.packageId != 1) {
        // 1 is Free
        NavigatorPush.push(
          context,
          Payment(
            title: "Package Payment",
            payment_type: "package_payment",
            amount: selectedPackage.price.toDouble(),
            package_id: selectedPackage.packageId,
          ),
        );
      }
    }
  }
}

class PremiumPlansViewModel {
  List<dynamic>? list = [];
  bool? fetch;
  bool? isDeactivated;

  PremiumPlansViewModel({this.list, this.fetch, this.isDeactivated});

  static PremiumPlansViewModel fromStore(Store<AppState> store) {
    return PremiumPlansViewModel(
      list: store.state.premiumPlansState!.premiumList,
      fetch: store.state.premiumPlansState!.isFetching,
      isDeactivated: store.state.authState?.userData?.deactivated == 1,
    );
  }
}
