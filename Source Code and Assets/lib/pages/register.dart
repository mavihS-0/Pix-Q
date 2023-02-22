import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController= TextEditingController();

  Future signUp() async {
    if (!formKey.currentState!.validate()) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context)=> const Center(child: CircularProgressIndicator()),
    );
    try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch(e) {
      //TODO: remove print
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message.toString()),
          backgroundColor: Colors.blue,
        ),
      );
    }
    Navigator.pushNamed(context, 'start screen');
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                  const SizedBox(height: 20,),
                  Container(
                    alignment: Alignment.topCenter,
                    child: Image.asset('assets/logo.png',height: 200,width: 200,),
                  ),
                  const SizedBox(height: 30.0,),
                  const Text("Welcome",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),),
                  const SizedBox(height: 10,),
                  const Text('Create account to continue',style: TextStyle(
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
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (email)=> email!=null && !EmailValidator.validate(email) ? 'Enter a valid email' :  null,
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
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value)=> value!=null && value.length<6 ? 'Enter min. 6 characters' : null,
                    obscureText: true,
                  ),
                  const SizedBox(height: 30),
                  MaterialButton(
                    onPressed: signUp,
                    height: 70,
                    minWidth: double.infinity,
                    color: const Color(0xFFF03A56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: const Text(
                      'Register',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account ?"),
                      TextButton(
                        onPressed: (){
                          Navigator.pushNamed(context, 'start screen');
                        },
                        child: const Text('Login', style: TextStyle(color: Colors.red)),
                      ),
                    ],),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
