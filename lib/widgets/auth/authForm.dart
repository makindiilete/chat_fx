import 'dart:io';

import 'package:chat_fx/widgets/pickers/userImagePicker.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  // we declare a function varaible to represent the function passed to ds component and the args required
  final void Function(
      String email,
      String password,
      String username,
      File userImageFile,
      bool isInLoginMode,
      BuildContext context) _submitAuthForm;
  bool _isLoading;

  // we then init d function inside the constructor...
  AuthForm(this._submitAuthForm, this._isLoading);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<
      FormState>(); // ds property represents and contains our form state
  var _isInLoginMode = true; //controls whether we r in login mode or signup
  // we setup ds properties has an empty string and each of our form field will fill each values on form submission
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';
  File _userImageFile;

  //ds function collects d picked image from userImagePicker and store it inside our '_userImageFile' property
  void _handlePickedImage(File pickedImage) {
    _userImageFile = pickedImage;
  }

  // ds method will be called to save our form
  void _saveForm() {
    //we validate all form fields and returns true if there are no errors
    final isValid = _formKey.currentState.validate();
    // ds close d soft keyboard once we click on 'submit'
    FocusScope.of(context).unfocus();

    // if we are not in login mode (user trying to register) and image selected is null
    if (_userImageFile == null && !_isInLoginMode) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Please pick an image"),
        backgroundColor: Theme.of(context).errorColor,
      ));
      return;
    }

    // if validator returns false, it means there are errors and we simply want to return
    if (!isValid) {
      return;
    }
    // else if isValid is true, it means there are no errors so we can save the form...
    // we call our form using the _formKey property we have attached to it and call the save() method
    _formKey.currentState.save();
    //we call d function inside authScreen and pass our user details
    widget._submitAuthForm(_userEmail.trim(), _userPassword.trim(),
        _userName.trim(), _userImageFile, _isInLoginMode, context);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    if (!_isInLoginMode)
                      UserImagePicker(
                        handlePickedImage: _handlePickedImage,
                      ),
                    TextFormField(
                      // ds is d name dt uniquely identified ds input field
                      key: ValueKey("email"),
                      keyboardType: TextInputType.emailAddress,
                      // autocorrect: false,
                      // textCapitalization: TextCapitalization.none,
                      decoration: InputDecoration(
                        labelText: "Email Address",
                      ),
                      validator: (value) {
                        if (value.isEmpty || !value.contains("@")) {
                          return "Please Enter A Valid Email Address";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _userEmail = value;
                      },
                    ),
                    if (!_isInLoginMode)
                      TextFormField(
                        // ds is d name dt uniquely identified ds input field
                        key: ValueKey("username"),
                        decoration: InputDecoration(labelText: "Username"),
                        validator: (value) {
                          if (value.isEmpty || value.length < 4) {
                            return "Please enter at least 4 characters";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _userName = value;
                        },
                      ),
                    TextFormField(
                      // ds is d name dt uniquely identified ds input field
                      key: ValueKey("password"),
                      decoration: InputDecoration(labelText: "Password"),
                      // required to not hide the input for a password field
                      obscureText: true,
                      validator: (value) {
                        if (value.isEmpty || value.length < 7) {
                          return "Password must be atleast 7 characters long";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _userPassword = value;
                      },
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    // we show progress indicator while making async request with friestore
                    if (widget._isLoading)
                      CircularProgressIndicator(),
                    // we hide our buttons while async request is going on
                    if (!widget._isLoading)
                      RaisedButton(
                        onPressed: _saveForm,
                        child: Text(_isInLoginMode ? "Login" : "Signup"),
                      ),
                    if (!widget._isLoading)
                      FlatButton(
                        // we update d UI switching d value of _isLogin property
                        onPressed: () {
                          setState(() {
                            _isInLoginMode = !_isInLoginMode;
                          });
                        },
                        child: Text(_isInLoginMode
                            ? "Create new account"
                            : "I already have an account"),
                        textColor: Theme.of(context).primaryColor,
                      )
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
