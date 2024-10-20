import 'package:attendanceapp/constant.dart';
import 'package:attendanceapp/pages/admin_pages/students_pages/student_attendance_with_date.dart';
import 'package:attendanceapp/services/database_services.dart';
import 'package:attendanceapp/widgets/widgets.dart';
import 'package:flutter/material.dart';

class ShowStudentDetails extends StatefulWidget {
  const ShowStudentDetails({
    super.key,
    required this.rollno,
    required this.name,
    required this.email,
    required this.password,
    required this.year,
    required this.section,
    required this.department,
    required this.dob,
    required this.uid,
  });

  final String rollno;
  final String name;
  final String email;
  final String password;
  final int year;
  final String section;
  final String department;
  final String dob;
  final String uid;

  @override
  State<ShowStudentDetails> createState() => _ShowStudentDetailsState();
}

class _ShowStudentDetailsState extends State<ShowStudentDetails> {
  final formKey = GlobalKey<FormState>();

  bool isLoading = false;

  String rollno = "";
  String name = "";
  String date = "Date of birth";
  String dept = "";
  String section = "";
  int year = 1;
  String email = "";
  String paswd = "";
  String uid = "";
  bool isEn = false;

  final List<String> courses = [
    'B.Tech - CSE',
    'B.Tech - Cyber Security',
    'B.Tech - Data Science',
    'B.Tech - AIML',
    'B.Tech - ECE',
    'B.Tech - Bio Technology',
  ];

