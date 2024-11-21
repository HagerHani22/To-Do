import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks/models/userdata.dart';
import '../../../layout/tasks_app.dart';
import '../../../shared/components/component.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class RegisterScreen extends StatelessWidget {
   RegisterScreen({super.key});
 final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProjectCubit, ProjectStates>(
      listener: (context, state) {},
      builder: (context, state) {
        ProjectCubit cubit = ProjectCubit.get(context);
        return Scaffold(
          appBar: AppBar(backgroundColor: Colors.white),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(children: [
                    const Text(
                      'Register',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 35),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    defaultFormField(
                        readonly: false,
                        controller: nameController,
                        type: TextInputType.name,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                        label: 'Your name',
                        color: Colors.white,
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
                        readonly: false,
                        controller: emailController,
                        type: TextInputType.emailAddress,
                        label: 'Your Email',
                        color: Colors.white,
                        prefix: Icons.email,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                        validate: (value) {
                          if (value.isEmpty) {
                            return 'Please enter an email address';
                          } else if (!RegExp(
                                  r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
                              .hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        }),
                    const SizedBox(
                      height: 20,
                    ),
                    defaultFormField(
                        readonly: false,
                        // ispassword: false,

                        controller: phoneController,
                        type: TextInputType.number,
                        label: 'Your Phone',
                        color: Colors.white,
                        prefix: Icons.phone,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                        validate: (value) {
                          if (value.isEmpty) {
                            return 'Enter Your Mobile Number';
                          } else if (!RegExp(r'(^(010|012|015|011)\d{8}$)')
                              .hasMatch(value)) {
                            return 'Please enter a valid Mobile Number';
                          }
                          return null;
                        }),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      controller: passwordController,
                      obscureText: cubit.ispassword,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                        fillColor: Colors.white,
                        labelText: 'Enter your password',
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                            onPressed: () {
                              cubit.changepass();
                            },
                            icon: Icon(
                              cubit.Icon,
                            )),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter Your password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        controller: confirmPasswordController,
                        obscureText: cubit.ispassword,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)),
                          fillColor: Colors.white,
                          labelText: 'confirm Password',
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                              onPressed: () {
                                cubit.changepass();
                              },
                              icon: Icon(
                                cubit.Icon,
                              )),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
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
                    state is! LoadingUserState
                        ? Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.black,
                            ),
                            child: MaterialButton(
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  ProjectCubit.get(context).userDataModel =
                                      UserData(
                                    name: nameController.text,
                                    email: emailController.text,
                                    phone: phoneController.text,
                                    password: passwordController.text,
                                  );

                                  cubit.insertDatabase(
                                    name: nameController.text,
                                    email: emailController.text,
                                    phone: int.parse(phoneController.text),
                                    password: passwordController.text,
                                    confirmpassword: confirmPasswordController.text,
                                  );
                                  cubit.saveUserData(
                                      ProjectCubit.get(context).userDataModel!);
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TasksApp()),
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
                        : const Center(child: CircularProgressIndicator()),
                  ]),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
