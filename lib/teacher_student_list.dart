import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_application_2/constractor/allStudentDetails.dart';
import 'package:flutter_application_2/teacher_show_student.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_application_2/utils.dart';
import 'package:lottie/lottie.dart';

class TeacherStudentList extends StatefulWidget {
  const TeacherStudentList({super.key});

  @override
  State<TeacherStudentList> createState() => _TeacherStudentListState();
}

class _TeacherStudentListState extends State<TeacherStudentList> {
  bool isopen = false;
  bool notopen = true;
  TextEditingController Searchbar = TextEditingController();
  List<allStudentDetais> studentlist = [];
  List<allStudentDetais> searchcontact = [];

  void FilterItem(String query) {
    query = query.toLowerCase();
    if (query.isEmpty) {
      setState(() {
        searchcontact.clear();
        searchcontact = studentlist;
      });
    } else {
      setState(() {
        searchcontact = studentlist
            .where((val) => val.name.toLowerCase().contains(query))
            .toList();
      });
    }
  }

  showImage(String image) {
    print(image);
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Container(
          decoration: BoxDecoration(
            image: image != 'no image'
                ? DecorationImage(
                    image: CachedNetworkImageProvider(
                        MyUrl.fullurl + MyUrl.Studentimageurl + image))
                : const DecorationImage(
                    image: AssetImage(
                      "assets/images/default.png",
                    ),
                  ),
            borderRadius: BorderRadius.circular(30),
          ),
          height: 250,
        ),
      ),
    );
  }

  Future getUserdata() async {
    try {
      var response = await http.get(
        // ignore: prefer_interpolation_to_compose_strings
        Uri.http(MyUrl.mainurl, MyUrl.suburl + "students_all_details.php"),
      );
      var jsondata = jsonDecode(response.body.toString());

      if (jsondata["status"] == "true") {
        studentlist.clear();
        for (int i = 0; i < jsondata['data'].length; i++) {
          allStudentDetais databasedata = allStudentDetais(
            id: jsondata['data'][i]['id'].toString(),
            name: jsondata['data'][i]['name'].toString(),
            email: jsondata['data'][i]['email'].toString(),
            pass: jsondata['data'][i]['pass'].toString(),
            image: jsondata['data'][i]['image'].toString(),
            mobile: jsondata['data'][i]['mobile'].toString(),
            course: jsondata['data'][i]['course'].toString(),
          );
          setState(() {
            studentlist.add(databasedata);
          });
        }
      }
      // ignore: use_build_context_synchronously
      else {
        Fluttertoast.showToast(
          msg: jsondata['msg'],
        );
      }

      return studentlist;
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(
        msg: e.toString(),
      );
    }
  }

  @override
  void initState() {
    getUserdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            Container(
              height: 250,
              padding: const EdgeInsets.only(
                  top: 20, bottom: 10, right: 15, left: 15),
              decoration: const BoxDecoration(
                color: Colors.lightBlue,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(70),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: Theme.of(context).colorScheme.background,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Students',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.background,
                          fontSize: 20,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 5, bottom: 20),
                    width: MediaQuery.of(context).size.width,
                    height: 55,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                      controller: Searchbar,
                      onChanged: (value) {
                        setState(() {
                          isopen = true;
                          notopen = false;
                        });
                        return FilterItem(value);
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search Here...',
                        hintStyle: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onBackground
                                .withOpacity(0.5)),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Theme.of(context)
                              .colorScheme
                              .onBackground
                              .withOpacity(0.5),
                        ),
                        suffixIcon: InkWell(
                          onTap: () {
                            setState(
                              () {
                                Searchbar.clear();
                                notopen = true;
                                isopen = false;
                              },
                            );
                          },
                          child: Icon(
                            Icons.clear,
                            color: Theme.of(context)
                                .colorScheme
                                .onBackground
                                .withOpacity(0.5),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            if (isopen == true)
              Expanded(
                child: searchcontact.isNotEmpty
                    ? Container(
                        padding: const EdgeInsets.only(top: 2),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(45),
                            topRight: Radius.circular(45),
                          ),
                          color: Theme.of(context).colorScheme.background,
                        ),
                        child: Container(
                          padding: const EdgeInsets.only(
                              left: 15, top: 10, right: 15),
                          child: ListView.builder(
                            itemCount: searchcontact.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            TeacherShowStudent(
                                          searchcontact[index],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                      border: Border.all(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .background,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: ListTile(
                                      title: Text(
                                        searchcontact[index].name,
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .background,
                                        ),
                                      ),
                                      subtitle: Text(
                                        searchcontact[index].course,
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .background,
                                        ),
                                      ),
                                      trailing: IconButton(
                                        onPressed: () async {
                                          String number =
                                              searchcontact[index].mobile;
                                          await FlutterPhoneDirectCaller
                                              .callNumber(
                                            number.toString(),
                                          );
                                        },
                                        icon: Icon(
                                          Icons.call,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .background,
                                        ),
                                      ),
                                      leading: InkWell(
                                        onTap: () {
                                          showImage(searchcontact[index].image);
                                        },
                                        child: searchcontact[index].image !=
                                                'no image'
                                            ? CachedNetworkImage(
                                                imageUrl: MyUrl.fullurl +
                                                    MyUrl.Studentimageurl +
                                                    searchcontact[index].image,
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        Container(
                                                  height: 40,
                                                  width: 40,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            90),
                                                    image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                placeholder: (context, url) =>
                                                    const CircularProgressIndicator(),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error),
                                              )
                                            : CircleAvatar(
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .background,
                                                backgroundImage:
                                                    const AssetImage(
                                                  "assets/images/default.png",
                                                ),
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.only(top: 2),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(45),
                              topRight: Radius.circular(45)),
                          color: Theme.of(context).colorScheme.background,
                        ),
                        child: Center(
                          child: LottieBuilder.asset(
                            'animations/Animation - 1709301940836.json',
                            height: 200,
                            reverse: true,
                            repeat: true,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
              ),
            if (notopen == true)
              Expanded(
                child: studentlist.isNotEmpty
                    ? Container(
                        padding: const EdgeInsets.only(top: 2),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(45),
                              topRight: Radius.circular(45)),
                          color: Theme.of(context).colorScheme.background,
                        ),
                        child: Container(
                          padding: const EdgeInsets.only(
                              left: 15, top: 10, right: 15),
                          child: ListView.builder(
                            itemCount: studentlist.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            TeacherShowStudent(
                                          studentlist[index],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground,
                                        border: Border.all(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onBackground,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: ListTile(
                                      title: Text(
                                        studentlist[index].name,
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .background,
                                        ),
                                      ),
                                      subtitle: Text(
                                        studentlist[index].course,
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .background,
                                        ),
                                      ),
                                      leading: InkWell(
                                        onTap: () {
                                          showImage(studentlist[index].image);
                                        },
                                        child: studentlist[index].image !=
                                                'no image'
                                            ? CachedNetworkImage(
                                                imageUrl: MyUrl.fullurl +
                                                    MyUrl.Studentimageurl +
                                                    studentlist[index].image,
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        Container(
                                                  height: 40,
                                                  width: 40,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            90),
                                                    image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                placeholder: (context, url) =>
                                                    const CircularProgressIndicator(),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error),
                                              )
                                            : CircleAvatar(
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .background,
                                                backgroundImage:
                                                    const AssetImage(
                                                  "assets/images/default.png",
                                                ),
                                              ),
                                      ),
                                      trailing: IconButton(
                                        onPressed: () async {
                                          String number =
                                              studentlist[index].mobile;
                                          await FlutterPhoneDirectCaller
                                              .callNumber(
                                            number.toString(),
                                          );
                                        },
                                        icon: Icon(
                                          Icons.call,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .background,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.only(top: 2),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(45),
                            topRight: Radius.circular(45),
                          ),
                          color: Theme.of(context).colorScheme.background,
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SpinKitFadingCircle(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                                size: 90,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Loading....",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
              )
          ],
        ),
      ),
    );
  }
}
