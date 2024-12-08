import 'package:attendanceapp/common/input_borders.dart';
import 'package:attendanceapp/core/theme/app_colors.dart';
import 'package:attendanceapp/services/auth_services.dart';
import 'package:attendanceapp/widgets/basic_snack_bar.dart';
import 'package:attendanceapp/widgets/loading_widget.dart';
import 'package:flutter/material.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage(
      {super.key, required this.email, required this.password});
  final String email;
  final String password;

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  String newPassword = "";
  final formKey = GlobalKey<FormState>();

  submit() {
    if (formKey.currentState!.validate()) {
      showLoadingDialog(context);
      AuthServices()
          .changePassword(widget.email, widget.password, newPassword, false)
          .then(
        (value) {
          Navigator.pop(context);
          Navigator.of(context).pop();
          if (value) {
            showSnackBar(
                context, "Successfully password changed.", Colors.green);
          } else {
            showSnackBar(context, "Something went wrong.", Colors.red);
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Change Password"),
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Center(
                child: Text(
                  "Once you change the password, it will be updated within 2 minutes and will then appear in the app.",
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Password cannot be empty';
                  }
                  return null;
                },
                onChanged: (val) {
                  newPassword = val;
                },
                decoration: InputDecoration(
                  hintText: "Password",
                  prefixIcon: Icon(
                    Icons.lock_outline_rounded,
                    color: AppColors.primaryColor,
                  ),
                  errorBorder: errorBroder,
                  border: border,
                  enabledBorder: border,
                  enabled: true,
                  focusedBorder: focusborder,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(15.0),
        child: FilledButton(
          onPressed: submit,
          style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(AppColors.primaryColor)),
          child: const Text("Update password"),
        ),
      ),
    );
  }
}
