import 'package:attendanceapp/constant.dart';
import 'package:attendanceapp/services/auth_services.dart';
import 'package:attendanceapp/widgets/widgets.dart';
import 'package:flutter/material.dart';

class AddStudentPage extends StatefulWidget {
  const AddStudentPage({super.key});

  @override
  State<AddStudentPage> createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
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

  final List<String> courses = [
    'B.Tech - CSE',
    'B.Tech - Cyber Security',
    'B.Tech - Data Science',
    'B.Tech - AIML',
    'B.Tech - ECE',
    'B.Tech - Bio Technology',
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: const Text(
            "Add Student",
          ),
          foregroundColor: Colors.white,
        ),
        body: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
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
                    onTap: () async {
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
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      height: 55,
                      width: width,
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(50)),
                          border: Border.fromBorderSide(
                              BorderSide(color: primaryColor, width: 1))),
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
                              fontWeight: date == "Date of birth"
                                  ? FontWeight.w600
                                  : FontWeight.bold,
                              color: date == "Date of birth"
                                  ? Colors.grey[700]
                                  : primaryColor,
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
                      return TextFormField(
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
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor, foregroundColor: Colors.white),
            onPressed: () async {
              if (date == "Date of birth") {
                showSnackBar(
                    context, "Please provide date of birth.", Colors.red);
              } else if (formKey.currentState!.validate()) {
                showLoadingDialog(context);
                AuthServices()
                    .registerStudentAcc(
                        rollno, name, email, paswd, year, section, dept, date)
                    .then(
                  (value) {
                    Navigator.pop(context);
                    if (value == true) {
                      Navigator.of(context).pop();
                      showSnackBar(context,
                          "Successfully added student's detail.", primaryColor);
                    } else {
                      showSnackBar(context, value, Colors.red);
                    }
                  },
                );
              }
            },
            child: const Text("Submit"),
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
