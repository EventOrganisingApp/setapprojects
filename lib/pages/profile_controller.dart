import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'user_model.dart';
import 'user_repository.dart';

String userDocumentId = '';
String userPass = '';
String accountName ='';

class ProfileController extends GetxController {
  static ProfileController get instance => Get.find();

  final _userRepo = Get.put(UserRepository());
  Future<List<UserModel>> getUserData(String email) async {
    List<UserModel> userDataList = await _userRepo.getUserDetails(email);
    userDocumentId = userDataList[0].id!;
    userPass = userDataList[0].passWord;
    accountName = userDataList[0].userName;
    return userDataList;
  }

  Future<List<UserModel>> getInviteData(String email) async {
    List<UserModel> userDataList = await _userRepo.getUserDetails(email);
    return userDataList;
  }

  updateRecord(UserModel user) async {
    await _userRepo.updateUserRecord(user);
  }

  Future<void> updatePassword(UserModel user, String newPassword) async {
    await _userRepo.updatePassword(user, newPassword);
  }
}
