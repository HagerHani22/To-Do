import 'package:flutter/material.dart';

import '../../layout/todoapp/cubit/cubit.dart';

Widget defaultButton({
  double width = double.infinity,
  Color background = Colors.blue,
  @required Function()? function,
  required String text,
}) => Container(
      width: width,
      height: 40,
      color: background,
      child: MaterialButton(
        onPressed: function,
        child: Text(
          text.toUpperCase(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
    );
///////////////////////////////////////////////////////////////////////

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  validate,
  onChange,
  onTap,
  onSubmitted,
  required String label,
  required IconData prefix,
  bool ispassword = false,
  IconData? suffix,
  Function()? suffixPressed,
}) => TextFormField(
      onTap: onTap,
      keyboardType: type,
      controller: controller,
      onChanged: onChange,

      onFieldSubmitted: onSubmitted,
      obscureText: ispassword,
      validator: validate,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: label,
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 8.0,right: 10),
          child: Icon(prefix),
        ),
        suffixIcon: IconButton(onPressed: suffixPressed, icon: Icon(suffix)),
      ),
    );

///////////////////////////////////////////////////////////////////////////////////////

Widget defaultNumber({
  @required String? text,
  required onPressed,
  Color btncolor = Colors.cyan,
}) => Expanded(
      child: MaterialButton(
        onPressed: onPressed,
        child: Text(
          text!,
          style: TextStyle(
              fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        color: btncolor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.elliptical(8, 8))),
        height: 20,
        padding: EdgeInsets.symmetric(vertical: 20),
      ),
    );
///////////////////////////////////////////////////////////////////////////////////////////

Widget buildTaskItem(Map model, context) => Dismissible(
      key: Key(model['id'].toString()),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 35,
              backgroundColor: Colors.lightBlue,
              child: Text('${model['time']}'),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${model['title']}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    '${model['data']}',
                    style: TextStyle(color: Colors.grey),
                  )
                ],
              ),
            ),
            SizedBox(
              width: 20,
            ),
            IconButton(
                onPressed: () {
                  AppCubit.get(context)
                      .updateData(status: 'done', id: model['id']);
                },
                icon: Icon(
                  Icons.check_box_rounded,
                  color: Colors.green,
                )),
            IconButton(
                onPressed: () {
                  AppCubit.get(context)
                      .updateData(status: 'archived', id: model['id']);
                },
                icon: Icon(
                  Icons.archive_outlined,
                  color: Colors.grey,
                )),
          ],
        ),
      ),
      onDismissed: (direction) {
        AppCubit.get(context).deleteData(id: model['id']);
      },
    );
/////////////////////////////////////////////////////////////////////////////////////////

Widget buildArticleItems(article, context) {
  return Padding(
    padding: const EdgeInsets.all(20.0),
    child: Row(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
              image: NetworkImage('${article['urlToImage']}'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(
          width: 20,
        ),
        Expanded(
          child: Container(
            height: 120,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    '${article['title']}',
                    style: Theme.of(context).textTheme.displayMedium,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text('${article['publishedAt']}',
                    style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        )
      ],
    ),
  );
}

/////////////////////////////////////////////////////////////////////////////////////////
Widget myDivider() => Container(
      width: double.infinity,
      height: 2,
      color: Colors.grey[300],
    );
////////////////////////////////////////////////////////////////////////////////
// void showToast({required String text, required ToastStates state}) =>
//     Fluttertoast.showToast(
//       msg: text,
//       toastLength: Toast.LENGTH_LONG,
//       gravity: ToastGravity.BOTTOM,
//       timeInSecForIosWeb: 5,
//       backgroundColor: chooseToastColor(state),
//       textColor: Colors.white,
//       fontSize: 16,
//     );

//enum
enum ToastStates { SUCCESS, WARNING, ERROR }

Color chooseToastColor(ToastStates state) {
  Color color;
  switch (state) {
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastStates.ERROR:
      color = Colors.red;
      break;
    case ToastStates.WARNING:
      color = Colors.amber;
      break;
  }
  return color;
}
//////////////////////////////////////////////////////////////////////////////
Widget defaultAppBar({
  String ?title,
  required BuildContext context,
  List<Widget>?actions,
}){

  return AppBar(
    leading: IconButton(onPressed: () {
      Navigator.pop(context);
    },icon: Icon(Icons.arrow_left)),
  title: Text('add post'),
    actions: actions,
);
}