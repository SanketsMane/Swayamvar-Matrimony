// Sanket: Updated Profile Verification screen — premium 2026 design system
import 'package:active_matrimonial_flutter_app/components/common_widget.dart';
import 'package:active_matrimonial_flutter_app/const/my_theme.dart';
import 'package:active_matrimonial_flutter_app/const/style.dart';
import 'package:active_matrimonial_flutter_app/helpers/main_helpers.dart';
import 'package:active_matrimonial_flutter_app/models_response/others/common_response.dart';
import 'package:active_matrimonial_flutter_app/screens/core.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../app_config.dart';
import 'verify_action.dart';
import 'verify_state.dart';

class VerifyPage extends StatelessWidget {
  const VerifyPage({super.key});

  onVerify(BuildContext context) async {
    Map<String, String> data = {};
    Uri url = Uri.parse("${AppConfig.BASE_URL}/member/verification-info-store");
    Map<String, String> header = {
      "Authorization": "Bearer $getToken",
      "Accept": "application/json",
      "Content-Type": "application/json",
    };

    final httpReq = http.MultipartRequest("POST", url);
    httpReq.headers.addAll(header);

    for (VerificationModel element in store.state.userVerifyState!.formList!) {
      if (element.type == "text") {
        if (element.data.text.trim().toString().isEmpty) {
          store.dispatch(ShowMessageAction(msg: "${element.title} is Empty", color: MyTheme.failure));
          return;
        }
        data.addAll({element.key!: element.data.text.trim().toString()});
      } else if (element.type == "select" || element.type == "radio") {
        if (element.data == null || element.data.toString().isEmpty) {
          store.dispatch(ShowMessageAction(msg: "${element.title} is Empty", color: MyTheme.failure));
          return;
        }
        data.addAll({element.key!: element.data.toString()});
      } else if (element.type == "multi_select") {
        if (element.data == null || element.data.isEmpty) {
          store.dispatch(ShowMessageAction(msg: "${element.title} is Empty", color: MyTheme.failure));
          return;
        }
        data.addAll({element.key!: element.data.join(",").toString()});
      } else if (element.type == "file") {
        if (element.data == null || element.data.toString().isEmpty) {
          store.dispatch(ShowMessageAction(msg: "${element.title} is Empty", color: MyTheme.failure));
          return;
        }
        final image = await http.MultipartFile.fromPath(element.key!, element.data.path);
        httpReq.files.add(image);
      }
    }
    httpReq.fields.addAll(data);
    var response = await httpReq.send();
    response.stream.bytesToString().then((value) {
      var res = commonResponseFromJson(value);
      store.dispatch(ShowMessageAction(msg: res.message, color: res.result ? MyTheme.success : MyTheme.failure));
      if (res.result) {
        store.dispatch(getUserIsApproveAction());
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      onInit: (store) {
        if (store.state.userVerifyState!.verificationInfo!) {
          Navigator.pop(context);
          store.dispatch(ShowMessageAction(msg: "Verification request already sent.", color: MyTheme.failure));
        } else {
          store.dispatch(getFormDataAction());
        }
      },
      builder: (_, state) {
        return Scaffold(
          backgroundColor: MyTheme.background,
          appBar: _buildHeader(context),
          body: state.userVerifyState!.isFetching!
              ? const Center(child: CircularProgressIndicator(color: MyTheme.primary))
              : Stack(
                  children: [
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          _buildTrustCard(),
                          const SizedBox(height: 16),
                          _buildStepsCard(),
                          const SizedBox(height: 16),
                          ..._buildFormFields(state),
                          _buildStatusSection(state),
                          const SizedBox(height: 100), // Space for sticky button
                        ],
                      ),
                    ),
                    _buildStickySubmitButton(context, state),
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
      title: const Text("Profile Verification", 
          style: TextStyle(color: MyTheme.text_primary, fontSize: 18, fontWeight: FontWeight.bold)),
      centerTitle: true,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(color: MyTheme.border, height: 1),
      ),
    );
  }

  Widget _buildTrustCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: MyTheme.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text("Get Verified ✔", style: TextStyle(color: MyTheme.text_primary, fontSize: 18, fontWeight: FontWeight.bold)),
              const Spacer(),
              Icon(Icons.verified_user, color: MyTheme.primary.withOpacity(0.1), size: 40),
            ],
          ),
          const SizedBox(height: 8),
          const Text("Verified profiles receive more matches and build higher trust with potential partners.", 
              style: TextStyle(color: MyTheme.text_secondary, fontSize: 14)),
          const SizedBox(height: 20),
          _benefitRow("Higher search visibility"),
          const SizedBox(height: 10),
          _benefitRow("More responses from serious members"),
          const SizedBox(height: 10),
          _benefitRow("Exclusive \"Trusted\" profile badge"),
        ],
      ),
    );
  }

  Widget _benefitRow(String text) {
    return Row(
      children: [
        const Icon(Icons.check_circle_outline, color: MyTheme.success, size: 16),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(color: MyTheme.text_primary, fontSize: 13)),
      ],
    );
  }

  Widget _buildStepsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: MyTheme.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Verification Steps", style: TextStyle(color: MyTheme.text_primary, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Row(
            children: [
              _stepItem("1", "Upload ID", true),
              _stepDivider(),
              _stepItem("2", "Selfie", false),
              _stepDivider(),
              _stepItem("3", "Review", false),
            ],
          ),
        ],
      ),
    );
  }

  Widget _stepItem(String number, String label, bool isActive) {
    return Column(
      children: [
        Container(
          height: 32, width: 32,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isActive ? MyTheme.primary : MyTheme.solitude,
            shape: BoxShape.circle,
          ),
          child: Text(number, style: TextStyle(color: isActive ? Colors.white : MyTheme.text_secondary, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 8),
        Text(label, style: TextStyle(color: isActive ? MyTheme.text_primary : MyTheme.text_secondary, fontSize: 10)),
      ],
    );
  }

  Widget _stepDivider() {
    return Expanded(
      child: Container(height: 1, color: MyTheme.border, margin: const EdgeInsets.only(left: 8, right: 8, bottom: 20)),
    );
  }

  List<Widget> _buildFormFields(AppState state) {
    List<Widget> widgets = [];
    final formList = state.userVerifyState!.formList!;

    for (int i = 0; i < formList.length; i++) {
      final field = formList[i];
      widgets.add(
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: MyTheme.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(field.title ?? "", style: const TextStyle(color: MyTheme.text_primary, fontSize: 15, fontWeight: FontWeight.bold)),
              if (field.type == "file") 
                const Text("Upload a clear document for faster approval.", style: TextStyle(color: MyTheme.text_secondary, fontSize: 12)),
              const SizedBox(height: 16),
              _renderField(i, field),
            ],
          ),
        ),
      );
    }
    return widgets;
  }

  Widget _renderField(int index, VerificationModel field) {
    switch (field.type) {
      case "text":
        return _buildTextField(field.data);
      case "select":
        return _buildDropdownField(index, field as VerificationModel<String?>);
      case "file":
        return _buildFileUploadArea(index, field);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildTextField(TextEditingController controller) {
    return Container(
      height: 48,
      decoration: BoxDecoration(color: MyTheme.solitude, borderRadius: BorderRadius.circular(12)),
      child: TextField(
        controller: controller,
        style: const TextStyle(fontSize: 14),
        decoration: const InputDecoration(
          hintText: "Enter details",
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
    );
  }

  Widget _buildDropdownField(int index, VerificationModel<String?> model) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: MyTheme.solitude, borderRadius: BorderRadius.circular(12)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: model.data,
          hint: const Text("Select option", style: TextStyle(fontSize: 14)),
          items: model.options!.map((val) => DropdownMenuItem<String>(value: val.toString(), child: Text(val.toString(), style: const TextStyle(fontSize: 14)))).toList(),
          onChanged: (val) => store.dispatch(SetSelectValueAction(payload: val, index: index)),
        ),
      ),
    );
  }

  Widget _buildFileUploadArea(int index, VerificationModel field) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => store.dispatch(getVerifyImageAction(index)),
          child: Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              color: MyTheme.solitude,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: MyTheme.border, style: BorderStyle.solid), // Note: Flutter doesn't support dashed borders natively without CustomPainter
            ),
            child: field.data == null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.cloud_upload_outlined, color: MyTheme.primary, size: 32),
                      const SizedBox(height: 8),
                      const Text("Tap to upload photo", style: TextStyle(color: MyTheme.text_secondary, fontSize: 13)),
                    ],
                  )
                : Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(field.data, width: double.infinity, height: 120, fit: BoxFit.cover),
                      ),
                      Positioned(
                        top: 8, right: 8,
                        child: CircleAvatar(
                          radius: 14, backgroundColor: MyTheme.primary,
                          child: const Icon(Icons.edit, color: Colors.white, size: 14),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        if (field.data != null)
          Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(color: MyTheme.success.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check, color: MyTheme.success, size: 12),
                SizedBox(width: 4),
                Text("Uploaded", style: TextStyle(color: MyTheme.success, fontSize: 10, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildStatusSection(AppState state) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: MyTheme.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Verification Status", style: TextStyle(color: MyTheme.text_primary, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: MyTheme.solitude, borderRadius: BorderRadius.circular(12)),
            child: const Row(
              children: [
                Icon(Icons.info_outline, color: MyTheme.text_secondary, size: 20),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Pending Submission", style: TextStyle(color: MyTheme.text_primary, fontSize: 14, fontWeight: FontWeight.bold)),
                      Text("Verification usually takes 24-48 hours.", style: TextStyle(color: MyTheme.text_secondary, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStickySubmitButton(BuildContext context, AppState state) {
    return Positioned(
      bottom: 0, left: 0, right: 0,
      child: Container(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + MediaQuery.of(context).padding.bottom),
        decoration: BoxDecoration(
          color: MyTheme.white,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -4))],
        ),
        child: ElevatedButton(
          onPressed: () => onVerify(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: MyTheme.primary,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 0,
          ),
          child: const Text("Submit Verification", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
