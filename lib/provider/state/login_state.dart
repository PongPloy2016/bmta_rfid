import 'package:bmta_rfid_app/models/auth/res_login_model.dart';

class LoginState {
  final ResLoginModel? resLoginModel;
  final bool isLoading;
  final bool isError;
  final String errorMessage;

  LoginState({
    this.resLoginModel,
    this.isLoading = false,
    this.isError = false,
    this.errorMessage = '',
  });

  factory LoginState.initial() => LoginState(
        resLoginModel: ResLoginModel(
          isSuccess: false,
          message: "",
          data: null,
        ),
        isLoading: false,
        isError: false,
        errorMessage: '',
      );
}