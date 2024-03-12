import 'package:flutter/material.dart';
import 'package:hugy/auth/firebase.dart';
import 'package:hugy/screens/splash.dart';

// LOGIN SCREEN

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _loginError = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Login')),
        body: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(helperText: 'Email'),
              ),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(helperText: 'Password'),
              ),
              _loginError
                  ? const Text('Invalid login information')
                  : Container(),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                child: ElevatedButton(
                  child: const Text('Login'),
                  onPressed: () async {
                    // ADDED NEW FEATURE
                    await AuthService()
                        .login(_emailController.text, _passwordController.text)
                        .then((bool success) {
                      if (!success) {
                        setState(() {
                          _loginError = true;
                        });
                      } else {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (ctx) => const AuthGate()));
                      }
                    });
                    // FINISHED ADDING NEW FEATURE
                  },
                ),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const Registration()));
                  },
                  child: const Text("Create an account instead")),
            ],
          ),
        ));
  }
}

//REGISTRATION SCREEN BLOW

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Create Account"),
          centerTitle: true,
          leading: null,
        ),
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your email";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(),
                      hintText: "Enter your email",
                    ),
                  ),

                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your password";
                      }

                      if (value.length < 8) {
                        return "Password must be at least 8 characters";
                      }
                      return null;
                    },
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(),
                      hintText: "Enter your password",
                    ),
                  ),

                  const SizedBox(height: 20),

                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    validator: (value) {
                      if (_passwordController.text != value) {
                        return "Passwords do not match";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: "Confirm Password",
                      border: OutlineInputBorder(),
                      hintText: "Confirm your password",
                    ),
                  ),

                  ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final email = _emailController.text;
                          final password = _passwordController.text;

                          final result = await AuthService()
                              .createNewUser(email, password);

                          if (result) {
                            if (!mounted) {
                              return;
                            }
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (context) {
                              return const SplashScreen();
                            }));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Failed to create account"),
                              ),
                            );
                          }
                        }
                      },
                      child: const Text("Create Account")),
                  //
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) {
                          return const LoginPage();
                        }));
                      },
                      child: const Text("Login instead")),
                ],
              )),
        ));
  }
}

// REGISTRATION SCREEN ENDS HERE
