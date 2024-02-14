import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:tasks/layout/cubit/cubit.dart';
import 'package:tasks/layout/cubit/states.dart';

import '../../../shared/components/component.dart';
import 'buildtasks.dart';
import 'add_task/milano_add_task.dart';

var scaffoldkey = GlobalKey<ScaffoldState>();

class Milano_Screen extends StatefulWidget {
  Milano_Screen({super.key});

  @override
  State<Milano_Screen> createState() => _Milano_ScreenState();
}

class _Milano_ScreenState extends State<Milano_Screen> {
  // List<String> title = ['All', 'Flutter', 'Web'];

  String? dropdownValue;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TasksCubits, TasksStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = TasksCubits.get(context);
        return DefaultTabController(
          length: 2,
          child: Scaffold(
              key: scaffoldkey,
              appBar: AppBar(
                backgroundColor: HexColor('#ba4c31'),
                toolbarHeight: 1,
                bottom: TabBar(
                  indicatorColor: HexColor('#dea045'),
                  tabs: [
                    Tab(
                      child: Text('Tasks',
                          style: TextStyle(
                              color: Colors.white, fontSize: 20)),
                    ),
                    Tab(
                      child: Text('Done Tasks',
                          style: TextStyle(
                              color: Colors.white, fontSize: 20)),
                    ),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // SizedBox(
                          //   width: double.infinity,
                          //   height: 30,
                          //   child: ListView.separated(
                          //       scrollDirection: Axis.horizontal,
                          //       itemBuilder: (context, index) {
                          //         return Container(
                          //           height: 100,
                          //           width: 80,
                          //           decoration: BoxDecoration(
                          //             borderRadius: BorderRadius.circular(8),
                          //             color: HexColor('f6f5f2'),
                          //           ),
                          //           child: InkWell(
                          //             onTap: () {},
                          //             child: Padding(
                          //               padding: const EdgeInsets.symmetric(horizontal: 8),
                          //               child: Center(
                          //                   child: Text(title[index],
                          //                       style: TextStyle(fontSize: 17))),
                          //             ),
                          //           ),
                          //         );
                          //       },
                          //       separatorBuilder: (context, index) {
                          //         return SizedBox(
                          //           width: 40,
                          //         );
                          //       },
                          //       itemCount: title.length),
                          // ),
                          // SizedBox(
                          //   height: 10,
                          // ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: DropdownButton<String>(
                              // dropdownColor: HexColor('#efe0b9'),
                              value: dropdownValue,
                              borderRadius: BorderRadius.circular(15),

                              items: <String>['All', 'Flutter', 'Web']
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: TextStyle(fontSize: 12),
                                  ),
                                );
                              }).toList(),
                              hint: Text('Select Task Type'),

                              onChanged: (String? newValue) {
                                setState(() {
                                  print(newValue);
                                  dropdownValue = newValue!;
                                  if(newValue=='All'){
                                    cubit.getDataFromDatabase();
                                  }else{
                                    cubit.getTypeFromDatabase(newValue);
                                  }

                                });
                              },
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),

                          SingleChildScrollView(
                            child: Container(
                              height: 360,
                              width: double.infinity,
                              color: HexColor('#eee6d6'),
                              child: ListView.separated(
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (context, index) =>
                                      buildTasks(cubit.tasks[index], context),
                                  separatorBuilder: (context, index) =>
                                      myDivider(),
                                  itemCount: cubit.tasks.length),
                            ),
                          ),
                          Spacer(),
                          Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: HexColor('#ba4c31'),
                              ),
                              child: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => AddTasks(),
                                        ));
                                  },
                                  child: Text(
                                    'Add New Task',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white),
                                  ))),
                        ]),
                  ),
                  Container(
                    height: 380,
                    width: double.infinity,
                    color: HexColor('#eee6d6'),
                    child: ListView.separated(
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) =>
                            buildTasks(cubit.doneTasks[index], context),
                        separatorBuilder: (context, index) => myDivider(),
                        itemCount: cubit.doneTasks.length),
                  ),
                ],
              )),
        );
      },
    );
  }
}
