import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dollan/models/profile/post_profile_data_model.dart';
import 'package:dollan/models/profile/profile_data_model.dart';
import 'package:dollan/utilities/helper.dart';
import 'package:dollan/utilities/services.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:permission_handler/permission_handler.dart';

enum PhotoSource {
  camera,
  gallery,
}

class ProfileModel extends Model{

  double _maxSize = 300;
  File _file;
  bool _busy = false;
  ProfileData _profileData;

  File get file => _file;
  bool get busy => _busy;
  ProfileData get profileData => _profileData;

  onTakePicture() {
    checkPermission(PermissionGroup.camera);
  }

  requestPermission(p) async {
    Map<PermissionGroup, PermissionStatus> permissions =
    await PermissionHandler().requestPermissions([p]);

    if (permissions.values.toList()[0] == PermissionStatus.granted) {
      takePicture(PhotoSource.camera);
    }
  }

  checkPermission(p) async {
    PermissionStatus permission =
    await PermissionHandler().checkPermissionStatus(p);

    if (permission.value == PermissionStatus.granted.value) {
      takePicture(PhotoSource.camera);
    } else {
      requestPermission(PermissionGroup.camera);
    }
  }

  Future takePicture(PhotoSource _source) async {
    File image;

    if (_source == PhotoSource.camera) {
      image = await ImagePicker.pickImage(
          source: ImageSource.camera, maxHeight: _maxSize, maxWidth: _maxSize);
    } else {
      image = await ImagePicker.pickImage(
          source: ImageSource.gallery, maxHeight: _maxSize, maxWidth: _maxSize);
    }

    _file = image;
    notifyListeners();
  }

  Future<ProfileData> getProfile(String userid) async{
    print('get profile');
    _busy = true;
    notifyListeners();

    await Services().getProfile(userid).then((res){

      _busy = false;
      notifyListeners();

//      print(res.body);

      if(res.statusCode==200){
        ProfileDataModel profileDataModel = profileDataModelFromJson(res.body);
        if(profileDataModel.success=='true'){
          _profileData = profileDataModel.data;

          notifyListeners();
        }
      }
    });

    return _profileData;

  }

  updateProfile(BuildContext context, PostProfileDataModel data)async{
    print(data);
    _busy = true;
    notifyListeners();
    await Services().updateProfile(data).then((code){
      _busy = false;
      notifyListeners();
      if(code==200){
        print('sukses update profile');
        Helper().saveUserPrefs('username', data.firstname);
        Helper().showAlert(context, 'Profile berhasil diperbaharui.');
      } else {
        Helper().showAlert(context, 'Gagal mengupdate data');
      }
    }).catchError((err){
      print('error update : $err');
    });
  }
}