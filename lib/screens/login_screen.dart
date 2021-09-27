import 'package:flutter/material.dart';
import 'package:flutter_architecture_app/constants/image_constant.dart';
import 'package:flutter_architecture_app/constants/string_constant.dart';
import 'package:flutter_architecture_app/helpers/api_manager.dart';
import 'package:flutter_architecture_app/providers/auth_provider.dart';
import 'package:flutter_architecture_app/utils/utils.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //variables
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text(StringConstant.login)),
        body: Center(
          child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                  child: Column(children: <Widget>[
                SizedBox(
                  height: 100,
                  width: 100,
                  child: Image.asset(ImageConstant.logo_img,
                      fit: BoxFit.scaleDown),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: StringConstant.email_address,
                        labelStyle: TextStyle(fontSize: 15)),
                    validator: MultiValidator([
                      RequiredValidator(
                          errorText: StringConstant.enter_email_validation),
                      EmailValidator(
                          errorText:
                              StringConstant.enter_valid_email_validation)
                    ]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextFormField(
                    obscureText:
                        !Provider.of<AuthProvider>(context, listen: true)
                            .isPwdVisible,
                    controller: passwordController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: StringConstant.password,
                        labelStyle: TextStyle(fontSize: 15),
                        suffixIcon: IconButton(
                          icon: Icon(
                            // Based on passwordVisible state choose the icon
                            Provider.of<AuthProvider>(context, listen: true)
                                    .isPwdVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Theme.of(context).primaryColorDark,
                          ),
                          onPressed: () {
                            // Update the state i.e. toogle the state of passwordVisible variable
                            setState(() {
                              Provider.of<AuthProvider>(context, listen: false)
                                  .updatePwdVisible(!Provider.of<AuthProvider>(
                                          context,
                                          listen: false)
                                      .isPwdVisible);
                            });
                          },
                        )),
                    // The validator receives the text that the user has entered.
                    validator: RequiredValidator(
                        errorText: StringConstant.enter_pwd_validation),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child:
                      Provider.of<AuthProvider>(context, listen: true).isLoading
                          ? const CircularProgressIndicator()
                          : Container(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.blue)),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    _doLogin(context);
                                  }
                                },
                                child: const Text(StringConstant.submit,
                                    style: TextStyle(fontSize: 18)),
                              ),
                            ),
                )
              ]))),
        ));
  }

  _doLogin(BuildContext context) async {
    Provider.of<AuthProvider>(context, listen: false).updateIsLoading(true);

    APIManager.shared.makeRequest(
        endPoint: APIConstant.loginUser,
        method: RequestType.POST,
        params: {
          "email": emailController.text,
          "password": passwordController.text
        },
        callback: (result) {
          if (result is SuccessState) {
            showAlert(context, 'Login Success!!!');
          } else if (result is ErrorState) {
            showAlert(context, result.msg);
          }
          Provider.of<AuthProvider>(context, listen: false)
              .updateIsLoading(false);
        });
  }
}
