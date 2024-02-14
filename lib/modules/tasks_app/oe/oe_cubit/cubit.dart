import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tasks/modules/tasks_app/oe/oe_cubit/states.dart';



class OETasksCubits extends Cubit<OETasksStates>{
  OETasksCubits():super(TasksInitialStates());
  static OETasksCubits get(context)=>BlocProvider.of(context);


  List<Map>OE=[];
  List<Map>doneTasks=[];
  List<Map> Flutter = [];
  List<Map> Web = [];
  List<Map> All = [];

  Database ?database;
  void creatDatabase()async {
    await openDatabase(
      'OE.db',
      version: 2,
      onUpgrade: upgradeDatabase,
      onCreate: (database, version) {
        database.execute(
            'CREATE TABLE OE(id INTEGER PRIMARY KEY,title TEXT ,date TEXT,time TEXT,deadline TEXT,type TEXT,note TEXT,status TEXT)')
            .then((value) {
          print('table created');
        }).catchError((error) {
          print('error when creating table ${error.toString()}');
        });
      },
      onOpen: (data) {
        database=data;
        getDataFromDatabase();
        print('database opened');
      },
    ).then((value) {
      database = value;
      print(value);
      emit(TasksCreateDatabaseState());
    });
  }
  Future<void> upgradeDatabase(Database database, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Add the new column to the existing table
      await database.execute('ALTER TABLE OE ADD COLUMN type TEXT');
    }
  }
  String time = '';
  String date = '';

  Future insertToDatabase({
    required String title,
    required String date,
    required String time,
    required String deadline,
    required String note,
    required String type,
  })async{
    await database?.transaction((txn) async{
      DateTime now = DateTime.now();
      String time = DateFormat('HH:mm:ss').format(now);
      String date = DateFormat('yyyy-MM-dd').format(now);

      await txn.rawInsert('INSERT INTO OE(title,date,time,deadline,type,note,status) VALUES("$title","$date","$time","$deadline","$type","$note","new") ')
          .then((value) {
        print('$value inserted successfully');
        emit(TasksInsertDatabaseState());
        getDataFromDatabase();
      }).catchError((error){
        print('Error when inserting new row ${error.toString()}');
      });
      return null;
    });
  }

  Future<void> getDataFromDatabase()async{
    OE=[];
    doneTasks=[];
    await database!.rawQuery('SELECT * FROM OE').then((value) {

      value.forEach((element){
        if(element['status']=='new')
          OE.add(element);

        else if (element['status']=='done')
          doneTasks.add(element);
      });


      emit(TasksGetDatabaseState());
    });
  }


  void getTypeFromDatabase( String type) {
    OE = [];
    doneTasks = [];
    database!.rawQuery('SELECT * FROM OE WHERE type=?',[type,],).then((value) {
      for (var element in value) {
        if (element['type'] == 'Flutter'){
          if (element['status'] == 'new'){
            OE.add(element);
          }

          else if(element['status'] == 'done') {
            doneTasks.add(element);
          }
        }

        else if(element['type'] == 'Web'){
          if (element['status'] == 'new'){
            OE.add(element);
          }

          else if(element['status'] == 'done') {
            doneTasks.add(element);
          }
        }
      }
      emit(TasksGetTypeDatabaseState());
    });
  }







  void updateData({required String status, required int id}) {
    database?.rawUpdate(
      'UPDATE OE SET status = ? WHERE id = ?',
      ['$status', id],
    ).then((value) {
      getDataFromDatabase();
      emit(TasksUpdateDatabaseState());
    });
  }



  void deleteData({ int ?id}) {
    database?.rawDelete(
      'DELETE FROM OE WHERE id = ?',
      [id],
    ).then((value) {
      getDataFromDatabase();
      emit(TasksDeleteDatabaseState());
    });
  }

  Future<void> showAlertDialogForRow(BuildContext context,model) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert!',style: TextStyle(color: Colors.red),),
          content: Text('Are you sure you want to delete this Task?',style:TextStyle(fontSize: 20,)),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel',style: TextStyle(color: Colors.black,fontSize: 17)),
            ),
            TextButton(
              onPressed: () {
                deleteData(id: model['id']);
                Navigator.of(context).pop();
              },
              child: Text('OK',style: TextStyle(color: Colors.black,fontSize: 17)),
            ),
          ],
        );
      },
    );
  }




  bool isbottomsheetshown = false;
  IconData fabicon = Icons.edit;
  void changeBottomSheetState({
    required bool isshow,
    required IconData icon,
  }) {
    isbottomsheetshown = isshow;
    fabicon = icon;
    emit(TasksChangeBottomSheetState());
  }




}



