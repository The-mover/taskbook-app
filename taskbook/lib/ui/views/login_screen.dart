import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskbook/business_logic/view_models/login_viewmodel.dart';
import 'package:taskbook/router.dart';
import 'package:taskbook/services/service_locator.dart';
import 'package:taskbook/ui/shared/buttons/primary_button.dart';
import 'package:taskbook/ui/utils/colors.dart';
import 'package:taskbook/ui/utils/show_flushbar.dart';
import 'package:taskbook/ui/utils/text_style.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginViewModel viewModel = serviceLocator<LoginViewModel>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginViewModel>(
      create: (context) => viewModel,
      child: Consumer<LoginViewModel>(
        builder: (context, model, child) => Scaffold(
          body: Container(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 50),
                  _buildMainLogo(),
                  SizedBox(height: 15),
                  _buildHeading(),
                  SizedBox(height: 15),
                  _buildSubHeading(),
                  SizedBox(height: 50),
                  _buildEmail(context),
                  SizedBox(height: 15),
                  _buildPassword(context),
                  SizedBox(height: 20),
                  _buildSubmitButton(context),
                  SizedBox(height: 40),
                  _buildSignUpButton(context),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpButton(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text('Don\'t have an account?'),
        SizedBox(height: 10),
        GestureDetector(
          child: Text('Signup', style: ButtonTextStyle.accent),
          onTap: () => openSignupPage(context),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return PrimaryButton(
      onPressed: () => _handleLogin(context),
      label: 'Login',
    );
  }

  Widget _buildMainLogo() {
    return Text('TaskBook', style: HeadingStyle.accent);
  }

  Widget _buildHeading() {
    return Text('Signin', style: HeadingStyle.primary);
  }

  Widget _buildSubHeading() {
    return Text(
      'Enter your Login Credentials to continue',
      textAlign: TextAlign.center,
      style: TextStyle(color: MyColors.primary),
    );
  }

  Widget _buildEmail(BuildContext context) {
    return new Container(
      width: MediaQuery.of(context).size.width - 32,
      height: 43,
      decoration: new BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(7),
      ),
      child: TextField(
        controller: _emailController,
        decoration: new InputDecoration(
          prefixIcon: Icon(Icons.email, color: Colors.black),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 9),
          hintText: 'Email Address',
          hintStyle: TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  Widget _buildPassword(BuildContext context) {
    return new Container(
      width: MediaQuery.of(context).size.width - 32,
      height: 43,
      decoration: new BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(7),
      ),
      child: TextField(
        obscureText: true,
        controller: _passwordController,
        decoration: new InputDecoration(
          prefixIcon: Icon(Icons.lock, color: Colors.black),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 9),
          hintText: 'Password',
          hintStyle: TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  void _handleLogin(BuildContext context) async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    if (email == '' || email == null) {
      ShowFlushbar.showFlushbar(context, 'Email Can\'t be Empty', 1500);
      return;
    }

    if (password == '' || password == null) {
      ShowFlushbar.showFlushbar(context, 'Password Can\'t be Empty', 1500);
      return;
    }

    if (password.length < 6) {
      ShowFlushbar.showFlushbar(
          context, 'Password\'s length is less than 6', 1500);
      return;
    }

    // start the loading dialog
    showAlertDialog(context);

    var result = await viewModel.userLogin(email, password);

    // terminate the dialog
    Navigator.pop(context);

    if (result == true) {
      openHomeScreen(context);
    } else {
      ShowFlushbar.showFlushbar(context, 'Something Went Wrong!!', 1500);
    }
  }

  showAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 5), child: Text("Loading")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
