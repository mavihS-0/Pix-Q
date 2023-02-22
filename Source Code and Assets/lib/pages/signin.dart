import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wallpaper/main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future signIn() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context)=> const Center(child: CircularProgressIndicator()),
    );
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    }
    on FirebaseAuthException catch(e) {
      //TODO: remove print
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message.toString()),
          backgroundColor: Colors.blue,
        ),
      );
    }
    Navigator.pop(context);
  }

  // @override
  // void dispose(){
  //   emailController.dispose();
  //   passwordController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:[
              const SizedBox(height: 20,),
              Container(
                alignment: Alignment.topCenter,
                child: Image.asset('assets/logo.png',height: 200,width: 200,),
              ),
              const SizedBox(height: 30.0,),
              const Text("Welcome Back",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),),
              const SizedBox(height: 10,),
              const Text('Sign in to continue',style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),),
              const SizedBox(height: 30.0,),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email),
                  hintText: "Email",
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Color(0xFFF03A56))
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(height: 30.0,),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.vpn_key),
                  hintText: "Password",
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Color(0xFFF03A56))
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 30),
              MaterialButton(
                onPressed: signIn,
                height: 70,
                minWidth: double.infinity,
                color: const Color(0xFFF03A56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              Center(
                child: TextButton(
                  onPressed: (){
                    Navigator.pushNamed(context, 'resetpwd screen');
                  },
                  child: const Text('Forgot password?', style: TextStyle(color: Colors.red)),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account ?"),
                  TextButton(
                    onPressed: (){
                      Navigator.pushNamed(context, 'signup screen');
                    },
                    child: const Text('Register', style: TextStyle(color: Colors.red)),
                  ),
                ],),
            ],
          ),
          ),
        ),
      );
  }
}
