import 'package:active_matrimonial_flutter_app/const/my_theme.dart';
import 'package:active_matrimonial_flutter_app/const/style.dart';
import 'package:active_matrimonial_flutter_app/components/toast_component.dart';
import 'package:active_matrimonial_flutter_app/repository/report_repository.dart';
import 'package:flutter/material.dart';
import 'package:one_context/one_context.dart';
import 'package:toast/toast.dart';

class ReportDialog extends StatefulWidget {
  final int userId;
  const ReportDialog({super.key, required this.userId});

  @override
  State<ReportDialog> createState() => _ReportDialogState();
}

class _ReportDialogState extends State<ReportDialog> {
  String _selectedOption = 'Spam';
  final TextEditingController _reasonController = TextEditingController();

  Future<void> _submitReport() async {
    String finalReason = _selectedOption;
    if (_selectedOption == 'Spam' && _reasonController.text.isNotEmpty) {
      finalReason = "Spam: ${_reasonController.text}";
    }

    try {
      final response = await ReportRepository().report(
        userId: widget.userId,
        reason: finalReason,
      );

      if (response.result!) {
        ToastComponent.showDialog(context, "Report submitted successfully",
            gravity: Toast.bottom, duration: Toast.lengthLong);
        Navigator.pop(context);
      } else {
        ToastComponent.showDialog(context, response.message!,
            gravity: Toast.bottom, duration: Toast.lengthLong);
      }
    } catch (e) {
      ToastComponent.showDialog(context, "Something went wrong",
          gravity: Toast.bottom, duration: Toast.lengthLong);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text("Report Profile",
          style: TextStyle(fontWeight: FontWeight.bold)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text("Report as Spam"),
              value: 'Spam',
              groupValue: _selectedOption,
              onChanged: (value) => setState(() => _selectedOption = value!),
              activeColor: MyTheme.primary,
            ),
            if (_selectedOption == 'Spam')
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: _reasonController,
                  decoration: const InputDecoration(
                    hintText: "Reason for spam...",
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
              ),
            RadioListTile<String>(
              title: const Text("Report as Married"),
              value: 'Report as Married',
              groupValue: _selectedOption,
              onChanged: (value) => setState(() => _selectedOption = value!),
              activeColor: MyTheme.primary,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          onPressed: _submitReport,
          style: ElevatedButton.styleFrom(
            backgroundColor: MyTheme.primary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: const Text("Submit", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
