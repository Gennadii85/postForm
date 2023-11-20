import 'package:flutter/material.dart';

class ModelForm extends StatelessWidget {
  const ModelForm({
    Key? key,
    required this.formController,
    required this.titleForm,
    required this.coolback,
    required this.type,
  }) : super(key: key);

  final TextEditingController formController;
  final String titleForm;
  final Function coolback;
  final TextInputType type;
  final Color backColor = const Color.fromARGB(19, 170, 137, 38);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 25, 20, 30),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: backColor,
            child: const Icon(Icons.lock_open),
          ),
          const SizedBox(
            width: 25,
          ),
          Expanded(
            child: TextField(
              onChanged: (_) => coolback(),
              controller: formController,
              keyboardType: type,
              decoration: InputDecoration(
                labelText: titleForm,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
