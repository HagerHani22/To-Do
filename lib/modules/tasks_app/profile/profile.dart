import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasks/shared/network/local/cache_helper.dart';

import '../../../layout/tasks_app.dart';
import '../../../models/userdata.dart';
import '../../../shared/components/component.dart';
import '../login/cubit/cubit.dart';
import '../login/cubit/states.dart';


class ProfileScreen extends StatefulWidget {
  final UserData ?user;

  ProfileScreen({Key? key, this.user}) : super(key: key){

  }

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();

}

class _ProfileScreenState extends State<ProfileScreen> {
  var nameController = TextEditingController();

  var emailController = TextEditingController();

  var phoneController = TextEditingController();

  var passwordController = TextEditingController();

  var confirmpassController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadUserDataFromSharedPreferences();
  }

  void loadUserDataFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String name = prefs.getString('name') ?? '';
    String email = prefs.getString('emailx') ?? '';
    String phone = prefs.getString('phone') ?? '';
    String password = prefs.getString('password') ?? '';

    setState(() {
      nameController.text = name;
      emailController.text = email;
      phoneController.text = phone;
      passwordController.text = password;
    });
  }



  var formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProjectCubit, ProjectStates>(
      listener: (context, state) {},
      builder: (context, state) {
        ProjectCubit cubit = ProjectCubit.get(context);
        return Scaffold(
          appBar: AppBar(
              backgroundColor: Colors.white,
                  title: Text(
            'Profile',
            style: TextStyle(color: Colors.black,
                ),
          ),

          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Form(
                key: formkey,
                child: Column(children: [

                  Center(child: CircleAvatar(child: Image(image: AssetImage('assets/image/img.png')),radius: 40,)),

                  SizedBox(
                    height: 20,
                  ),
                  defaultFormField(
                      controller: nameController,
                      type: TextInputType.name,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                      label: 'Your name',
                      color: Colors.white,
                      readonly: true,
                      prefix: Icons.person,
                      validate: (value) {
                        if (value.isEmpty) {
                          return 'Enter Your name';
                        }
                        return null;
                      }),
                  SizedBox(
                    height: 20,
                  ),
                  defaultFormField(
                      controller: emailController,
                      type: TextInputType.emailAddress,
                      label: 'Your Email',
                      color: Colors.white,
                      prefix: Icons.email,
                      readonly: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                      validate: (value) {
                        if (value.isEmpty) {
                          return 'Please enter an email address';
                        } else if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$').hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      }),
                  SizedBox(
                    height: 20,
                  ),
                  defaultFormField(
                      // ispassword: false,

                      controller: phoneController,
                      type: TextInputType.number,
                      label: 'Your Phone',
                      color: Colors.white,
                      prefix: Icons.phone,
                      readonly: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                      validate: (value) {
                        if (value.isEmpty) {
                          return 'Enter Your Mobile Number';
                        }else if (!RegExp(r'(^(010|012|015|011)\d{8}$)').hasMatch(value)) {
                          return 'Please enter a valid Mobile Number';
                        }
                        return null;
                      }),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    readOnly: true,
                    keyboardType: TextInputType.visiblePassword,
                    controller: passwordController,
                    obscureText: cubit.ispassword,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                      fillColor:Colors.white,
                      labelText: 'Your password',
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon:IconButton(onPressed: () {
                        cubit.changepass();
                      }, icon: Icon(cubit.Icon,)),
                    ),

                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter Your password';
                      }
                      return null;
                    },
                  )


                ]),
              ),
            ),
          ),
        );
      },
    );
  }
}
