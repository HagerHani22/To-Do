import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tasks/modules/tasks_app/login/cubit/states.dart';

import '../../../../models/userdata.dart';

class ProjectCubit extends Cubit<ProjectStates> {
  ProjectCubit() : super(AppInitialState());

  static ProjectCubit get(context) => BlocProvider.of(context);

  List<Map> register = [];

  bool ispassword = true;
  IconData Icon = Icons.visibility_off;
  void changepass() {
    ispassword = !ispassword;
    if (ispassword) {
      Icon = Icons.visibility_off;
    } else {
      Icon = Icons.visibility;
    }
    emit(ChangepasswordState());
  }

  Database? database;
  void creatDatabase() async {
    await openDatabase(
      'Register.db',
      version: 1,
      onCreate: (database, version) {
        print('Database Created');
        database
            .execute(
                'CREATE TABLE register(name TEXT ,email TEXT,phone INTEGER,password TEXT,confirm_password TEXT)')
            .then((value) {
          print('Table Created');
        });
      },
      onOpen: (database) {
        print('Database opened');
        getDatabase(database);
      },
    ).then((value) {
      database = value;
      print(value);
      emit(CreatDatabaseState());
    });
  }

  Future insertDatabase({
    required String name,
    required String email,
    required int phone,
    required String password,
    required String confirmpassword,
  }) async {
    await database?.transaction((txn) async {
      await txn
          .rawInsert(
              'INSERT INTO register(name,email,phone,password,confirm_password) VALUES("$name","$email","$phone","$password","$confirmpassword") ')
          .then((value) {
        print('$value inserted successfully');
        emit(InsertDatabaseState());
        getDatabase(database);
      });
      return null;
    });
  }

  void getDatabase(database) async {
    register = [];
    await database!.rawQuery('SELECT * FROM register').then((value) {
      register = value;
      emit(getDatabaseState());
    });
  }
  UserData?userDataModel;
  Future<bool> authenticateUser(context,{
    required String email,
    required String password,
      })
async {
    var result = await database!.rawQuery(
      'SELECT * FROM register WHERE email = ? AND password = ?',
      [email, password],
    );
    if (result.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid email or password.'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
    userDataModel=UserData.fromJson(result[0]);
    print('name${userDataModel!.name}');
    await saveUserData(userDataModel!);

    return true;
  }



  Future<void> saveUserData(UserData userData) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('name', userData.name ?? '');
      await prefs.setString('emailx', userData.email ?? '');
      await prefs.setString('phone', userData.phone ?? '');
      await prefs.setString('password', userData.password ?? '');
    } catch (error) {
      print('Error saving user data to shared preferences: $error');
    }
  }







}
