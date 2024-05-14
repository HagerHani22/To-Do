import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../layout/todoapp/cubit/cubit.dart';
import '../../../layout/todoapp/cubit/states.dart';
import '../../../shared/components/components.dart';

class TasksScreen extends StatelessWidget {
  // const TasksScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var tasks= AppCubit.get(context).newtasks;
        return  tasks.length==0?appTasks():ListView.separated(
          itemBuilder: (context, index) => buildTaskItem(tasks[index],context),
          separatorBuilder: (context, index) => Container(
            width: double.infinity,
            height: 1,
            color: Colors.grey[300],
          ),
          itemCount: tasks.length,
        );
      },

    );
  }
}
Widget appTasks(){
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.menu,size: 100,color: Colors.grey,),
        Text('NO Tasks Yet ,Please Add Some Tasks',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.grey),),
      ],
    ),
  );

}