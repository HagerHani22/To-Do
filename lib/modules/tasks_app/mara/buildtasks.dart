import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'mara_cubit/cubit.dart';
import 'mara_cubit/states.dart';

Widget buildCard(Map model, context,int index) {
  return BlocConsumer<MaraTasksCubits,MaraTasksStates>(
    listener: (context, state) {},
    builder: (context, state) {
      return  Card(
          elevation: 3,
          color: Colors.amberAccent[100],
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Title of task: ',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
                            ),
                            Text(
                              '${model['title']}',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Text(
                              'Type: ',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
                            ),
                            Text(
                              '${model['type']}',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Text(
                              'Deadline: ',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
                            ),
                            Text(
                              '${model['deadline']}',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                    Spacer(),
                    Column(
                      children: [
                        IconButton(
                          onPressed: () {
                            MaraTasksCubits.get(context)
                                .updateData(status: 'done', id: model['id']);                      },
                          icon: model['status'] == 'new'
                              ? Icon(
                            Icons.circle_outlined,
                            size: 20,
                          )
                              : Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 20,
                          )
                          ),

                        IconButton(
                          onPressed: () {
                            MaraTasksCubits.get(context)
                                .showAlertDialogForRow(context, model);
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            MaraTasksCubits.get(context).changeCard(index);

                          },
                          icon: Icon(
                            Icons.notes,
                          ),
                        ),
                      ],)
                  ],
                ),
                if (MaraTasksCubits.get(context).isCardVisible[index])
                  AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.linear,
                      height:
                      MaraTasksCubits.get(context).isCardVisible[index] ? 200 : 0,
                      color: Colors.grey[200],
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  '${model['time']}',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400),
                                ),
                                Spacer(),
                                Text(
                                  '${model['date']}',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                            SizedBox(height: 8,),
                            Text(
                              '${model['note']}',
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ))
              ],
            ),
          ));
    },
  );
}



List<Widget> buildCards(List<Map> models, BuildContext context,index) {
  List<Widget> cards = [];
  for (int i = 0; i < models.length; i++) {
    cards.add(
      Container(
        margin: EdgeInsets.only(bottom: 10), // Add margin between cards
        child: buildCard(models[i], context,index),
      ),
    );
  }
  return cards;
}
