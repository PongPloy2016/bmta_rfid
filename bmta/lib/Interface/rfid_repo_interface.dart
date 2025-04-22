


import 'package:bmta/models/auth/reqlogin.dart';
import 'package:bmta/models/auth/res_login_model.dart';
import 'package:bmta/models/equipmentItemModel/mockup_memo_model.dart';
import 'package:bmta/models/equipmentItemModel/reqMemoList.dart';
import 'package:bmta/models/memoDataClassification/memo_data_classification_model.dart';
import 'package:bmta/models/pokemon.dart';
import 'package:flutter/material.dart';



abstract class AuthRepoInterface {
  Future<ResLoginModel> getLoginUser(Reqlogin reqLogin);
  Future<ResLoginModel> getlogin();
}

abstract class MemoListRepoInterface {
  Future<MockupMemoModel> getMenoList(ReqMemoList reqLogin);
}


abstract class MemoDataClassificationRepoInterface {
  Future<MemoDataClassificationModel> getMemoDataClassification(BuildContext context);
}