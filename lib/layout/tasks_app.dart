import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:tasks/layout/cubit/cubit.dart';
import 'package:tasks/layout/cubit/states.dart';
import 'package:tasks/models/userdata.dart';

import '../modules/tasks_app/login/cubit/cubit.dart';
import '../modules/tasks_app/login/login.dart';
import '../modules/tasks_app/profile/profile.dart';
import '../shared/network/local/cache_helper.dart';

class Tasks_App extends StatelessWidget {
  final UserData? user;

  Tasks_App({Key? key, this.user}) : super(key: key) {}

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TasksCubits, TasksStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = TasksCubits.get(context);
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: HexColor('#ba4c31'),
            title: Text('Todo List',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 30)),
            leading: Builder(
              builder: (context) {
                return IconButton(
                  onPressed: () => Scaffold.of(context).openDrawer(),
                  icon: Icon(
                    Icons.menu,
                    color: Colors.white,
                  ),
                  tooltip:
                      MaterialLocalizations.of(context).openAppDrawerTooltip,
                );
              },
            ),
          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: HexColor('ba4c31'),
                  ),
                  child: Center(
                      child: Text(
                    'Setting',
                    style: TextStyle(
                      color: HexColor('#eee6d6'),
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                    ),
                  )),
                ),
                ListTile(
                  leading: Icon(
                    Icons.person,
                  ),
                  title: const Text('Profile'),
                  onTap: () async {

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileScreen(
                              user: ProjectCubit.get(context).userDataModel),
                        ));
                  },
                ),
                // ListTile(
                //   leading: Icon(
                //     Icons.brightness_4_outlined,
                //   ),
                //   title: const Text('Mode'),
                //   onTap: () {
                //     // Navigator.pop(context);
                //   },
                // ),
                ListTile(
                  leading: Icon(
                    Icons.exit_to_app,
                  ),
                  title: const Text('Logout'),
                  onTap: () {
                    CacheHelper.removeData(key: 'email');
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewLogin(),
                        ));
                  },
                ),
              ],
            ),
          ),
          body: cubit.Screen[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: HexColor('#ba4c31'),
            currentIndex: cubit.currentIndex,
            onTap: (value) {
              cubit.changeNavBar(value);
            },
            items: cubit.itemBottom,
          ),
        );
      },
    );
  }
}
