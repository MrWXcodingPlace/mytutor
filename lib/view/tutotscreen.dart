import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mytutor/constant.dart';
import 'package:mytutor/model/tutor.dart';
import 'package:http/http.dart' as http;

class TutorScreen extends StatefulWidget {
  const TutorScreen({Key? key}) : super(key: key);

  @override
  State<TutorScreen> createState() => _TutorScreenState();
}

class _TutorScreenState extends State<TutorScreen> {
  List<Tutor> tutorList = <Tutor>[];
  String titlecenter = "Loading...";
  late double screenHeight, screenWidth, resWidth;
  var numofpage, curpage = 1;
  var color;

  @override
  void initState() {
    super.initState();
    _loadTutors(1);
  }

  void _loadTutors(int pageno) {
    curpage = pageno;
    numofpage ?? 1;
    http.post(Uri.parse(CONSTANTS.server + "/mytutor/php/load_tutor.php"),
        body: {
          'pageno': pageno.toString(),
        }).then((response) {
      var jsondata = jsonDecode(response.body);

      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        var extractdata = jsondata['data'];
        numofpage = int.parse(jsondata['numofpage']);

        if (extractdata['tutors'] != null) {
          tutorList = <Tutor>[];
          extractdata['tutors'].forEach((v) {
            tutorList.add(Tutor.fromJson(v));
          });
        } else {
          titlecenter = "No Tutor Available";
          tutorList.clear();
        }
        setState(() {});
      } else {
        //do something
        titlecenter = "No Product Available";
        tutorList.clear();
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
        title: const Text("Tutor Page"),
      ),
      body: tutorList.isEmpty
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
                    crossAxisCount: 1,
                    childAspectRatio: (1 / 1.1),
                    children: List.generate(tutorList.length, (index) {
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 25.0),
                        elevation: 5.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Flexible(
                              flex: 5,
                              child: CachedNetworkImage(
                                imageUrl: CONSTANTS.server +
                                    "/mytutor/assets/tutors/" +
                                    tutorList[index].tutorId.toString() +
                                    '.jpg',
                                fit: BoxFit.contain,
                                width: resWidth,
                                placeholder: (context, url) =>
                                    const LinearProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                            Flexible(
                              flex: 5,
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.teal,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Tutor ID: " +
                                          tutorList[index].tutorId.toString(),
                                      style: const TextStyle(
                                        fontSize: 12.0,
                                        color: Colors.white70,
                                      ),
                                    ),
                                    ListTile(
                                      leading: const Icon(
                                        Icons.badge,
                                        color: Colors.white,
                                      ),
                                      title: Text(
                                        tutorList[index].tutorName.toString(),
                                        style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                        // overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    ListTile(
                                      leading: const Icon(
                                        Icons.email,
                                        color: Colors.white,
                                      ),
                                      title: Text(
                                        tutorList[index].tutorEmail.toString(),
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    ListTile(
                                      leading: const Icon(
                                        Icons.call,
                                        color: Colors.white,
                                      ),
                                      title: Text(
                                        tutorList[index].tutorPhone.toString(),
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
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
                            onPressed: () => {_loadTutors(index + 1)},
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