  @override
  void initState() {
    super.initState();
    rollno = widget.rollno;
    name = widget.name;
    date = widget.dob;
    dept = widget.department;
    section = widget.section;
    year = widget.year;
    email = widget.email;
    paswd = widget.password;
    uid = widget.uid;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
            backgroundColor: primaryColor,
            title: const Text(
              "Student's details",
            ),
            foregroundColor: Colors.white,
            actions: [
              IconButton(
                  onPressed: () {
                    showMenu(
                      context: context,
                      position: RelativeRect.fromLTRB(width, 10, 10, 10),
                      items: [
                        PopupMenuItem(
                          child: const Row(
                            children: [
                              Icon(Icons.table_view_rounded),
                              SizedBox(
                                width: 10,
                              ),
                              Text("View Attendance"),
                            ],
                          ),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              fullscreenDialog: true,
                              builder: (context) =>
                                  ViewStudentAttendancewithdate(
                                      studentUid: uid,
                                      department: dept,
                                      section: section,
                                      year: year),
                            ));
                          },
                        ),
                        PopupMenuItem(
                          onTap: () {
                            showLoadingDialog(context);
                            DatabaseServices()
                                .deleteStudentdata(widget.uid, email, paswd)
                                .then(
                              (value) {
                                Navigator.pop(context);
                                if (value) {
                                  Navigator.of(context).pop();
                                  showSnackBar(
                                      context,
                                      "Successfully student record removed.",
                                      primaryColor);
                                } else {
                                  Navigator.of(context).pop();
                                  showSnackBar(context,
                                      "Something went wrong..", primaryColor);
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
                              Text("Remove student"),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                  icon: const Icon(
                    Icons.more_vert,
                    color: Colors.white,
                  ))
            ]),
        body: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    initialValue: rollno,
                    enabled: isEn,
                    validator: (val) {
                      if (val == "") {
                        return "Please provide an roll number.";
                      }
                      return null;
                    },
                    onChanged: (val) {
                      rollno = val.replaceAll(" ", "").toUpperCase();
                    },
                    decoration: InputDecoration(
                        hintText: "Roll number",
                        prefixIcon: Icon(
                          Icons.assignment_ind,
                          color: primaryColor,
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
                          color: primaryColor,
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
                  GestureDetector(
                    onTap: isEn
                        ? () async {
                            DateTime? dateTime = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now());
                            if (dateTime != null) {
                              setState(() {
                                date =
                                    "${dateTime.day.toString().length == 1 ? "0${dateTime.day}" : dateTime.day.toString()}-${dateTime.month.toString().length == 1 ? "0${dateTime.month}" : dateTime.month.toString()}-${dateTime.year}";
                              });
                            }
                          }
                        : null,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      height: 55,
                      width: width,
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(50)),
                          border: Border.fromBorderSide(BorderSide(
                              color: isEn
                                  ? Colors.grey
                                  : const Color.fromARGB(255, 218, 218, 218),
                              width: isEn ? 2 : 1))),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.date_range_rounded,
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Text(
                            date,
                            style: TextStyle(
                              fontWeight:
                                  isEn ? FontWeight.bold : FontWeight.w500,
                              color: !isEn ? Colors.grey[500] : primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Autocomplete<String>(
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      if (textEditingValue.text.isEmpty) {
                        return const Iterable<String>.empty();
                      }
                      return courses.where((String option) {
                        return option.toLowerCase().contains(
                              textEditingValue.text.toLowerCase(),
                            );
                      });
                    },
                    onSelected: (String selection) {
                      dept = selection;
                    },
                    fieldViewBuilder: (BuildContext context,
                        TextEditingController textEditingController,
                        FocusNode focusNode,
                        VoidCallback onFieldSubmitted) {
                      textEditingController.text = dept;
                      return TextFormField(
                        enabled: isEn,
                        controller: textEditingController,
                        focusNode: focusNode,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please provide an department.";
                          } else if (!courses.contains(value)) {
                            return "Please select given department.";
                          } else {
                            return null;
                          }
                        },
                        onFieldSubmitted: (String value) {
                          onFieldSubmitted();
                        },
                        decoration: InputDecoration(
                            hintText: "Department",
                            prefixIcon: Icon(
                              Icons.school_rounded,
                              color: primaryColor,
                            ),
                            errorBorder: errorBroder,
                            border: border,
                            enabledBorder: border,
                            enabled: true,
                            focusedBorder: focusborder),
                      );
                    },
                    optionsViewBuilder: (BuildContext context,
                        AutocompleteOnSelected<String> onSelected,
                        Iterable<String> options) {
                      return Align(
                        alignment: Alignment.topLeft,
                        child: Material(
                          child: SizedBox(
                            width: 300,
                            child: ListView.builder(
                              padding: const EdgeInsets.all(8.0),
                              itemCount: options.length,
                              itemBuilder: (BuildContext context, int index) {
                                final String option = options.elementAt(index);
                                return GestureDetector(
                                  onTap: () {
                                    onSelected(option);
                                  },
                                  child: ListTile(
                                    title: Text(option),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    initialValue: section,
                    enabled: isEn,
                    maxLength: 1,
                    validator: (val) {
                      if (val == "") {
                        return "Please provide an section.";
                      }
                      return null;
                    },
                    onChanged: (val) {
                      section = val.toUpperCase();
                    },
                    decoration: InputDecoration(
                      hintText: "Section",
                      prefixIcon: Icon(
                        Icons.group,
                        color: primaryColor,
                      ),
                      errorBorder: errorBroder,
                      border: border,
                      enabledBorder: border,
                      enabled: true,
                      focusedBorder: focusborder,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    initialValue: year.toString(),
                    enabled: isEn,
                    maxLength: 1,
                    validator: (val) {
                      val = val!.replaceAll(" ", "");
                      if (val == "") {
                        return "Please provide an year.";
                      } else if (int.tryParse(val) == null) {
                        return "Year must be a number.";
                      }
                      return null;
                    },
                    onChanged: (val) {
                      year = int.tryParse(val) ?? 0;
                    },
                    decoration: InputDecoration(
                      hintText: "Year",
                      prefixIcon: Icon(
                        Icons.event,
                        color: primaryColor,
                      ),
                      errorBorder: errorBroder,
                      border: border,
                      enabledBorder: border,
                      enabled: true,
                      focusedBorder: focusborder,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    initialValue: email,
                    enabled: false,
                    validator: (val) {
                      if (!RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(val!)) {
                        return "Please enter a valid email.";
                      } else if (!val.contains("@student")) {
                        return "Please provide with @student";
                      }
                      return null;
                    },
                    onChanged: (val) {
                      email = val.replaceAll(" ", "");
                    },
                    decoration: InputDecoration(
                        hintText: "example@student.university.com",
                        prefixIcon: Icon(
                          Icons.email,
                          color: primaryColor,
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
                        color: primaryColor,
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
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white),
                  onPressed: isEn == false
                      ? null
                      : () async {
                          if (formKey.currentState!.validate()) {
                            showLoadingDialog(context);
                            DatabaseServices()
                                .uploadStudentdata(rollno, name, email, paswd,
                                    year, section, dept, date, uid)
                                .then(
                              (value) {
                                Navigator.pop(context);
                                setState(() {
                                  isEn = false;
                                });
                                if (value == true) {
                                  showSnackBar(
                                      context,
                                      "Successfully updated student's detail.",
                                      primaryColor);
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

void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return const LoadingDialog();
    },
  );
}

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 15),
            Text("Loading, please wait..."),
          ],
        ),
      ),
    );
  }
}
