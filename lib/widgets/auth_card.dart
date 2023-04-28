import 'package:flutter/material.dart';
import 'package:myshop_flutter_application/models/app_animation.dart';
import '../providers/auth_provider.dart';
import 'package:provider/provider.dart';

enum AuthMode { signup, signin }

class AuthCard extends StatefulWidget {
  const AuthCard({super.key});

  @override
  State<AuthCard> createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.signin;
  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController(text: 'zead1111');

  @override
  void initState() {
    super.initState();
    AppAnimation.initiateAnimation(this);
  }

  Future<void> errorDialog(context, Object error) {
    return showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('An error occurred!'),
          content: Text(error.toString()),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Okay'))
          ],
        );
      },
    );
  }

  // the function that will be called when the user ends adding his inputs
  Future<void> _submit() async {
    /// if the validation fails it return and get out of the function
    ///to make the user fix the errors and submit again
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    // if all validation succeed is calls the onSave method using this line
    _formKey.currentState!.save();
    // set _isLoading to true to start loading spinner
    setState(() => _isLoading = true);
    // signin or signup
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    if (_authMode == AuthMode.signin) {
      // sign user in
      try {
        await authProvider.signIn(_authData['email']!, _authData['password']!);
      } catch (e) {
        errorDialog(context, e);
      }
    } else {
      // Sign user up
      try {
        await authProvider.signUp(_authData['email']!, _authData['password']!);
      } catch (e) {
        errorDialog(context, e);
      }
    }
    // set _isLoading to false to stop loading spinner and view content
    setState(() => _isLoading = false);
  }

  // switch between signin and signup based on the _authMode value
  void _switchAuthMode() {
    if (_authMode == AuthMode.signin) {
      setState(() => _authMode = AuthMode.signup);
      AppAnimation.animationController.forward();
    } else {
      setState(() => _authMode = AuthMode.signin);
      AppAnimation.animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Flexible(
      flex: deviceSize.width > 600 ? 2 : 1,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 8.0,
        child: AnimatedBuilder(
          animation: AppAnimation.heightAnimation,
          builder: (BuildContext context, Widget? child) {
            return Container(
              height: AppAnimation.heightAnimation.value.height,
              constraints: BoxConstraints(
                  minHeight: AppAnimation.heightAnimation.value.height),
              width: deviceSize.width * 0.75,
              padding: const EdgeInsets.all(16.0),
              child: child,
            );
          },
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  emailField(),
                  passwordField(),
                  if (_authMode == AuthMode.signup) signupField(),
                  const SizedBox(height: 20),
                  if (_isLoading)
                    const CircularProgressIndicator()
                  else
                    primaryActionButton(),
                  secondActionButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget signupField() {
    return FadeTransition(
      opacity: AppAnimation.fadeAnimation,
      child: SlideTransition(
        position: AppAnimation.slideAnimation,
        child: TextFormField(
          initialValue: 'zead1111',
          enabled: _authMode == AuthMode.signup,
          decoration: const InputDecoration(labelText: 'Confirm Password'),
          obscureText: true,
          validator: _authMode == AuthMode.signup
              ? (value) {
                  if (value != _passwordController.text) {
                    return 'Passwords do not match!';
                  }
                  return null;
                }
              : null,
        ),
      ),
    );
  }

  TextFormField passwordField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Password'),
      obscureText: true,
      controller: _passwordController,
      validator: (value) {
        if (value!.isEmpty || value.length < 5) {
          return 'Password is too short!';
        }
        return null;
      },
      onSaved: (value) {
        _authData['password'] = value!;
      },
    );
  }

  TextFormField emailField() {
    return TextFormField(
      initialValue: 'ziad@mail.com',
      decoration: const InputDecoration(labelText: 'E-Mail'),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty || !value.contains('@')) {
          return 'Invalid email!';
        }
        return null;
      },
      onSaved: (value) {
        _authData['email'] = value!;
      },
    );
  }

  ElevatedButton primaryActionButton() {
    return ElevatedButton(
      onPressed: _submit,
      child: Text(_authMode == AuthMode.signin ? 'SIGN IN' : 'SIGN UP'),
      /*  shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ), */
      /*  padding:
                          EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                      color: Theme.of(context).primaryColor,
                      textColor: Theme.of(context).primaryTextTheme.button.color, */
    );
  }

  TextButton secondActionButton() {
    return TextButton(
      onPressed: _switchAuthMode,
      child:
          Text('${_authMode == AuthMode.signin ? 'SIGNUP' : 'SIGNIN'} INSTEAD'),
      /* padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    textColor: Theme.of(context).primaryColor, */
    );
  }
}
