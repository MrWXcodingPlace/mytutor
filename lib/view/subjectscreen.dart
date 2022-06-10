import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mytutor/constant.dart';
import 'package:mytutor/model/subject.dart';
import 'package:http/http.dart' as http;

class SubjectScreen extends StatefulWidget {
  const SubjectScreen({Key? key}) : super(key: key);

  @override
  State<SubjectScreen> createState() => _SubjectScreenState();
}

class _SubjectScreenState extends State<SubjectScreen> {
  List<Subject> subjectList = <Subject>[];
  String titlecenter = "Loading...";
  late double screenHeight, screenWidth, resWidth;
  var numofpage, curpage = 1;
  var color;

  @override
  void initState() {
    super.initState();
    _loadSubjects(1);
  }

  void _loadSubjects(int pageno) {
    curpage = pageno;
    numofpage ?? 1;
    http.post(Uri.parse(CONSTANTS.server + "/mytutor/php/load_subject.php"),
        body: {
          'pageno': pageno.toString(),
        }).then((response) {
      var jsondata = jsonDecode(response.body);

      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        var extractdata = jsondata['data'];
        numofpage = int.parse(jsondata['numofpage']);

        if (extractdata['subjects'] != null) {
          subjectList = <Subject>[];
          extractdata['subjects'].forEach((v) {
            subjectList.add(Subject.fromJson(v));
          });
        } else {
          titlecenter = "No Subject Available";
          subjectList.clear();
        }
        setState(() {});
      } else {
        //do something
        titlecenter = "No Product Available";
        subjectList.clear();
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
      //rowcount = 2;
    } else {
      resWidth = screenWidth * 0.75;
      //rowcount = 3;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Subject Page"),
      ),
      body: subjectList.isEmpty
          // Situation that the product list is empty
          ? Center(
              child: Text(
                titlecenter,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: GridView.count(
                    mainAxisSpacing: 10.0,
                    crossAxisSpacing: 10.0,
                    crossAxisCount: 2,
                    childAspectRatio: (1 / 1),
                    children: List.generate(
                      subjectList.length,
                      (index) {
                        return Card(
                          elevation: 5.0,
                          child: Column(
                            children: [
                              Flexible(
                                flex: 5,
                                child: CachedNetworkImage(
                                  imageUrl: CONSTANTS.server +
                                      "/mytutor/assets/courses/" +
                                      subjectList[index].subjectId.toString() +
                                      '.png',
                                  fit: BoxFit.cover,
                                  width: resWidth,
                                  placeholder: (context, url) =>
                                      const LinearProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                              Flexible(
                                flex: 5,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      subjectList[index].subjectName.toString(),
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      "RM" +
                                          subjectList[index]
                                              .subjectPrice
                                              .toString() +
                                          " / " +
                                          subjectList[index]
                                              .subjectSessions
                                              .toString() +
                                          "hours",
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      "Teach by tutor " +
                                          subjectList[index].tutorId.toString(),
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      "Rating: " +
                                          subjectList[index]
                                              .subjectRating
                                              .toString(),
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: numofpage,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      if ((curpage - 1) == index) {
                        color = Colors.red;
                      } else {
                        color = Colors.black;
                      }
                      return SizedBox(
                        width: 40,
                        child: TextButton(
                            onPressed: () => {_loadSubjects(index + 1)},
                            child: Text(
                              (index + 1).toString(),
                              style: TextStyle(color: color),
                            )),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
