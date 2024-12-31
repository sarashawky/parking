import 'package:flutter/material.dart';
import 'package:parking/components/custom_button.dart';
import 'package:parking/components/input_text_field.dart';
import 'package:parking/services/auth/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController= TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Center(
         child: Padding(
           padding: const EdgeInsets.symmetric(horizontal: 25.0),
           child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               Icon(
                 Icons.message,
                 size: 100,
                 color: Theme.of(context).colorScheme.primary,
               ),
               const SizedBox(height: 25,),
               Text("Welcome back you\'ve been missed",
                 style: TextStyle(
                     fontSize: 16,
                     color: Theme.of(context).colorScheme.primary
                 ),
               ),
               const SizedBox(height: 25,),

               InputTextField(controller: emailController,
                   hintText: 'Email',
                   obscureText: false),
               const SizedBox(height: 10,),

               InputTextField(controller: passwordController,
                   hintText: 'Password',
                   obscureText: true),
               const SizedBox(height: 25,),

               CustomButton(text: "Sign In",onTap: ()=>login(context),),

               const SizedBox(height: 50,),

               // Row(
               //   mainAxisAlignment:  MainAxisAlignment.center,
               //   children: [
               //     Text("Not a member?"),
               //     const SizedBox(width: 4,),
               //     Text("Register now",
               //     style: TextStyle(
               //       fontWeight: FontWeight.bold
               //     ),),
               //   ],
               // )
             ],
           ),
         ),
        ),
      ),
    );
  }

void login(BuildContext context) async {
    final authService = AuthService();
    try{
      await authService.signInWithEmailPassword(emailController.text, passwordController.text);
    } catch(e){
      showDialog(
          context: context,
          builder: (context)=> AlertDialog(
            title: Text(e.toString()),
          ) );
    }

  }
}
