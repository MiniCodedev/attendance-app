import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseServices {
  final teachersCollection = FirebaseFirestore.instance.collection("teachers");
  final studentsCollection = FirebaseFirestore.instance.collection("students");
  final odAndLeaveCollection =
      FirebaseFirestore.instance.collection("odAndLeave");
  final attendancesCollection =
      FirebaseFirestore.instance.collection("attendances");

  Future<bool> uploadTeacherdata(
      String id, String name, String email, String password, String uid) async {
    try {
      await teachersCollection.doc(uid).set(
        {
          "id": id,
          "name": name,
          "email": email,
          "password": password,
          "uid": uid
        },
      );

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> uploadStudentdata(
      String rollno,
      String name,
      String email,
      String password,
      int year,
      String section,
      String department,
      String dob,
      String uid) async {
    try {
      await studentsCollection.doc(uid).set(
        {
          'department': department,
          'dob': dob,
          'email': email,
          'name': name,
          'password': password,
          'rollno': rollno,
          'section': section,
          'year': year,
          "uid": uid
        },
      );

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteTeacherdata(
      String uid, String email, String password) async {
    try {
      await teachersCollection.doc(uid).delete();
      // await AuthServices().deleteAcc(email, password);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteStudentdata(
      String uid, String email, String password) async {
    try {
      await studentsCollection.doc(uid).delete();
      // await AuthServices().deleteAcc(email, password);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> registerAttendance(int year, String dept, String section,
      String date, Map<String, bool> attendanceData) async {
    try {
      await attendancesCollection.doc().set({
        "date": date,
        "details": 'year_${year}_${dept}_${section.toUpperCase()}',
        "attendance": attendanceData
      });

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> changePasswordInDatabase(
      String uid, String password, bool isStudent) async {
    try {
      if (isStudent) {
        await studentsCollection.doc(uid).update({"password": password});
      } else {
        await teachersCollection.doc(uid).update({"password": password});
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> hourlyRegisterAttendance(
    String docId,
    int year,
    String dept,
    String section,
    String date,
    Map<String, bool> attendanceData,
    int hour,
    List<String> teacher,
  ) async {
    try {
      if (docId == "") {
        await attendancesCollection.doc().set({
          "date": date,
          "details": 'year_${year}_${dept}_${section.toUpperCase()}',
          "attendance": attendanceData,
          "hour_$hour": attendanceData,
          "teacher_$hour": teacher
        });
      } else {
        bool allPresent(List dataList, String uid) {
          for (var data in dataList) {
            if (data != "no") {
              if (data[uid] == false) {
                return false;
              }
            }
          }
          return true;
        }

        Map attendanceNew = {};
        var data = (await attendancesCollection.doc(docId).get()).data() as Map;
        data["hour_$hour"] = attendanceData;

        for (var i in data["attendance"].entries) {
          var key = i.key;

          attendanceNew.addAll({
            key: allPresent([
              data.containsKey("hour_1") ? data["hour_1"] : "no",
            ], key)
          });
        }

        await attendancesCollection.doc(docId).update({
          "attendance": attendanceNew,
          "hour_$hour": attendanceData,
          "teacher_$hour": teacher
        });
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> editedAttendance(
      String docId, Map<String, bool> attendanceData) async {
    try {
      await attendancesCollection
          .doc(docId)
          .update({"attendance": attendanceData});

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteAttendanceRecord(String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection('attendances')
          .doc(docId)
          .delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> doesAttendanceExist(
      int year, String dept, String section, String date) async {
    try {
      QuerySnapshot snapshot = await attendancesCollection
          .where('details',
              isEqualTo: 'year_${year}_${dept}_${section.toUpperCase()}')
          .where("date", isEqualTo: date)
          .get();

      return snapshot.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  Future calculateAttendance(String details) async {
    final data =
        await attendancesCollection.where("details", isEqualTo: details).get();

    Map percentageMap = {};
    int total = data.docs.length;
    for (var i in data.docs) {
      for (var stu in i.data()["attendance"].entries) {
        var key = stu.key;
        var value = stu.value;
        if (value) {
          if (percentageMap.containsKey(key)) {
            percentageMap[key] = percentageMap[key] + 1;
          } else {
            percentageMap[key] = 1;
          }
        }
      }
    }

    for (var stu in percentageMap.entries) {
      var key = stu.key;
      double percentage = (percentageMap[key] / total) * 100;
      percentageMap[key] = percentage.toStringAsFixed(2);
    }

    return percentageMap;
  }

  Future<DocumentSnapshot<Map<String, dynamic>>>? gettingTeacherData(
      String uid) async {
    final data = await teachersCollection.doc(uid).get();
    return data;
  }

  Future gettingStudentData(String uid) async {
    final data = await studentsCollection.doc(uid).get();
    return data;
  }

  Future getStudentInformation(String email) async {
    final data =
        await studentsCollection.where("email", isEqualTo: email).get();
    return data.docs.first.data() as Map;
  }

  Future getStudentAttendance(String details, String uid) async {
    final data =
        await attendancesCollection.where("details", isEqualTo: details).get();
    int total = data.docs.length;
    int count = 0;

    for (var i in data.docs) {
      if (i.data()["attendance"][uid] == true) {
        count++;
      }
    }
    double percentage = (count / total) * 100;
    return [percentage, count, total - count, total];
  }

  Future<bool> addOdandLeave({
    required String name,
    required String email,
    required String sub,
    required String content,
    required String year,
    required String dept,
    required String section,
    required String rollno,
  }) async {
    try {
      await odAndLeaveCollection.doc().set({
        "date": FieldValue.serverTimestamp(),
        "classdetails": 'year_${year}_${dept}_${section.toUpperCase()}',
        "sub": sub,
        "content": content,
        "name": name,
        "email": email,
        "rollno": rollno,
        "status": null,
      });

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updatePermission({required String id, required status}) async {
    try {
      await odAndLeaveCollection.doc(id).update({"status": status});

      return true;
    } catch (e) {
      return false;
    }
  }
}
