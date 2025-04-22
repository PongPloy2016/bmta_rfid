
import 'package:bmta_rfid_app/app_router.dart';
import 'package:bmta_rfid_app/models/auth/reqlogin.dart';
import 'package:bmta_rfid_app/provider/controller/login_controller.dart';
import 'package:bmta_rfid_app/provider/state/login_state.dart';
import 'package:bmta_rfid_app/themes/fontsize.dart';
import 'package:bmta_rfid_app/widgets/custom_text_default.dart';
import 'package:bmta_rfid_app/widgets/textFrom/custom_text_form_field.dart';
import 'package:bmta_rfid_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
// สำหรับ kIsWeb และ defaultTargetPlatform

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isIconTrue = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() {
    if (_formKey.currentState!.validate()) {
      final username = _usernameController.text.trim();
      final password = _passwordController.text.trim();

      ref.read(loginControllerProvider.notifier).login(Reqlogin(username: username, password: password));
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginControllerProvider);

    ref.listen<LoginState>(loginControllerProvider, (previous, next) {
      if (next.resLoginModel?.isSuccess == true) {
        Navigator.pushNamed(context, AppRouter.navigationBar);
      } else if (next.isError) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(next.resLoginModel?.message ?? "Login failed")));
      }
      

    });
  
    // ref.listen(loginControllerProvider, (previous, next) {

    //   next.whenOrNull(
    //     data: (res) {
    //       if (res?.isSuccess ?? false) {
    //         Navigator.pushNamed(context, AppRouter.navigationBar);
    //       } else {
    //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res?.message ?? "Login failed")));
    //       }
    //     },
    //     error: (err, _) {
    //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $err')));
    //     },
    //   );
    // });

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        SvgPicture.asset("lib/assets/icons/bmta_logo_svg.svg", height: 200),
                        const SizedBox(height: 20),
                        CustomTextFormField(
                          controller: _usernameController,
                          hintText: 'Enter your Email',
                          obscureText: false,
                          validator: (value) => (value == null || value.isEmpty) ? 'Please enter an email' : null,
                          inputDecoration: inputDecoration(
                            nameImage: "lib/assets/icons/ic_login_email.svg",
                            context,
                            hintText: "อีเมล",
                          ),
                        ),
                        const SizedBox(height: 20),
                        CustomTextFormField(
                          controller: _passwordController,
                          obscureText: isIconTrue,
                          validator: (value) => (value == null || value.isEmpty) ? 'Please enter a password' : null,
                          inputDecoration: inputDecoration(
                            nameImage: "lib/assets/icons/ic_login_password.svg",
                            context,
                            hintText: "Password",
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() => isIconTrue = !isIconTrue);
                              },
                              icon: Icon(isIconTrue ? Icons.visibility : Icons.visibility_off, size: 16, color: Colors.grey),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () {
                            // Forgot password navigation
                          },
                          child: Text(
                            'ลืมรหัสผ่าน ?',
                            style: const TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.07,
                          child: ElevatedButton(
                            onPressed: loginState.isLoading ? null : _onLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4CAF50),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                            ),
                            child: 
                             loginState.isLoading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : CustomTextDefault(
                                    text: 'เข้าสู่ระบบ',
                                    style: TextStyle(fontWeight: fontBold, fontFamily: fontFamily, color: Colors.white),
                                  ),
                           
                          ),
                        ),
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
}

//   void loadLogin() async {
//     setState(() {
//       _isSubmit = false;
//       _isLogin = false; // Set loading state to true
//     });

//     try {
//       final response = await repository.getLoginUser(
//         Reqlogin(username: _usernameController.text, password: _passwordController.text),
//       );

//       setState(() {
//         _isLogin = false; // Stop loading
//       });

//       if (response.isSuccess) {
//         if (mounted) {
//           print("Login Success");
//           Navigator.pushNamed(context, AppRouter.navigationBar);
//         }
//         return;
//       }

//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response.message)));
//       }
//     } catch (e) {
//       setState(() {
//         _isLogin = false; // Stop loading in case of an error
//       });

//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
//       }
//     }
//   }
// }
