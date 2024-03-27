import 'package:flutter/material.dart';

class StudentSubjectPDF extends StatefulWidget {
  const StudentSubjectPDF({super.key});

  @override
  State<StudentSubjectPDF> createState() => _StudentSubjectPDFState();
}

class _StudentSubjectPDFState extends State<StudentSubjectPDF> {
  TextEditingController Searchbar = TextEditingController();
  bool crossIcon = true;
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border.all(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.circular(40)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 2),
                    child: TextFormField(
                      style: const TextStyle(color: Colors.white),
                      controller: Searchbar,
                      onChanged: (value) {
                        setState(() {
                          crossIcon = false;
                        });
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        prefixIcon:
                            const Icon(Icons.search, color: Colors.white),
                        suffixIcon: InkWell(
                            onTap: () {
                              setState(
                                () {
                                  Searchbar.clear();
                                  crossIcon = true;
                                },
                              );
                            },
                            child: crossIcon == false
                                ? const Icon(Icons.clear, color: Colors.white)
                                : const SizedBox()),
                        border: InputBorder.none,
                        hintText: 'Serach',
                        hintStyle: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: height * 0.7,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ListView(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.yellowAccent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          height: height * 0.08,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.yellowAccent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          height: height * 0.08,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.yellowAccent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          height: height * 0.08,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.yellowAccent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          height: height * 0.08,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.yellowAccent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          height: height * 0.08,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.yellowAccent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          height: height * 0.08,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.yellowAccent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          height: height * 0.08,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
