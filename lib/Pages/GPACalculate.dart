// main.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'GPAResultPage.dart';


class Subject {
  final String subjectCode;
  final String subjectName;
  final int credits;

  Subject({
    required this.subjectCode,
    required this.subjectName,
    required this.credits,
  });

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      subjectCode: json['subjectCode'],
      subjectName: json['subjectName'],
      credits: json['credits'],
    );
  }
}

class DetailsPage extends StatefulWidget {
  final String year;
  final String department;
  final String semester;

  DetailsPage({
    required this.year,
    required this.department,
    required this.semester,
  });

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late Future<List<Subject>> futureSubjects;
  List<String> grades = ['O', 'A+', 'A', 'B+', 'B', 'C', 'RA'];
  Map<int, String> selectedGrades = {};

  @override
  void initState() {
    super.initState();
    futureSubjects = fetchSubjects(widget.department, widget.semester);
  }

  Future<List<Subject>> fetchSubjects(String department, String semester) async {
    print('Fetching subjects for department: $department, semester: $semester');
    final response = await http.get(
      Uri.parse('http://192.168.17.51/hellokcet/fetchSubject.php?department=$department&&semester=$semester'),
    );

    if (response.statusCode == 200) {
      print('Response received: ${response.body}');
      final List<dynamic> subjectsJson = jsonDecode(response.body);
      print('Parsed subjects: $subjectsJson');
      return subjectsJson.map((json) => Subject.fromJson(json)).toList();
    } else {
      print('Failed to load subjects. Status code: ${response.statusCode}');
      throw Exception('Failed to load subjects');
    }
  }

  double calculateGPA(List<Subject> subjects) {
    Map<String, int> gradePoints = {
      'O': 10,
      'A+': 9,
      'A': 8,
      'B+': 7,
      'B': 6,
      'C': 5,
      'RA': 0,
    };

    int totalCredits = 0;
    int earnedPoints = 0;

    for (int i = 0; i < subjects.length; i++) {
      int credits = subjects[i].credits;
      totalCredits += credits;
      if (selectedGrades[i] != null) {
        earnedPoints += credits * gradePoints[selectedGrades[i]]!;
      }
    }

    if (totalCredits == 0) return 0;

    return earnedPoints / totalCredits;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GPA Calculation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<Subject>>(
          future: futureSubjects,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              print('Error: ${snapshot.error}');
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              print('Data received: ${snapshot.data}');
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final subject = snapshot.data![index];
                        return Card(
                          elevation: 4,
                          margin: EdgeInsets.symmetric(vertical: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${index + 1}. Code: ${subject.subjectCode}',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      'Credits: ${subject.credits}',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Name: ${subject.subjectName}',
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(height: 16),
                                DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                    labelText: 'Choose Your Grade',
                                    border: OutlineInputBorder(),
                                  ),
                                  items: grades.map((String grade) {
                                    return DropdownMenuItem<String>(
                                      value: grade,
                                      child: Text(grade),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedGrades[index] = newValue!;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      double gpa = calculateGPA(snapshot.data!);
                      int totalCredits = snapshot.data!.fold(0, (sum, item) => sum + item.credits);
                      int earnedPoints = selectedGrades.entries.fold(
                        0,
                            (sum, entry) => sum + snapshot.data![entry.key].credits * {
                          'O': 10,
                          'A+': 9,
                          'A': 8,
                          'B+': 7,
                          'B': 6,
                          'C': 5,
                          'RA': 0,
                        }[entry.value]!,
                      );

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ResultPage(
                            totalCredits: totalCredits,
                            earnedPoints: earnedPoints,
                            gpa: gpa,
                          ),
                        ),
                      );
                    },
                    child: Text('Calculate GPA'),
                  ),
                ],
              );
            } else {
              return Center(child: Text('No data available'));
            }
          },
        ),
      ),
    );
  }
}
