import 'dart:async';

import 'package:bmta_rfid_app/Interface/rfid_repo_interface.dart';
import 'package:bmta_rfid_app/models/auth/reqlogin.dart';
import 'package:bmta_rfid_app/models/auth/res_login_model.dart';
import 'package:bmta_rfid_app/models/equipmentItemModel/equipmentItem.dart';
import 'package:bmta_rfid_app/models/equipmentItemModel/reqMemoList.dart';
import 'package:bmta_rfid_app/provider/data_provider.dart';
import 'package:bmta_rfid_app/repository/rfid_auth_repository.dart';
import 'package:riverpod/riverpod.dart';



// State class to hold the equipment list data, loading, and error states
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

class LoginController extends Notifier<LoginState> {
  late final AuthRepoInterface _repo;

  @override
  LoginState build() {
    _repo = ref.read(authRepositoryProvider);
    return LoginState.initial();
  }

  Future<void> login(Reqlogin reqLogin) async {
    state = LoginState(
      resLoginModel: null,
      isLoading: true,
      isError: false,
      errorMessage: '',
    );

    try {
      final result = await _repo.getLoginUser(reqLogin);

      if (result.isSuccess == true) {
        state = LoginState(
          resLoginModel: result,
          isLoading: false,
          isError: false,
          errorMessage: '',
        );
      } else {
        state = LoginState(
          resLoginModel: result,
          isLoading: false,
          isError: true,
          errorMessage: result.message ?? "Login failed",
        );
      }
    } catch (e) {
      state = LoginState(
        resLoginModel: null,
        isLoading: false,
        isError: true,
        errorMessage: e.toString(),
      );
    }
  }
}

  final authRepositoryProvider = Provider<RFIDAuthRepository>((ref) {
  return RFIDAuthRepository(); // or inject dio here if needed
});
 

final loginControllerProvider =
    NotifierProvider<LoginController, LoginState>(() => LoginController());