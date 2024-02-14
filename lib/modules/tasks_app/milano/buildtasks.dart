import 'package:flutter/material.dart';
import '../../../layout/cubit/cubit.dart';
import 'add_task/milano_add_task.dart';

Widget buildTasks(Map model, context) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: TextButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
            builder: (context) => AddTasks(taskData: model),
        ));
      },
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              model['status'] == 'new'
                  ? Text(
                '${model['title']}',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Colors.black),
              )
                  : Text(
                '${model['title']}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              Row(
                children: [
                  model['status'] == 'new'
                      ? Text(
                    '${model['deadline']}',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey),
                  )
                      : Text(
                    '${model['deadline']}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  model['status'] == 'new'
                      ? Text('${model['type']}',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey))
                      : Text('${model['type']}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                      ))
                ],
              ),
            ],
          ),
          Spacer(),
          IconButton(
            onPressed: () {
              TasksCubits.get(context)
                  .updateData(status: 'done', id: model['id']);
            },
            icon: model['status'] == 'new'
                ? Icon(Icons.check_box_outline_blank, color: Colors.black)
                : Icon(Icons.check_box_rounded, color: Colors.green),
          ),
          IconButton(
              onPressed: () {
                TasksCubits.get(context).showAlertDialogForRow(context, model);
              },
              icon: Icon(
                Icons.delete,
                color: Colors.red,
              )),
        ],
      ),
    ),
  );
}
