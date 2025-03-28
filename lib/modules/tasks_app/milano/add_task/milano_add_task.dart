import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:tasks/layout/cubit/cubit.dart';
import 'package:tasks/layout/cubit/states.dart';
import 'package:tasks/shared/components/component.dart';

class AddTasks extends StatefulWidget {
  final Map? taskData;

  const AddTasks({Key? key, this.taskData}) : super(key: key);

  @override
  State<AddTasks> createState() => _AddTasksState();
}

class _AddTasksState extends State<AddTasks> {
  var titleController = TextEditingController();

  var timeController = TextEditingController();

  var dateController = TextEditingController();

  var noteController = TextEditingController();

  var deadlineController = TextEditingController();

  String? dropdownValue;
  @override
  void initState() {
    super.initState();
    if (widget.taskData != null) {
      titleController.text = widget.taskData!['title'];
      timeController.text = widget.taskData!['time'];
      dateController.text = widget.taskData!['date'];
      noteController.text = widget.taskData!['note'];
      deadlineController.text = widget.taskData!['deadline'];
      dropdownValue = widget.taskData!['type'];
    }
  }

  var formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TasksCubits, TasksStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = TasksCubits.get(context);
        return Scaffold(
          appBar: AppBar(
            backgroundColor: HexColor('#ba4c31'),
            centerTitle: true,
            leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                }),
            title: const Text('Add New Tasks',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 25,
                )),
          ),
          body: Padding(
            padding: const EdgeInsets.all(12.0),
            child: SingleChildScrollView(
              child: Form(
                key: formkey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Task Title',
                        style: TextStyle(fontSize: 20),
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                      defaultFormField(
                        readonly: false,
                        controller: titleController,
                        type: TextInputType.text,
                        label: 'Task Title',
                        prefix: Icons.title,
                        color: HexColor('#eee6d6'),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        validate: (value) {
                          if (value!.isEmpty) {
                            return 'Enter Task Title';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      const Row(
                        children: [
                          Expanded(
                              child: Text(
                            'Date',
                            style: TextStyle(fontSize: 20),
                          )),
                          Expanded(
                              child: Text(
                            'Time',
                            style: TextStyle(fontSize: 20),
                          )),
                        ],
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: defaultFormField(
                                readonly: false,
                                controller: dateController,
                                type: TextInputType.datetime,
                                label: 'Date',
                                color: HexColor('#eee6d6'),
                                prefix: Icons.date_range,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                onTap: () {
                                  showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.parse('2024-12-02'),
                                  ).then((value) {
                                    print(DateFormat.yMMMd().format(value!));
                                    dateController.text =
                                        DateFormat.yMMMd().format(value);
                                  });
                                }),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Expanded(
                            child: defaultFormField(
                                readonly: false,
                                // ispassword: false,

                                controller: timeController,
                                type: TextInputType.datetime,
                                // value: cubit.time,
                                label: 'Time',
                                prefix: Icons.watch_later_outlined,
                                color: HexColor('#eee6d6'),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                onTap: () {
                                  showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                  ).then((value) {
                                    print(value?.format(context));
                                    timeController.text =
                                        value!.format(context);
                                  });
                                }),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      const Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Deadline',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          Expanded(
                              child: Text(
                            'Task Type',
                            style: TextStyle(fontSize: 20),
                          )),
                        ],
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: defaultFormField(
                              readonly: false,
                              controller: deadlineController,
                              type: TextInputType.datetime,
                              label: 'Deadline',
                              prefix: Icons.date_range,
                              color: HexColor('#eee6d6'),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              onTap: () {
                                showDatePicker(
                                        context: context,
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.parse('2030-12-31'))
                                    .then((value) {
                                  print(DateFormat.yMMMd().format(value!));
                                  deadlineController.text =
                                      DateFormat.yMMMd().format(value);
                                });
                              },
                              validate: (value) {
                                if (value!.isEmpty) {
                                  return 'Enter Deadline';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 14,
                          ),
                          Expanded(
                            child: DropdownButtonFormField(
                              isExpanded: true,
                              borderRadius: BorderRadius.circular(10),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select an option';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                filled: true,
                                fillColor: HexColor('#eee6d6'),
                              ),
                              dropdownColor: HexColor('#eee6d6'),
                              value: dropdownValue,
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownValue = newValue!;
                                });
                              },
                              hint: const Text('Select Task Type'),
                              items: <String>[
                                'Flutter',
                                'Web'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      const Text(
                        'Note',
                        style: TextStyle(fontSize: 20),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      defaultFormField(
                        readonly: false,
                        // ispassword: false,

                        controller: noteController,
                        type: TextInputType.text,
                        hintText: 'Add Note',
                        numLines: 5,
                        color: HexColor('#eee6d6'),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        validate: (value) {
                          if (value!.isEmpty) {
                            return 'Add Your Note';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: HexColor('#ba4c31'),
                                ),
                                child: TextButton(
                                    onPressed: () {
                          if (formkey.currentState!.validate()) {
                            cubit.insertToDatabase(
                              title: titleController.text,
                              date: dateController.text,
                              time: timeController.text,
                              deadline: deadlineController.text,
                              note: noteController.text,
                              type: dropdownValue!,
                            );
                            Navigator.pop(context);
                          }

                                    },
                                    child: const Text(
                                      'Save',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white),
                                    ))),
                          ),
                          // SizedBox(
                          //   width: 50,
                          // ),
                          // Expanded(
                          //   child: Container(
                          //       decoration: BoxDecoration(
                          //         borderRadius: BorderRadius.circular(20),
                          //         color: HexColor('#ba4c31'),
                          //       ),
                          //       child: TextButton(
                          //           onPressed: () {},
                          //           child: Text(
                          //             'Update',
                          //             style: TextStyle(
                          //                 fontSize: 16,
                          //                 fontWeight: FontWeight.w400,
                          //                 color: Colors.white),
                          //           ))),
                          // ),
                        ],
                      )
                    ]),
              ),
            ),
          ),
        );
      },
    );
  }
}
