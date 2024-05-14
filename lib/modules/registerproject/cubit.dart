
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/modules/registerproject/states.dart';

class ProjectCubit extends Cubit<ProjectStates> {
  ProjectCubit() : super(AppInitialState());

  static ProjectCubit get(context) => BlocProvider.of(context);

  List<Map> register = [];

  bool isPassword = true;
  IconData Icon = Icons.visibility_off;
  void changepass() {
    isPassword = !isPassword;
    if (isPassword) {
      Icon = Icons.visibility_off;
    } else {
      Icon = Icons.visibility;
    }
    emit(ChangepasswordState());
  }

  Database? database;
  void createDatabase() async {
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
    required String confirmPassword,
  }) async {
    await database?.transaction((txn) async {
      await txn
          .rawInsert(
              'INSERT INTO register(name,email,phone,password,confirm_password) VALUES("$name","$email","$phone","$password","$confirmPassword") ')
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

  Future<bool> authenticateUser({
    required String email,
    required String password,
      })
async {
    var result = await database!.rawQuery(
      'SELECT * FROM register WHERE email = ? AND password = ?',
      [email, password],
    );
    print(result);
    return result.isNotEmpty;
  }

}
