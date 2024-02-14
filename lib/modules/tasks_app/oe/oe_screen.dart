import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:tasks/modules/tasks_app/oe/oe_cubit/cubit.dart';
import 'package:collection/collection.dart';

import '../../../shared/components/component.dart';
import 'oe_cubit/states.dart';

var titleController = TextEditingController();
var noteController = TextEditingController();
var typeController = TextEditingController();
var deadlineController = TextEditingController();
var timeController = TextEditingController();
var dateController = TextEditingController();

String? dropdownValue;

var scaffoldkey = GlobalKey<ScaffoldState>();

class OE_Screen extends StatefulWidget {
  const OE_Screen({super.key});

  @override
  State<OE_Screen> createState() => _OE_ScreenState();
}
var formkey = GlobalKey<FormState>();

class _OE_ScreenState extends State<OE_Screen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OETasksCubits, OETasksStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = OETasksCubits.get(context);
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
            body: TabBarView(children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                
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
                
                    SingleChildScrollView(
                      child: Wrap(
                        children: cubit.OE
                            .mapIndexed((index, itemX) => Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: gridTasks(cubit.OE[index], context),
                                ))
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                child: Wrap(
                  children: cubit.doneTasks
                      .mapIndexed((index, itemX) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: gridTasks(cubit.doneTasks[index], context),
                          ))
                      .toList(),
                ),
              ),
            ]),
            floatingActionButton:FloatingActionButton(
                backgroundColor: HexColor('#ba4c31'),
                onPressed: () {
                  if (cubit.isbottomsheetshown) {
                    if(formkey.currentState!.validate()){
                      cubit.insertToDatabase(
                        title: titleController.text,
                        date: dateController.text,
                        time: timeController.text,
                        deadline: deadlineController.text,
                        note: noteController.text,
                        type: dropdownValue!,
                      );
                      Navigator.pop(context);
                      titleController.clear();
                      dateController.clear();
                      timeController.clear();
                      deadlineController.clear();
                      noteController.clear();
                      dropdownValue = null;
                    }

                  } else {
                    scaffoldkey.currentState
                        ?.showBottomSheet((context) => Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: SingleChildScrollView(
                                child: Form(
                                  key: formkey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      defaultFormField(
                                        readonly: false,
                                        controller: titleController,
                                        type: TextInputType.text,
                                        label: 'Task Title',
                                        validate: (value) {
                                          if (value!.isEmpty) {
                                            return 'Enter Your Task Title';
                                          }
                                          return null;
                                        },

                                        prefix: Icons.title,
                                        color: HexColor('#eee6d6'),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: defaultFormField(
                                                readonly: false,
                                                controller: deadlineController,
                                                type: TextInputType.datetime,
                                                label: 'Deadline',
                                                validate: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'Add Your Deadline';
                                                  }
                                                  return null;
                                                },
                                                prefix: Icons.date_range,
                                                color: HexColor('#eee6d6'),
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(10)),
                                                onTap: () {
                                                  showDatePicker(
                                                          context: context,
                                                          firstDate: DateTime.now(),
                                                          lastDate: DateTime.parse(
                                                              '2024-12-31'))
                                                      .then((value) {
                                                    print(DateFormat.yMMMd()
                                                        .format(value!));
                                                    deadlineController.text =
                                                        DateFormat.yMMMd()
                                                            .format(value);
                                                  });
                                                }),
                                          ),
                                          SizedBox(
                                            width: 14,
                                          ),
                                          Expanded(
                                            child: DropdownButtonFormField(
                                              isExpanded: true,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(10)),
                                                filled: true,
                                                fillColor: HexColor('#eee6d6'),
                                              ),
                                              dropdownColor: HexColor('#eee6d6'),
                                              validator: (value) {
                                                if (value == null || value.isEmpty) {
                                                  return 'Please select an option';
                                                }
                                                return null;
                                              },
                                              value: dropdownValue,
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  dropdownValue = newValue!;
                                                });
                                              },
                                              hint: Text('Select Task Type'),
                                              items: <String>['Flutter', 'Web']
                                                  .map<DropdownMenuItem<String>>(
                                                      (String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(
                                                    value,
                                                    style: TextStyle(fontSize: 20),
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      defaultFormField(
                                        readonly: false,
                                        numLines: 3,
                                        controller: noteController,
                                        type: TextInputType.text,
                                        hintText: 'Add Note',
                                        validate: (value) {
                                          if (value!.isEmpty) {
                                            return 'Add Your Note';
                                          }
                                          return null;
                                        },

                                        color: HexColor('#eee6d6'),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ))
                        .closed
                        .then((value) {
                      cubit.changeBottomSheetState(
                          isshow: false, icon: Icons.edit);
                    });
                    cubit.changeBottomSheetState(isshow: true, icon: Icons.add);
                  }
                },
                child: Icon(cubit.fabicon, color: HexColor('#eee6d6'))),
          ),
        );
      },
    );
  }
}

Widget gridTasks(model, context) {
  return Container(
    width: 150,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      color: HexColor('#eee6d6'),
    ),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                  child: IconButton(
                      onPressed: () {
                        OETasksCubits.get(context)
                            .updateData(status: 'done', id: model['id']);
                      },
                      icon: model['status'] == 'new'
                          ? Icon(
                              Icons.circle_outlined,
                              size: 20,
                            )
                          : Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 20,
                            ))),
              Spacer(),
              Expanded(
                  child: IconButton(
                      onPressed: () {
                        OETasksCubits.get(context)
                            .showAlertDialogForRow(context, model);
                      },
                      icon: Icon(
                        Icons.delete,
                        size: 20,
                        color: Colors.red,
                      ))),
            ],
          ),
          Center(
            child: Text(
              '${model['title']}',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
            ),
          ),
          model['status'] == 'new'
              ? Text(
                  '${model['note']}',
                  maxLines: 10,
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
                )
              : Text('${model['note']}',
                  maxLines: 10,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[600],
                    decoration: TextDecoration.lineThrough,
                  )),
          SizedBox(height: 8,),
          Row(
            children: [
              Text('${model['type']}',style:TextStyle(color: Colors.red),),
              Spacer(),
              Text('${model['deadline']}',
                  style: TextStyle(
                      color: Colors.grey[600], fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    ),
  );
}
