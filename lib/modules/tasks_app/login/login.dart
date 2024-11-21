import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:tasks/modules/tasks_app/login/register.dart';

import '../../../layout/tasks_app.dart';
import '../../../shared/components/component.dart';
import '../../../shared/network/local/cache_helper.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class NewLogin extends StatelessWidget {
  NewLogin({
    Key? key,
  }) : super(key: key);
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  final formKey = GlobalKey<FormState>();
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
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Image(
                        image: AssetImage('assets/image/milano.jpg'),
                      ),
                      Text(
                        ('MILANO INDUSTRIES'),
                        style: TextStyle(
                            color: HexColor('#be854d'),
                            fontWeight: FontWeight.bold,
                            fontSize: 22),
                      ),
                      const SizedBox(
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
                      state is! LoadingUserState
                          ? Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: HexColor('#374f87'),
                              ),
                              child: MaterialButton(
                                onPressed: () async {
                                  if (formKey.currentState!.validate()) {
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
                                            builder: (context) => TasksApp()),
                                        (route) => false,
                                      );
                                    }
                                  }
                                },
                                child: const Text(
                                  'Login',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                              ))
                          : const Center(child: CircularProgressIndicator()),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
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
                              child: const Text(
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
