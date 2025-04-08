import 'dart:math';

import 'package:bmta/app_config.dart';
import 'package:bmta/app_router.dart';
import 'package:bmta/models/auth/reqlogin.dart';
import 'package:bmta/Interface/rfid_repo_interface.dart';
import 'package:bmta/srceens/bottomnavpage/navigationBarScreen.dart';
import 'package:bmta/srceens/login/logo_create_pin.dart';
import 'package:bmta/themes/colors.dart';
import 'package:bmta/themes/fontsize.dart';
import 'package:bmta/utils/validator_util.dart';
import 'package:bmta/widgets/button/buttons.dart';
import 'package:bmta/widgets/custom_text_default.dart';
import 'package:bmta/widgets/logo_welcome.dart';
import 'package:bmta/widgets/textFrom/custom_text_form_field.dart';
import 'package:bmta/widgets/widgets.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:flutter/foundation.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart'; // สำหรับ kIsWeb และ defaultTargetPlatform

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late AuthRepoInterface repository;
  final _formKey = GlobalKey<FormState>();
  final _empCodeCtl = TextEditingController();
  bool _isLogin = false; // Flag to track whether the form is submitting

  bool _isSubmit = false; // Flag to track whether the form is submitting
  bool _isRequestLimit = true;
  bool isIconTrue = true; // Toggle password visibility initially set to hidden
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true; // To toggle password visibility

  @override
  void dispose() {
    super.dispose();
  }

  void _handleOnOutOfTime() {
    setState(() {
      _isRequestLimit = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    repository = AppConfig.of(context)!.authRepo;

    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: double.infinity,
              child: SingleChildScrollView(
                child: _isLogin
                    ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                      )
                    : Container(
                        padding: EdgeInsets.all(16),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.only(start: 12.0, end: 12.0),
                                child: SvgPicture.asset(
                                  "lib/assets/icons/bmta_logo_svg.svg" ?? "",
                                  height: 200,
                                  width: 200,
                                ),
                              ),
                              SizedBox(height: 20),
                              CustomTextFormField(
                                controller: _usernameController,
                                hintText: 'Enter your Email',
                                obscureText: false,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter an email';
                                  }
                                  return null;
                                },
                                inputDecoration: inputDecoration(
                                  nameImage: "lib/assets/icons/ic_login_email.svg",
                                  context,
                                  hintText: "อีเมล",
                                ),
                              ),
                              SizedBox(height: 20),
                              CustomTextFormField(
                                keyboardType: TextInputType.text,
                                controller: _passwordController,
                                obscureText: isIconTrue,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a password';
                                  }
                                  return null;
                                },
                                inputDecoration: inputDecoration(
                                  nameImage: "lib/assets/icons/ic_login_password.svg",
                                  context,
                                  hintText: "Password",
                                  suffixIcon: Theme(
                                    data: ThemeData(splashColor: Colors.transparent, highlightColor: Colors.transparent),
                                    child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          isIconTrue = !isIconTrue;
                                        });
                                      },
                                      icon: Icon(
                                        (isIconTrue) ? Icons.visibility_rounded : Icons.visibility_off,
                                        size: 16,
                                        color: gray,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 16),
                              TextButton(
                                onPressed: () {
                                  // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ForgotPassScreen()));
                                },
                                child: Text('Forgot Password ?', style: boldTextStyle()),
                              ),
                              SizedBox(height: 8),
                              SizedBox(
                                width: double.infinity,
                                height: MediaQuery.of(context).size.height * 0.07,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      loadLogin();
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF4CAF50),
                                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0.r)),
                                  ),
                                  child: Center(
                                    child: CustomTextDefault(
                                      textAlign: TextAlign.center,
                                      text: 'เข้าสู่ระบบ',
                                      style: TextStyle(
                                        fontWeight: fontBold,
                                        fontFamily: fontFamily,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 24),
                            ],
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void loadLogin() async {
    setState(() {
      _isSubmit = false; 
      _isLogin = false; // Set loading state to true
    });

    try {
      final response = await repository.getLoginUser(
        Reqlogin(username: _usernameController.text, password: _passwordController.text),
      );

      setState(() {
        _isLogin = false; // Stop loading
      });

      if (response.isSuccess) {
        if (mounted) {
          print("Login Success");
          Navigator.pushNamed(context, AppRouter.navigationBar);
        }
        return;
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message)),
        );
      }
    } catch (e) {
      setState(() {
        _isLogin = false; // Stop loading in case of an error
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }
}