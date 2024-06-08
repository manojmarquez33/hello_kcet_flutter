import 'package:flutter/material.dart';
import 'GPACalculate.dart';

class GPAPage extends StatefulWidget {
  @override
  _GPAPageState createState() => _GPAPageState();
}

class _GPAPageState extends State<GPAPage> {
  String selectedYear = 'First Year';
  String selectedDepartment = 'CSE';
  String selectedSemester = 'Semester 1';

  List<String> semesters = ['Semester 1', 'Semester 2'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hello KCET'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Year:',
              style: TextStyle(fontSize: 16.0, color: Colors.grey[600]),
            ),
            SizedBox(height: 8.0),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: DropdownButton<String>(
                value: selectedYear,
                items: [
                  'First Year',
                  'Second Year',
                  'Third Year',
                  'Fourth Year'
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedYear = newValue!;
                    // Update semesters based on selected year
                    if (selectedYear == 'First Year') {
                      semesters = ['Semester 1', 'Semester 2'];
                      selectedSemester = 'Semester 1';
                    } else {
                      semesters = [
                        'Semester 3',
                        'Semester 4',
                        'Semester 5',
                        'Semester 6',
                        'Semester 7',
                        'Semester 8'
                      ];
                      selectedSemester = 'Semester 3';
                    }
                  });
                },
                style: TextStyle(color: Colors.black),
                underline: SizedBox(), // Remove the underline
                icon: Icon(Icons.arrow_drop_down),
                iconSize: 36.0,
                isExpanded: true,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Select Department:',
              style: TextStyle(fontSize: 16.0, color: Colors.grey[600]),
            ),
            SizedBox(height: 8.0),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: DropdownButton<String>(
                value: selectedDepartment,
                items: [
                  'CSE',
                  'AI & DS',
                  'IT',
                  'ECE',
                  'EEE',
                  'BIOTECH',
                  'MECH',
                  'MECHTRONICS'
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedDepartment = newValue!;
                  });
                },
                style: TextStyle(color: Colors.black),
                underline: SizedBox(), // Remove the underline
                icon: Icon(Icons.arrow_drop_down),
                iconSize: 36.0,
                isExpanded: true,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Select Semester:',
              style: TextStyle(fontSize: 16.0, color: Colors.grey[600]),
            ),
            SizedBox(height: 8.0),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: DropdownButton<String>(
                value: selectedSemester,
                items: semesters.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedSemester = newValue!;
                  });
                },
                style: TextStyle(color: Colors.black),
                underline: SizedBox(), // Remove the underline
                icon: Icon(Icons.arrow_drop_down),
                iconSize: 36.0,
                isExpanded: true,
              ),
            ),
            SizedBox(height: 32.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailsPage(
                        year: selectedYear,
                        department: selectedDepartment,
                        semester: selectedSemester,
                      ),
                    ),
                  );
                },
                child: Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
