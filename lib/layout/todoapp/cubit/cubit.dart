import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/layout/todoapp/cubit/states.dart';

import '../../../modules/todo_app/archived/archived_screen.dart';
import '../../../modules/todo_app/done/done_screen.dart';
import '../../../modules/todo_app/tasks/tasks_screen.dart';


class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  var currentIndex = 0;
  List<Widget> screens = [
    TasksScreen(),
    const DoneScreen(),
    const ArchivedScreen(),
  ];
  List<String> titles = [
    'Tasks_Screen',
    'Done_screen',
    'Archived_screen',
  ];

  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  Database? database;

  void createDatabase() async {
    await openDatabase(
      'Todo.db',
      version: 1,
      onCreate: (database, version) {
        print('database created');
        database.execute(
                'CREATE TABLE tasks(id INTEGER PRIMARY KEY,title TEXT ,data TEXT,time TEXT,status TEXT)')
            .then((value) {
          print('table created');
        }).catchError((error) {
          print('Error when creating table ${error.toString()}');
        });
      },
      onOpen: (database) {
        getDataFromDatabase(database);
        // print(database);
        print('database opened');
      },
    ).then((value) {
      print(value);
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  Future insertToDatabase({
    @required String? title,
    @required String? data,
    @required String? time,
  }) async {
    // print(database);
    // print(tasks);

    await database?.transaction((txn) async {
      await txn
          .rawInsert(
              'INSERT INTO tasks(title,data,time,status) VALUES("$title","$data","$time","new") ')
          .then((value) {
        print('$value inserted successfully');
        emit(AppInsertDatabaseState());
        getDataFromDatabase(database);
      }).catchError((error) {
        print('Error when inserting new row ${error.toString()}');
      });
      return null;
    });
  }

 void getDataFromDatabase(database) async {
   newTasks = [];
   doneTasks = [];
   archivedTasks = [];

   database!.rawQuery('SELECT * FROM tasks').then((value) {

       value.forEach((element){
         if(element['status']=='new') {
           newTasks.add(element);
         } else if(element['status']=='done'){
           doneTasks.add(element);}
         else {
           archivedTasks.add(element);
         }});
       emit(AppGetDatabaseState());
     });
  }
  void updateData({required String status, required int id}) {
    database?.rawUpdate(
      'UPDATE tasks SET status = ? WHERE id = ?',
      [status, id],
    ).then((value) {
      getDataFromDatabase(database);
      emit(AppUpdateDatabaseState());
    });
  }


  void deleteData({ required int id}) {
    database?.rawDelete(
      'DELETE FROM tasks WHERE id = ?',
      [id],
    ).then((value) {
      getDataFromDatabase(database);
      emit(AppDeleteDatabaseState());
    });
  }


  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;
  void changeBottomSheetState({
    required bool isShow,
    required IconData icon,
  }) {
    isBottomSheetShown = isShow;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }




}
