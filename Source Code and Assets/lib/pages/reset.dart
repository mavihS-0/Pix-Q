import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ResetPWDPage extends StatefulWidget {
  const ResetPWDPage({Key? key}) : super(key: key);

  @override
  State<ResetPWDPage> createState() => _ResetPWDPageState();
}

class _ResetPWDPageState extends State<ResetPWDPage> {
  final emailController = TextEditingController();

  Future resetPassword() async{
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context)=> const Center(child: CircularProgressIndicator()),
    );
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text.trim());
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password reset email sent'),
            backgroundColor: Colors.blue,
          ));
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
    Navigator.pop(context);
  }

  // @override
  // void dispose(){
  //   emailController.dispose();
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
              const SizedBox(height: 30.0,),
              IconButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                color: const Color(0xFFF03A56),
                icon: const Icon(Icons.arrow_back_rounded ),
                iconSize: 30.0,
              ),
              const SizedBox(height: 30.0,),
              const Text("Reset Password",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
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

              const SizedBox(height: 30),
              MaterialButton(
                onPressed: resetPassword,
                height: 70,
                minWidth: double.infinity,
                color: const Color(0xFFF03A56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: const Text(
                  'Reset Password',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
