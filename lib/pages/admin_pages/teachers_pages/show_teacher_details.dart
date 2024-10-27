import 'package:attendanceapp/common/input_borders.dart';
import 'package:attendanceapp/core/theme/app_colors.dart';
import 'package:attendanceapp/pages/admin_pages/teachers_pages/add_teacher_page.dart';
import 'package:attendanceapp/services/database_services.dart';
import 'package:attendanceapp/widgets/basic_snack_bar.dart';
import 'package:flutter/material.dart';

class ShowTeacherDetails extends StatefulWidget {
  const ShowTeacherDetails(
      {super.key,
      required this.id,
      required this.name,
      required this.email,
      required this.paswd,
      required this.uid});

  final String id;
  final String name;
  final String email;
  final String paswd;
  final String uid;

  @override
  State<ShowTeacherDetails> createState() => _ShowTeacherDetailsState();
}

class _ShowTeacherDetailsState extends State<ShowTeacherDetails> {
  final formKey = GlobalKey<FormState>();

  bool isLoading = false;

  bool isEn = false;

  String id = "";
  String email = "";
  String paswd = "";
  String name = "";

  @override
  void initState() {
    super.initState();
    setState(() {
      id = widget.id;
      email = widget.email;
      paswd = widget.paswd;
      name = widget.name;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          title: const Text(
            "Teacher's details",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  showMenu(
                    context: context,
                    position: RelativeRect.fromLTRB(width, 10, 10, 10),
                    items: [
                      PopupMenuItem(
                          onTap: () {
                            showLoadingDialog(context);
                            DatabaseServices()
                                .deleteTeacherdata(widget.uid, email, paswd)
                                .then(
                              (value) {
                                Navigator.pop(context);
                                if (value) {
                                  Navigator.of(context).pop();
                                  showSnackBar(
                                      context,
                                      "Successfully removed teacher record.",
                                      AppColors.primaryColor);
                                } else {
                                  Navigator.of(context).pop();
                                  showSnackBar(
                                      context,
                                      "Something went wrong..",
                                      AppColors.primaryColor);
                                }
                              },
                            );
                          },
                          child: const Row(
                            children: [
                              Icon(Icons.delete),
                              SizedBox(
                                width: 10,
                              ),
                              Text("remove teacher"),
                            ],
                          ))
                    ],
                  );
                },
                icon: const Icon(
                  Icons.more_vert,
                  color: Colors.white,
                ))
          ],
        ),
        body: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                TextFormField(
                  initialValue: id,
                  enabled: isEn,
                  validator: (val) {
                    if (val == "") {
                      return "Please provide an ID.";
                    }
                    return null;
                  },
                  onChanged: (val) {
                    id = val.replaceAll(" ", "");
                  },
                  decoration: InputDecoration(
                      hintText: "Id",
                      prefixIcon: Icon(
                        Icons.abc,
                        color: AppColors.primaryColor,
                      ),
                      errorBorder: errorBroder,
                      border: border,
                      enabledBorder: border,
                      enabled: true,
                      focusedBorder: focusborder),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  initialValue: name,
                  enabled: isEn,
                  validator: (val) {
                    if (val == "") {
                      return "Please provide an name.";
                    }
                    return null;
                  },
                  onChanged: (val) {
                    name = val;
                  },
                  decoration: InputDecoration(
                      hintText: "Name",
                      prefixIcon: Icon(
                        Icons.person,
                        color: AppColors.primaryColor,
                      ),
                      errorBorder: errorBroder,
                      border: border,
                      enabledBorder: border,
                      enabled: true,
                      focusedBorder: focusborder),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  initialValue: email,
                  enabled: false,
                  validator: (val) {
                    return RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(val!)
                        ? null
                        : "Please enter a valid email.";
                  },
                  onChanged: (val) {
                    email = val.replaceAll(" ", "");
                  },
                  decoration: InputDecoration(
                      hintText: "Email",
                      prefixIcon: Icon(
                        Icons.email,
                        color: AppColors.primaryColor,
                      ),
                      errorBorder: errorBroder,
                      border: border,
                      enabledBorder: border,
                      enabled: true,
                      focusedBorder: focusborder),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  initialValue: paswd,
                  enabled: false,
                  validator: (val) {
                    if (val == "") {
                      return "Please provide an password.";
                    }
                    return null;
                  },
                  onChanged: (val) {
                    paswd = val.replaceAll(" ", "");
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
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                  child: ElevatedButton.icon(
                      onPressed: isEn == false
                          ? () {
                              setState(() {
                                isEn = true;
                              });
                            }
                          : null,
                      icon: const Icon(Icons.edit_note_rounded),
                      label: const Text("Edit"))),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: Colors.white),
                  onPressed: isEn == false
                      ? null
                      : () async {
                          if (formKey.currentState!.validate()) {
                            showLoadingDialog(context);
                            DatabaseServices()
                                .uploadTeacherdata(
                                    id, name, email, paswd, widget.uid)
                                .then(
                              (value) {
                                Navigator.pop(context);
                                setState(() {
                                  isEn = false;
                                });
                                if (value == true) {
                                  showSnackBar(
                                      context,
                                      "Successfully updated teacher's detail.",
                                      AppColors.primaryColor);
                                } else {
                                  showSnackBar(context,
                                      "Something went wrong..", Colors.red);
                                }
                              },
                            );
                          }
                        },
                  child: const Text("Save"),
                ),
              ),
            ],
          ),
        ));
  }
}
