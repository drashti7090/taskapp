import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:task_app/login_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';
class HomePageApi extends StatefulWidget {
  const HomePageApi({Key? key}) : super(key: key);
  @override
  State<HomePageApi> createState() => _HomePageApiState();
}
class _HomePageApiState extends State<HomePageApi> {
  final formKey = GlobalKey<FormState>();
  TextEditingController taskName = TextEditingController();
  TextEditingController status = TextEditingController();
  int? id;
  List getData = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getApi();
    //setState((){});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 3,
        initialIndex: 0,
        child: Scaffold(
          backgroundColor: const Color(0xff467BB9),
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Text("All", style: TextStyle(color: Colors.white54)),
                Text("Pending", style: TextStyle(color: Colors.white54)),
                Text("Completed", style: TextStyle(color: Colors.white54)),
              ],
            ),
            backgroundColor: const Color(0xff103C78),
            elevation: 15,
            actions: [
              OutlinedButton(
                  onPressed: () {
                    showDialog(
                      barrierDismissible: false,
                      context: context, builder: (context) {
                      return AlertDialog(title: Text("LogOut"),
                        content: Text("Are you sure want to logout?"),
                        actions: [
                          TextButton(onPressed: () async {
                            final SharedPreferences prefs = await SharedPreferences
                                .getInstance();
                            prefs.clear();
                            Navigator.pushAndRemoveUntil(context,
                                MaterialPageRoute(
                                  builder: (context) => LoginApi(),), (
                                    route) => false);
                          }, child: Text("Yes")),
                          TextButton(onPressed: () {
                            Navigator.pop(context);
                          }, child: Text("No")),
                        ],);
                    },);
                  },
                  child: Text(
                    "LogOut",
                    style:
                    TextStyle(fontSize: 15, color: Colors.white),
                  ))
            ],
            title: const Text("Home Page",
                style: TextStyle(color: Colors.white54)),
            centerTitle: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
            ),
          ),
          body: Stack(children: [
            Image.asset("assets/images/Sky_Blue_Wallpaper.jpeg",
                height: double.infinity,
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                fit: BoxFit.fill),
            TabBarView(
              children: [
                Padding(
                    padding: const EdgeInsets.only(
                        bottom: 20.0, top: 20, left: 20, right: 20),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: getData.length,
                      itemBuilder: (context, index) {
                        return Slidable(
                          endActionPane:
                          ActionPane(motion: ScrollMotion(), children: [
                            SlidableAction(
                              onPressed: (context) {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text(
                                          "are you sure you want to delete?"),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            deleteApi();
                                            Navigator.pop(context);
                                          },
                                          child: const Text("yes"),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            setState(() {});
                                            Navigator.pop(context);
                                          },
                                          child: const Text("no"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              backgroundColor: const Color(0xff103C78),
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'Delete',
                            ),
                          ]),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.all(10),
                            height: 70,
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
                            decoration: BoxDecoration(
                              color: getData[index]["status"] == true ?
                              Color(0xff103C78)
                                  : Colors.blueGrey,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(children: [
                              Text(getData[index]["task"], style: TextStyle(
                                color: getData[index]["status"] == true ?
                                Colors.blueGrey
                                    : Color(0xff103C78),)),
                              GestureDetector(
                                  onTap: () {
                                    getData[index]['status'] == true
                                        ? SizedBox()
                                        : showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text("Complete"),
                                            content: Text(
                                                "Are you sure want to complete the task?"),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    /*getData[index][
                                                                    'status'] = "true";*/
                                                    id = getData[index]
                                                    ['id'];
                                                    putApi();
                                                    setState(() {});
                                                    Navigator.pop(
                                                        context);
                                                  },
                                                  child: Text("Yes")),
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(
                                                        context);
                                                  },
                                                  child: Text("No"))
                                            ],
                                          );
                                        });
                                    setState(() {});
                                  },
                                  child: getData[index]['status'] == true
                                      ? Icon(
                                    Icons.check_box,
                                    color: Colors.blueGrey,
                                    size: 35,
                                  )
                                      : Icon(
                                    Icons.check_box_outline_blank,
                                    color: Color(0xff103C78),
                                    size: 35,
                                  )),
                            ]),
                          ),
                        );
                      },
                    )),
                Padding(
                    padding: const EdgeInsets.only(
                        bottom: 20.0, top: 20, left: 20, right: 20),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: getData.length,
                      itemBuilder: (context, index) {
                        return getData[index]["status"]==false?
                          Slidable(
                          endActionPane:
                          ActionPane(motion: ScrollMotion(), children: [
                            SlidableAction(
                              onPressed: (context) {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text(
                                          "are you sure you want to delete?"),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            deleteApi();
                                            Navigator.pop(context);
                                          },
                                          child: const Text("yes"),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            setState(() {});
                                            Navigator.pop(context);
                                          },
                                          child: const Text("no"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              backgroundColor: const Color(0xff103C78),
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'Delete',
                            ),
                          ]),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.all(10),
                            height: 70,
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
                            decoration: BoxDecoration(
                              color: getData[index]["status"] == true ?
                              Color(0xff103C78)
                                  : Colors.blueGrey,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(children: [
                              Text(getData[index]["task"], style: TextStyle(
                                color: getData[index]["status"] == true ?
                                Colors.blueGrey
                                    : Color(0xff103C78),)),
                              GestureDetector(
                                  onTap: () {
                                    getData[index]['status'] == true
                                        ? SizedBox()
                                        : showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text("Complete"),
                                            content: Text(
                                                "Are you sure want to complete the task?"),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    /*getData[index][
                                                                    'status'] = "true";*/
                                                    id = getData[index]
                                                    ['id'];
                                                    putApi();
                                                    setState(() {});
                                                    Navigator.pop(
                                                        context);
                                                  },
                                                  child: Text("Yes")),
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(
                                                        context);
                                                  },
                                                  child: Text("No"))
                                            ],
                                          );
                                        });
                                    setState(() {});
                                  },
                                  child: getData[index]['status'] == true
                                      ? Icon(
                                    Icons.check_box,
                                    color: Colors.blueGrey,
                                    size: 35,
                                  )
                                      : Icon(
                                    Icons.check_box_outline_blank,
                                    color: Color(0xff103C78),
                                    size: 35,
                                  )),
                            ]),
                          ),
                        )
                            :SizedBox();
                      },
                    )),
                Padding(
                    padding: const EdgeInsets.only(
                        bottom: 20.0, top: 20, left: 20, right: 20),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: getData.length,
                      itemBuilder: (context, index) {
                        return getData[index]["status"]==true?
                          Slidable(
                          endActionPane:
                          ActionPane(motion: ScrollMotion(), children: [
                            SlidableAction(
                              onPressed: (context) {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text(
                                          "are you sure you want to delete?"),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            deleteApi();
                                            Navigator.pop(context);
                                          },
                                          child: const Text("yes"),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            setState(() {});
                                            Navigator.pop(context);
                                          },
                                          child: const Text("no"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              backgroundColor: const Color(0xff103C78),
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'Delete',
                            ),
                          ]),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.all(10),
                            height: 70,
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
                            decoration: BoxDecoration(
                              color: getData[index]["status"] == true ?
                              Color(0xff103C78)
                                  : Colors.blueGrey,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(children: [
                              Text(getData[index]["task"], style: TextStyle(
                                color: getData[index]["status"] == true ?
                                Colors.blueGrey
                                    : Color(0xff103C78),)),
                              GestureDetector(
                                  onTap: () {
                                    getData[index]['status'] == true
                                        ? SizedBox()
                                        : showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text("Complete"),
                                            content: Text(
                                                "Are you sure want to complete the task?"),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    /*getData[index][
                                                                    'status'] = "true";*/
                                                    id = getData[index]
                                                    ['id'];
                                                    putApi();
                                                    setState(() {});
                                                    Navigator.pop(
                                                        context);
                                                  },
                                                  child: Text("Yes")),
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(
                                                        context);
                                                  },
                                                  child: Text("No"))
                                            ],
                                          );
                                        });
                                    setState(() {});
                                  },
                                  child: getData[index]['status'] == true
                                      ? Icon(
                                    Icons.check_box,
                                    color: Colors.blueGrey,
                                    size: 35,
                                  )
                                      : Icon(
                                    Icons.check_box_outline_blank,
                                    color: Color(0xff103C78),
                                    size: 35,
                                  )),
                            ]),
                          ),
                        )
                            :SizedBox();
                      },
                    )),


              ],
            )
          ]),
          floatingActionButton: FloatingActionButton(
              onPressed: () {
                taskName.clear();
                showModalBottomSheet(
                  isDismissible: false,
                  context: context,
                  backgroundColor: Colors.transparent,

                  builder: (context) {
                    return Container(
                      height: 360,
                      padding:  EdgeInsets.only(
                          top: 30, right: 40, left: 40,bottom: MediaQuery.of(context).viewInsets.bottom+4),
                      decoration: BoxDecoration(
                        color: const Color(0xff89C2FE).withOpacity(0.70),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Form(
                        key: formKey,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Task name",
                                  style: TextStyle(
                                    color: Color(0xff103C78),
                                    fontSize: 16,
                                  )),
                              Padding(
                                padding:
                                const EdgeInsets.only(top: 10, bottom: 15),
                                child: TextFormField(
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Enter name";
                                    }
                                  },
                                  controller: taskName,
                                  keyboardType: TextInputType.emailAddress,
                                  style: const TextStyle(
                                      color: Color(0xff103C78),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16),
                                  decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Color(0xff103C78)),
                                          borderRadius:
                                          BorderRadius.circular(35)),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xff103C78)
                                                  .withOpacity(0.60)),
                                          borderRadius:
                                          BorderRadius.circular(35)),
                                      hintText: " please enter task name",
                                      hintStyle: const TextStyle(
                                        color: Color(0xff103C78),
                                        fontWeight: FontWeight.w300,
                                        fontSize: 13,
                                      )),
                                ),
                              ),
                              const Text("Status",
                                  style: TextStyle(
                                    color: Color(0xff103C78),
                                    fontSize: 16,
                                  )),
                              Padding(
                                padding:
                                const EdgeInsets.only(top: 10, bottom: 15),
                                child: TextFormField(
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Enter your status";
                                    }
                                  },
                                  keyboardType: TextInputType.emailAddress,
                                  style: TextStyle(
                                      color: Color(0xff103C78),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16),
                                  decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xff103C78)),
                                          borderRadius:
                                          BorderRadius.circular(35)),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xff103C78)
                                                  .withOpacity(0.60)),
                                          borderRadius:
                                          BorderRadius.circular(35)),
                                      hintText: " please enter status",
                                      hintStyle: const TextStyle(
                                        color: Color(0xff103C78),
                                        fontWeight: FontWeight.w300,
                                        fontSize: 13,
                                      )),
                                ),
                              ),
                              Container(
                                height: 50,
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width,
                                margin: const EdgeInsets.only(
                                    left: 100, right: 100, top: 20),
                                padding:
                                const EdgeInsets.only(top: 15, bottom: 13),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(colors: [
                                    Color(0xff2B5287),
                                    Color(0xff2B5287),
                                    Color(0xff89C2FE),
                                    Color(0xff2B5287)
                                  ]),
                                  borderRadius: BorderRadius.circular(35),
                                ),
                                child: Center(
                                  child: InkWell(
                                    onTap: () {
                                      if (formKey.currentState!.validate()) {
                                        postApi();
                                        setState(() {});
                                        Navigator.pop(context);
                                      }
                                    },
                                    child: const Text(
                                      "Submit",
                                      style: TextStyle(
                                        color: Color(0xFFFFFFFF),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                      ),
                    );
                  },
                );
              },
              backgroundColor: const Color(0xff103C78),
              elevation: 20,
              child: const Icon(Icons.add, color: Colors.white54)),
        ),
      ),
    );
  }

  void deleteApi() async {
    setState(() {});

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");

    http.Response response = await http.delete(
        Uri.parse("https://todo-list-app-kpdw.onrender.com/api/tasks/$id"),
        headers: {"x-access-token": "$token"});
    print("Status Code = ${response.statusCode}");
    print("Body = ${response.body}");
    if (response.statusCode == 200) {
      getApi();
      Fluttertoast.showToast(
          msg: "${jsonDecode(response.body)['message']}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.indigo,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      print("Body = ${jsonDecode(response.body)['message']}");
      Fluttertoast.showToast(
          msg: "${jsonDecode(response.body)['message']}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.indigo,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  void getApi() async {
    setState(() {});
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");

    http.Response response = await http.get(
        Uri.parse("https://todo-list-app-kpdw.onrender.com/api/tasks"),
        headers: {"x-access-token": "$token"});
    print("Status Code = ${response.statusCode}");
    print("Body = ${response.body}");
    print("Body = ${jsonDecode(response.body)}");
    getData = jsonDecode(response.body);
    setState(() {});

    if (response.statusCode == 200) {
      //print("Successfully");
      Fluttertoast.showToast(
          msg: "Get data successfully!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.indigo,
          textColor: Colors.white,
          fontSize: 16.0);
    } else if (response.statusCode == 401) {
      prefs.clear();
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginApi(),
          ));
    } else {
      print("Body = ${jsonDecode(response.body)['message']}");
      Fluttertoast.showToast(
          msg: "${jsonDecode(response.body)['message']}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.indigo,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  void postApi() async {
    setState(() {});
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");

    http.Response response = await http.post(
        Uri.parse("https://todo-list-app-kpdw.onrender.com/api/tasks"),
        body: {"task": taskName.text, "status": "false"},
        headers: {"x-access-token": "$token"});
    print("Status Code = ${response.statusCode}");
    print("Body = ${response.body}");


    if (response.statusCode == 200) {
      getApi();
      Fluttertoast.showToast(
          msg: "Add data successfully!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.indigo,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      print("Body = ${jsonDecode(response.body)['message']}");
      Fluttertoast.showToast(
          msg: "${jsonDecode(response.body)['message']}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.indigo,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  void putApi() async {
    setState(() {});
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    http.Response response = await http.put(
        Uri.parse("https://todo-list-app-kpdw.onrender.com/api/tasks/$id"),
        body: {
          // "description": "${getData[i]['description']}",
          "status": "true"
        },
        headers: {
          "x-access-token": "$token"
        });
    print("Status Code = ${response.statusCode}");
    print("Body = ${response.body}");
    if (response.statusCode == 200) {
      //print("Successfully");
      getApi();
      Fluttertoast.showToast(
          msg: "${jsonDecode(response.body)['message']}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.indigo,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      print("Body = ${jsonDecode(response.body)['message']}");
      Fluttertoast.showToast(
          msg: "${jsonDecode(response.body)['message']}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.indigo,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}
