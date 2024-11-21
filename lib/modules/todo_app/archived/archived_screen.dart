import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../layout/todoapp/cubit/cubit.dart';
import '../../../layout/todoapp/cubit/states.dart';
import '../../../shared/components/components.dart';

class ArchivedScreen extends StatelessWidget {
  const ArchivedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var tasks= AppCubit.get(context).archivedTasks;
        return  tasks.isEmpty?appTasks():ListView.separated(
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
  return const Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.menu,size: 100,color: Colors.grey,),
        Text('NO Tasks Yet ,Please Add Some Tasks',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.grey),),
      ],
    ),
  );

}