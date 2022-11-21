import 'package:flutter/material.dart';
import 'package:sleep_soundly/utils/constant.dart';

class SettingDialog extends StatefulWidget {
  const SettingDialog(
      {super.key, required this.onSelect, required this.selectedId});
  final int selectedId;
  final Function(Map<String, dynamic> value) onSelect;

  @override
  State<SettingDialog> createState() => _SettingDialog();
}

class _SettingDialog extends State<SettingDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Setting'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Wrap(
                children: kMedia.map((item) {
              return Padding(
                padding: const EdgeInsets.only(right: 4),
                child: item['id'] == widget.selectedId
                    ? ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          widget.onSelect(item);
                        },
                        child: Text(item['title'] as String),
                      )
                    : OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: const StadiumBorder(),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                          widget.onSelect(item);
                        },
                        child: Text(item['title'] as String),
                      ),
              );
            }).toList()),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: '60',
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Time (minutes)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
      // actions: <Widget>[
      //   TextButton(
      //     child: const Text('Save'),
      //     onPressed: () {
      //       Navigator.of(context).pop();
      //     },
      //   ),
      // ],
    );
  }
}
