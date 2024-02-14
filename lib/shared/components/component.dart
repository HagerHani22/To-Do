import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:tasks/layout/cubit/cubit.dart';
import 'package:tasks/modules/tasks_app/milano/add_task/milano_add_task.dart';

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  onTap,
  validate,
  onChange,
  int? numLines,
  String? label,
  String? hintText,
  IconData? prefix,
  String? value,
  IconData? suffix,
  Function()? suffixPressed,
  InputBorder ?border,
  Color? color,
   required bool readonly,
  submit,
}) =>
    TextFormField(
      onFieldSubmitted: submit,
      initialValue: value,
      controller: controller,
      keyboardType: type,
      onTap: onTap,
      onChanged: onChange,
      readOnly:readonly ,
      maxLines: numLines,
      validator: validate,
      decoration: InputDecoration(
        fillColor: color,
        filled: true,
        labelText: label,
        hintText: hintText,
        prefixIcon: Icon(prefix),
        suffixIcon: IconButton(onPressed: suffixPressed, icon: Icon(suffix)),

        border: border,
      ),
    );
//////////////////////////////////////////////////////////////////////////////

Widget myDivider() => Container(
      width: double.infinity,
      height: 2,
      color: Colors.amber[50],
    );
//////////////////////////////////////////////////////////////////////////////
