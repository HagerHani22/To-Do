import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/modules/registerproject/states.dart';

import '../../layout/todoapp/home_layout.dart';
import '../../shared/components/components.dart';
import 'cubit.dart';
import 'home.dart';


class RegisterScreen extends StatelessWidget {
   RegisterScreen({super.key});
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProjectCubit, ProjectStates>(
      listener: (context, state) {},
      builder: (context, state) {
        ProjectCubit cubit = ProjectCubit.get(context);
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
          ),
          body: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/image/wallbut.jpg'),
                    fit: BoxFit.cover)),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(children: [
                      const Text(
                        'Register',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 35),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      defaultFormField(
                          controller: nameController,
                          type: TextInputType.name,
                          label: 'Your name',
                          prefix: Icons.person,
                          validate: (value) {
                            if (value.isEmpty) {
                              return 'Enter Your name';
                            }
                            return null;
                          }),
                      const SizedBox(
                        height: 20,
                      ),
                      defaultFormField(
                          controller: emailController,
                          type: TextInputType.emailAddress,
                          label: 'Your Email',
                          prefix: Icons.email,
                          validate: (value) {
                            if (value.isEmpty) {
                              return 'Please enter an email address';
                              } else if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$').hasMatch(value)) {
                              return 'Please enter a valid email address';
                              }
                              return null;
                          }),
                      const SizedBox(
                        height: 20,
                      ),
                      defaultFormField(
                          controller: phoneController,
                          type: TextInputType.number,
                          label: 'Your Phone',
                          prefix: Icons.phone,
                          validate: (value) {
                            if (value.isEmpty) {
                            return 'Enter Your Mobile Number';
                            }else if (!RegExp(r'(^(010|012|015|011)\d{8}$)').hasMatch(value)) {
                            return 'Please enter a valid Mobile Number';
                            }
                            return null;
                            }),
                      const SizedBox(
                        height: 20,
                      ),
                      defaultFormField(
                          controller: passwordController,
                          type: TextInputType.visiblePassword,
                          label: 'Your Password',
                          prefix: Icons.lock,
                          suffix: cubit.Icon,
                          ispassword: cubit.isPassword,
                          suffixPressed: () {
                            cubit.changepass();
                          },
                          validate: (value) {
                            if (value.isEmpty) {
                              return 'Enter Your Password';
                            }
                            return null;
                          }),
                      const SizedBox(
                        height: 20,
                      ),
                      defaultFormField(
                          controller: confirmPasswordController,
                          type: TextInputType.visiblePassword,
                          label: 'confirm Password',
                          prefix: Icons.lock,
                          suffix: cubit.Icon,
                          ispassword: cubit.isPassword,
                          suffixPressed: () {
                            cubit.changepass();
                          },
                          validate: (value) {
                            if (value.isEmpty) {
                              return 'Confirm Your Password';
                            } else if (confirmPasswordController.text !=
                                passwordController.text) {
                              return 'your password isn\'t correct';
                            }
                            return null;
                          }),
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.black,
                          ),
                          child: MaterialButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                cubit.insertDatabase(
                                  name: nameController.text,
                                  email: emailController.text,
                                  phone: int.parse(phoneController.text),
                                  password: passwordController.text,
                                  confirmPassword: confirmPasswordController.text,
                                );
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (context) => HomeLayout()),
                                      (route) => false,
                                );
                              }
                            },
                            child: const Text('Register',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                )),
                          ))
                    ]),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
