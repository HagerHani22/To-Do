import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../modules/registerproject/login.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

var scaffoldkey = GlobalKey<ScaffoldState>();
var formkey = GlobalKey<FormState>();

var titleController = TextEditingController();
var timeController = TextEditingController();
var dateController = TextEditingController();

class HomeLayout extends StatelessWidget {
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {
          if (state is AppInsertDatabaseState) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldkey,
            appBar: AppBar(
              title: Text(cubit.titles[cubit.currentIndex],style: TextStyle(color: Colors.white),),
              backgroundColor: Colors.lightBlue,
              actions: [
                TextButton(
                    onPressed: () async{
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.remove('email');

                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => NewLogin()),
                            (route) => false,
                      );
                    },
                    child: const Text(
                      'Logout',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ))
              ],
            ),
            body: cubit.screens[cubit.currentIndex],
            floatingActionButton: FloatingActionButton(
              foregroundColor: Colors.white,
                onPressed: () {
                  if (cubit.isbottomsheetshown) {
                    if (formkey.currentState!.validate()) {
                      cubit.insertToDatabase(
                        title: titleController.text,
                        data: dateController.text,
                        time: timeController.text,
                      );
                    }
                  } else {
                    scaffoldkey.currentState
                        ?.showBottomSheet(
                          (context) => Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Form(
                              key: formkey,
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextFormField(
                                      controller: titleController,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        labelText: 'task title',
                                        prefixIcon: const Icon(Icons.title),
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'title must not be empty';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    TextFormField(
                                      controller: timeController,
                                      keyboardType: TextInputType.datetime,
                                      onTap: () {
                                        showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now(),
                                        ).then((value) {
                                          print(value?.format(context));
                                          timeController.text =
                                              value!.format(context);
                                        });
                                      },
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        labelText: 'Task Time',
                                        prefixIcon: const Icon(Icons.watch_later),
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Time must not be empty';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    TextFormField(
                                      controller: dateController,
                                      keyboardType: TextInputType.datetime,
                                      onTap: () {
                                        showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime.now(),
                                          lastDate:
                                              DateTime.parse('2024-12-02'),
                                        ).then((value) {
                                          print(DateFormat.yMMMd()
                                              .format(value!));
                                          dateController.text =
                                              DateFormat.yMMMd().format(value);
                                        });
                                      },
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        labelText: 'Task date',
                                        prefixIcon: const Icon(Icons.calendar_today),
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'date must not be empty';
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                        .closed
                        .then((value) {
                      cubit.changeBottomSheetState(
                          isshow: false, icon: Icons.edit);
                    });
                      cubit.changeBottomSheetState(isshow: true, icon: Icons.add);
                  }

                  // insertToDatabase();
                  ///////////TO handling with error
                  // try{
                  //   var name =await getName();
                  //   print(name);
                  //   throw(' I have an error');
                  // }catch(error){
                  //   print('${error.toString()}');
                  // }
                  // getName().then((value) {
                  //   print(value);
                  //   throw (' I have an error');
                  // }).catchError((error) {
                  //   print('${error.toString()}');
                  // });
                },
                backgroundColor: Colors.lightBlue,
                child: Icon(cubit.fabicon)),
            bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: cubit.currentIndex,
                onTap: (index) {
                  cubit.changeIndex(index);
                },
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.menu), label: 'Tasks'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.check_circle_outline), label: 'Done'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.archive_outlined), label: 'Archived'),
                ]),
          );
        },
      ),
    );
  }
}

// Future<String> getName() async {
//   return 'hager ';
// }
