// update_dialog.dart
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UpdateDialog extends StatefulWidget {
  final String fieldName;
  final String userId;
  final Future<void> Function(String) onSave;

  const UpdateDialog({
    Key? key,
    required this.fieldName,
    required this.userId,
    required this.onSave,
  }) : super(key: key);

  @override
  _UpdateDialogState createState() => _UpdateDialogState();
}

class _UpdateDialogState extends State<UpdateDialog> {
  String? selectedValue;
  int selectedHour = 6; // Default hour (6 AM)
  int selectedMinute = 30; // Default minute (30)

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Update ${widget.fieldName}'),
      content: Container(
        constraints: const BoxConstraints(maxHeight: 300),
        child: widget.fieldName == 'Gender'
            ? DropdownButtonFormField<String>(
                value: selectedValue,
                hint: const Text('Select Gender'),
                items: ['Male', 'Female', 'Other'].map((String gender) {
                  return DropdownMenuItem<String>(
                    value: gender,
                    child: Text(gender),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedValue = newValue;
                  });
                },
              )
            : widget.fieldName == 'Wake-up Time' || widget.fieldName == 'Bedtime'
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 150,
                              child: CupertinoPicker(
                                scrollController: FixedExtentScrollController(
                                  initialItem: selectedHour,
                                ),
                                itemExtent: 50,
                                onSelectedItemChanged: (int value) {
                                  setState(() {
                                    selectedHour = value;
                                  });
                                },
                                children: List<Widget>.generate(24, (int index) {
                                  return Center(
                                    child: Text(
                                      index.toString().padLeft(2, '0'),
                                      style: const TextStyle(fontSize: 22),
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ),
                          const Text(
                            ":",
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                            child: SizedBox(
                              height: 150,
                              child: CupertinoPicker(
                                scrollController: FixedExtentScrollController(
                                  initialItem: selectedMinute,
                                ),
                                itemExtent: 50,
                                onSelectedItemChanged: (int value) {
                                  setState(() {
                                    selectedMinute = value;
                                  });
                                },
                                children: List<Widget>.generate(60, (int index) {
                                  return Center(
                                    child: Text(
                                      index.toString().padLeft(2, '0'),
                                      style: const TextStyle(fontSize: 22),
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : TextField(
                    decoration: InputDecoration(
                        hintText: 'Enter new ${widget.fieldName}'),
                    onChanged: (value) {
                      setState(() {
                        selectedValue = value;
                      });
                    },
                  ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            String updatedValue;
            if (widget.fieldName == 'Wake-up Time' ||
                widget.fieldName == 'Bedtime') {
              updatedValue =
                  '${selectedHour.toString().padLeft(2, '0')}:${selectedMinute.toString().padLeft(2, '0')}';
            } else {
              updatedValue = selectedValue ?? '';
            }

            if (updatedValue.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Please select a value"),
                  duration: Duration(seconds: 2),
                ),
              );
              return;
            }

            try {
              await widget.onSave(updatedValue);
              if (mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${widget.fieldName} updated successfully!'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            } catch (e) {
              log('Error updating ${widget.fieldName}: $e');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Failed to update ${widget.fieldName}"),
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
