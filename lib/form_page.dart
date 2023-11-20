import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:testregistrationform/model_form.dart';
import 'package:http/http.dart' as http;

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  FormPageState createState() => FormPageState();
}

class FormPageState extends State<FormPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  bool _isButtonDisabled = true;
  bool _isLoading = false;
  final String title = 'Contact us';
  final String buttonText = 'Send';
  final String buttonWaitText = 'Please wait';

  void _validateForm() {
    setState(() {
      _isButtonDisabled = _nameController.text.isEmpty ||
          _emailController.text.isEmpty ||
          _messageController.text.isEmpty ||
          !_isValidEmail(_emailController.text);
    });
  }

  bool _isValidEmail(String email) {
    // * simple verification template, you can use the library email_validator_flutter
    // * emailValidatorFlutter.validateEmail(_emailController.text);
    // ! you can use third-party services like Firebase, but this is a more extensive task
    return RegExp(r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$')
        .hasMatch(email);
  }

  Future _sendForm() async {
    setState(() {
      _isLoading = true;
    });
    final Map<String, String> dataForm = {
      'name': _nameController.text,
      'email': _emailController.text,
      'message': _messageController.text,
    };

    final String jsonData = jsonEncode(dataForm);

    final response = await http.post(
      Uri.parse(
        'https://api.byteplex.info/api/test/contact',
      ),
      body: jsonData,
    );

    if (response.statusCode == 201) {
      _showUpMessage();
    } else {
      _showErrorMessage();
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _showUpMessage() {
    // * there may be several options for displaying the error, but I chose this one
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Email is valid.'),
      ),
    );
  }

  void _showErrorMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Email is not valid.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 25, 20, 30),
        // * can be turned into a widget SingleChildScrollView
        //* in this case, perhaps all widgets inside the Row need to be wrapped in a widget Flexible
        child: Column(
          children: [
            ModelForm(
              formController: _nameController,
              titleForm: 'Name',
              coolback: _validateForm,
              type: TextInputType.text,
            ),
            ModelForm(
              formController: _emailController,
              titleForm: 'Email',
              coolback: _validateForm,
              type: TextInputType.emailAddress,
            ),
            ModelForm(
              formController: _messageController,
              titleForm: 'Message',
              coolback: _validateForm,
              type: TextInputType.text,
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: _isButtonDisabled ? null : _sendForm,
                child: _isLoading ? Text(buttonWaitText) : Text(buttonText),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
