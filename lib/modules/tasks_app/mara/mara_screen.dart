import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';

import 'package:tasks/shared/components/component.dart';

import 'buildtasks.dart';
import 'mara_add_task/mara_add_task.dart';
import 'mara_cubit/cubit.dart';
import 'mara_cubit/states.dart';
String? dropdownValue;

class Mara_Screen extends StatefulWidget {
  const Mara_Screen({super.key});

  @override
  State<Mara_Screen> createState() => _Mara_ScreenState();
}
var scaffoldkey = GlobalKey<ScaffoldState>();

class _Mara_ScreenState extends State<Mara_Screen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MaraTasksCubits, MaraTasksStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = MaraTasksCubits.get(context);
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            key:scaffoldkey ,
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
              children: [Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        DropdownButton<String>(
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

                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: cubit.mara.length,
                          itemBuilder: (context, index) {
                            return buildCard(cubit.mara[index], context, index);
                          },
                        ),
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
                                        builder: (context) => MaraAddTasks(),
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
              ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: cubit.doneTasks.length,
                  itemBuilder: (context, index) {
                    return buildCard(cubit.doneTasks[index], context, index);
                  },
                ),

              ],
            ),
          ),
        );
      },
    );
  }
}

