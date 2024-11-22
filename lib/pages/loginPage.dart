import 'package:flutter/material.dart';
import 'package:lights/assets.dart';
import 'package:lights/pages/home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _keyCode = TextEditingController();
  var passToggle = true;
  final colorbg = const Color(0XFFfccb82);
  final _formField = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorbg,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Form(
          key: _formField,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 200,
                height: 200,
                child: Image.asset(adminImage, width: 60, height: 60,),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100)
                ),
              ),
              SizedBox(height: 80,),
              TextFormField(
                keyboardType: TextInputType.text,
                validator: (value) {
                  if(value!.isEmpty) {
                    return "Entrer le key code";
                  }
                  return null;
                },
                controller: _keyCode,
                obscureText: passToggle,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: const OutlineInputBorder(),
                  label: const Text("Key code"),
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: InkWell(
                    onTap: (){
                      setState(() {
                        passToggle = !passToggle;
                      });
                    },
                    child: Icon(!passToggle? Icons.visibility: Icons.visibility_off, color: Colors.black,),
                  )
                ),
              ),
              SizedBox(height: 20,),
              InkWell(
                onTap: () {
                  if (_formField.currentState!.validate()) {
                    print("Success");
                    _keyCode.clear();
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Home(0)));
                  } else {
                }},
                child: Container(
                  height: 50,
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(7)
                  ),
                  child: const Text("Valider", textAlign: TextAlign.center,style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),),
                ),
              ),
              const SizedBox(height: 60,),
            ],
          ),
        ),
      ),
    );
  }
}
