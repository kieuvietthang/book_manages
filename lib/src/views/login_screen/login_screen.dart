import 'package:demo/src/models/User.dart';
import 'package:demo/src/views/home_screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
   User? user;
   TextEditingController txtUserNameController = TextEditingController();
   TextEditingController txtUserPwdController = TextEditingController();

  String name = "kieuthang";
  String pass = "123456";


  final formKey = GlobalKey<FormState>();
void login(){
    if(formKey.currentState!.validate()){
      print('thanh cong');
      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
    }else{
      print('error');
    }
  }


  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: [
          Image.asset(
            'assets/images/img_bgr.png',
            fit: BoxFit.cover,
            width: double.infinity,
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 70,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/img_logo.png',
              width: 120,
              height: 120,
            ),
          ),
          Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue),
                        borderRadius: BorderRadius.circular(25)),
                    child: TextFormField(
                      controller: txtUserNameController,
                      decoration: const InputDecoration(
                        hintText: 'User name',
                        icon: Icon(Icons.account_circle),
                        border: InputBorder.none,
                      ),
                      validator: (value){
                        if(value!.isEmpty || !RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$').hasMatch(value!)){
                          return "Email không hợp lệ";
                        }else{
                          return null;
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue),
                        borderRadius: BorderRadius.circular(25)),
                    child: TextFormField(
                      controller: txtUserPwdController,
                      decoration: const InputDecoration(
                        hintText: 'Pass word',
                        icon: Icon(Icons.key),
                        border: InputBorder.none,
                      ),
                      validator: (value){
                        if(value!.isEmpty || txtUserPwdController.text.length < 6){
                          return "Mật khẩu phải trên 6 kí tự";
                        }else{
                          return null;
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                GestureDetector(
                  onTap: (){
                    login();
                  },
                  child: Container(
                    height: 50,
                    width: 150,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(20)
                    ),
                    child: const Center(
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  // void login(){
  //   if(formKey.currentState!.validate()){
  //     print('thanh cong');
  //     if()
  //   }else{
  //     print('error');
  //   }
  // }
}
