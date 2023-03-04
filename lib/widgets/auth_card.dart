import 'package:flutter/material.dart';

enum AuthMode { signup, login }

class AuthCard extends StatefulWidget {
  const AuthCard({super.key});

  @override
  State<AuthCard> createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.login;
  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();
  // the function that will be called when the user ends adding his inputs
  void _submit() {
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
    // login or signup
    if (_authMode == AuthMode.login) {
      // Log user in
    } else {
      // Sign user up
    }
    // set _isLoading to false to stop loading spinner and view content
    setState(() => _isLoading = false);
  }

  // switch between login and signup based on the _authMode value
  void _switchAuthMode() {
    if (_authMode == AuthMode.login) {
      setState(() => _authMode = AuthMode.signup);
    } else {
      setState(() => _authMode = AuthMode.login);
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
        child: Container(
          height: _authMode == AuthMode.signup ? 320 : 260,
          constraints: BoxConstraints(
              minHeight: _authMode == AuthMode.signup ? 320 : 260),
          width: deviceSize.width * 0.75,
          padding: const EdgeInsets.all(16.0),
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

 
  TextFormField signupField() {
    return TextFormField(
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
      child: Text(_authMode == AuthMode.login ? 'LOGIN' : 'SIGN UP'),
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
          Text('${_authMode == AuthMode.login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
      /* padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    textColor: Theme.of(context).primaryColor, */
    );
  }

}
