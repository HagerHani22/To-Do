import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:tasks/modules/tasks_app/login/register.dart';

import '../../../layout/tasks_app.dart';
import '../../../models/userdata.dart';
import '../../../shared/components/component.dart';
import '../../../shared/network/local/cache_helper.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class NewLogin extends StatelessWidget {
  NewLogin({
    Key? key,
  }) : super(key: key);
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var nameController = TextEditingController();
  var phoneController = TextEditingController();

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
            // systemOverlayStyle:
            // SystemUiOverlayStyle(statusBarColor: Colors.blue),
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Form(
                  key: formkey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image(
                        image: AssetImage('assets/image/milano.jpg'),
                      ),
                      Text(
                        ('MILANO INDUSTRIES'),
                        style: TextStyle(
                            color: HexColor('#be854d'),
                            fontWeight: FontWeight.bold,
                            fontSize: 22),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      defaultFormField(
                        // ispassword: false,
                        readonly: false,
                        controller: emailController,
                        type: TextInputType.emailAddress,
                        label: 'Enter Your Email',
                        prefix: Icons.email,
                        color: Colors.white,
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
                        },
                      ),
                      SizedBox(
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
                          prefixIcon: Icon(Icons.lock),
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
                      SizedBox(
                        height: 20,
                      ),
                      state is! LoadingUserState
                          ? Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: HexColor('#374f87'),
                              ),
                              child: MaterialButton(
                                onPressed: () async {
                                  if (formkey.currentState!.validate()) {
                                    print(emailController.text);
                                    print(passwordController.text);

                                    bool isAuthenticated =
                                        await cubit.authenticateUser(
                                            email: emailController.text,
                                            password: passwordController.text,
                                            context);
                                    if (isAuthenticated) {
                                      CacheHelper.setUser(
                                          key: 'email', value: true);

                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Tasks_App()),
                                        (route) => false,
                                      );
                                    }
                                  }
                                },
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                              ))
                          : Center(child: CircularProgressIndicator()),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Don\'t have an account ?',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => RegisterScreen(),
                                    ));
                              },
                              child: Text(
                                'Register Now',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                        ],
                      )
                    ],
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
