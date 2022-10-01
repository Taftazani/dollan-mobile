import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dollan/models/profile/post_profile_data_model.dart';
import 'package:dollan/models/profile/profile_data_model.dart';
import 'package:dollan/models/profile/profile_model.dart';
import 'package:dollan/models/viewmodels/main_model.dart';
import 'package:dollan/templates/profile_template.dart';
import 'package:dollan/utilities/apis.dart';
import 'package:dollan/utilities/helper.dart';
import 'package:dollan/utilities/styles.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scoped_model/scoped_model.dart';

class ProfileProfilePage extends StatefulWidget {
  @override
  _ProfileProfilePageState createState() => _ProfileProfilePageState();
}

class _ProfileProfilePageState extends State<ProfileProfilePage> {
  TextEditingController firstNameCtrl = TextEditingController();
  TextEditingController lastNameCtrl = TextEditingController();
  TextEditingController mobileCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController addressCtrl = TextEditingController();
  TextEditingController genderCtrl = TextEditingController();
  TextEditingController dobCtrl = TextEditingController();

  String _name;
  String _mobile;
  String _email;
  String _address;
  String _gender;
  String _dob;
  String genderSelected;
  ProfileData profileData;
  String pw;
  String photo;
  bool socialAuth = false;
  bool belumLogin = false;
  String userid = '';

  bool editMode = true;
  int gender = 1; //1:male 2:female
  bool editProfile = false;
  var genders = ['Laki-laki', 'Perempuan'];
  String currentPhoto;
  String newPhoto;

  DateFormat dateFormat = DateFormat("dd-MM-yyyy");
  DateFormat dateFormatSend = DateFormat("yyyy-MM-dd");

  String _pickDate;
  String _pickDateSend;

  Future _showDatePicker() async {
    DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1930),
      lastDate: DateTime(2020),
    );
    if (picked != null) {
      setState(() {
        _pickDate = dateFormat.format(picked).toString();
        _pickDateSend = dateFormatSend.format(picked).toString();
        dobCtrl.text = _pickDate;
        // _updateDOB();
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => _init());
  }

  _init() async {
    userid = await Helper().getUserPrefs('userid');
    print('userid: $userid');
    if (userid == null) {
      setState(() {
        belumLogin = true;
      });
      return;
    }

    profileData =
        await ScopedModel.of<ProfileModel>(context).getProfile(userid);

    if (profileData == null) return;

    print('profile : $profileData');

    // pw = await Helper().getUserPrefs('password');
    photo = await Helper().getUserPrefs('photo');

    if (profileData.idgoogle != null || profileData.idfacebook != null) {
      socialAuth = true;
    }

    print('photo : $photo');

    var dob = profileData.birthDate;
    if (dob == null || dob == "") {
      dob = '';
      print('gak ada dob');
    } else {
      print('ada dob');
      dob = dateFormat.format(DateTime.parse(dob)).toString();
    }

    setState(() {
      currentPhoto = '${profileData.imageuser}';
      firstNameCtrl.text = profileData.firstname;
      mobileCtrl.text = profileData.mobilephone;
      emailCtrl.text = profileData.email;
      // addressCtrl.text = profileData.address;
      genderCtrl.text = profileData.gender;
      dobCtrl.text = dob;
    });
  }

  _post() async {
    print('post');
    String path = '';
    File photo = ScopedModel.of<ProfileModel>(context).file;
    print('new photo: $photo');
    if (photo != null) {
      path = photo.path;
    }

    var userid = await Helper().getUserPrefs('userid');
//    print(dobCtrl.text);
    print('--> $_pickDateSend');

    PostProfileDataModel _data = PostProfileDataModel(
        id: userid,
        firstname: firstNameCtrl.text,
        lastname: lastNameCtrl.text,
        mobilephone: mobileCtrl.text,
        gender: genderCtrl.text,
        birthDate: _pickDateSend,
        address: addressCtrl.text,
        email: emailCtrl.text,
        photo: path,
        password: pw);

    ScopedModel.of<ProfileModel>(context).updateProfile(context, _data);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    void showPhotoOptions(ProfileModel model) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Pilih sumber foto"),
            actions: <Widget>[
              FlatButton(
                child: Text("Kamera"),
                onPressed: () {
                  if (Platform.isAndroid) {
                    model.checkPermission(PermissionGroup.camera);
                  }
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text("Galeri"),
                onPressed: () {
                  // api 19+ no need permissions
                  model.takePicture(PhotoSource.gallery);
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        },
      );
    }

    return Stack(
      children: <Widget>[
        ProfileBackground(
          top: 0.88,
        ),
        ScopedModelDescendant<ProfileModel>(
          builder: (context, child, model) {
            return Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  leading: Helper().backButton(context),
                  title: Text(
                    'Ubah Profile',
                    style: Theme.of(context)
                        .textTheme
                        .title
                        .apply(fontWeightDelta: 4),
                  ),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                ),
                body: model.busy
                    ? Helper().busyIndicator(context, size)
                    : userid == null
                        ? Center(
                            child: Helper().noLoginData(context,
                                'Login terlebih dahulu untuk mengakses data ini.')
//                            Column(
//                              mainAxisSize: MainAxisSize.min,
//                              children: <Widget>[
//                                Text(
//                                  'Tidak ada data profil.\nLogin terlebih dahulu untuk mengupdate profil Anda.',
//                                  textAlign: TextAlign.center,
//                                ),
//                                Padding(
//                                  padding: const EdgeInsets.all(8.0),
//                                  child: RaisedButton(
//                                    color: Theme.of(context).primaryColor,
//                                    child: Text('Login'),
//                                    onPressed: () {
//                                      Navigator.of(context).pushNamed('login');
//                                    },
//                                  ),
//                                )
//                              ],
//                            ),
                            )
                        : Padding(
                            padding: const EdgeInsets.only(
                                left: 20.0, right: 20, bottom: 0, top: 20),
                            child: GestureDetector(
                              onTap: () {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                              },
                              child: Container(
                                color: Colors.white,
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: <Widget>[
                                      SizedBox(
                                        height: 20,
                                      ),
                                      editMode
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: <Widget>[],
                                            )
                                          : RaisedButton(
                                              shape: StadiumBorder(),
                                              onPressed: () {
                                                setState(() {
                                                  editMode = true;
                                                  _name = firstNameCtrl.text;
                                                  _mobile = mobileCtrl.text;
                                                  _email = emailCtrl.text;
                                                  // _address = addressCtrl.text;
                                                  _gender = genderCtrl.text;
                                                  _dob = dobCtrl.text;
                                                });
                                              },
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  Icon(Icons.edit),
                                                  Text('Ubah Data'),
                                                ],
                                              )),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Stack(
                                            children: <Widget>[
                                              Container(
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.green,
                                                    border: Border.all(
                                                        color: Colors.orange,
                                                        width: 1)),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                  child: model.file != null
                                                      ? Image.file(
                                                          File(model.file.path),
                                                          width: 120,
                                                          height: 120,
                                                          fit: BoxFit.cover,
                                                        )
                                                      : currentPhoto != null
                                                          ?

//                                  Image.network(currentPhoto, width: 120, height: 120, fit: BoxFit.cover,)

                                                          CachedNetworkImage(
                                                              imageUrl: socialAuth &&
                                                                      currentPhoto ==
                                                                          null
                                                                  ? photo
                                                                  : currentPhoto,
                                                              placeholder:
                                                                  (context,
                                                                          url) =>
                                                                      Image
                                                                          .asset(
                                                                'assets/profile.png',
                                                                width: 120,
                                                                height: 120,
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                              fit: BoxFit.cover,
                                                              width: 120,
                                                              height: 120,
                                                              errorWidget:
                                                                  (context,
                                                                      string,
                                                                      obj) {
                                                                return Image
                                                                    .asset(
                                                                  'assets/profile.png',
                                                                  width: 120,
                                                                  height: 120,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                );
                                                              },
                                                            )
                                                          : Image.asset(
                                                              'assets/profile.png',
                                                              width: 120,
                                                              height: 120,
                                                              fit: BoxFit.cover,
                                                            ),
                                                ),
                                              ),
                                              editMode
                                                  ? Positioned(
                                                      bottom: 0,
                                                      right: 0,
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          showPhotoOptions(
                                                              model);
//                                        model.onTakePicture();
                                                        },
                                                        child: Container(
                                                          width: 30,
                                                          height: 30,
                                                          decoration:
                                                              BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            color: Colors
                                                                .grey[200],
                                                          ),
                                                          child: Icon(
                                                            Icons.camera_alt,
                                                            size: 20,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  : Container()
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      _form(editMode: false),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      RaisedButton(
                                          shape: StadiumBorder(),
                                          onPressed: () {
                                            setState(() {
//                            editMode = false;
                                              _post();
                                            });
                                          },
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Icon(Icons.check),
                                              Text('UPDATE'),
                                            ],
                                          )),
                                      SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ));
          },
        ),
      ],
    );
  }

  Widget _form({bool editMode}) {
    return Column(
      children: <Widget>[
        _field(
            edit: editMode,
            label: 'Nama',
            ctrl: firstNameCtrl,
            isNumber: false,
            isEmail: false),
        _field(
            edit: editMode,
            label: 'Mobile',
            ctrl: mobileCtrl,
            isNumber: true,
            isEmail: false),
        _field(
            edit: editMode,
            label: 'Email',
            ctrl: emailCtrl,
            isNumber: false,
            isEmail: true),
        // _field(
        //     edit: editMode,
        //     label: 'Alamat',
        //     ctrl: addressCtrl,
        //     isNumber: false,
        //     isEmail: false),
        _field(
            edit: editMode,
            label: 'Gender',
            ctrl: genderCtrl,
            isNumber: false,
            isEmail: false),
        _field(
            edit: editMode,
            label: 'Tgl. Lahir',
            ctrl: dobCtrl,
            isNumber: false,
            isEmail: false),
        // Padding(
        //   padding: const EdgeInsets.only(top: 12.0),
        //   child: Column(
        //     children: <Widget>[
        //       Row(
        //         children: <Widget>[
        //           Text(
        //             'Alamat',
        //             style: TextStyle(color: Colors.grey),
        //           ),
        //         ],
        //       ),
        //       Helper().spacer(isVertical: true),
        //       TextField(
        //         controller: addressCtrl,
        //         maxLines: 3,
        //         keyboardType: TextInputType.multiline,
        //         decoration: InputDecoration(border: OutlineInputBorder()),
        //       ),
        //     ],
        //   ),
        // )
      ],
    );
  }

  Widget _field(
      {bool edit,
      String label,
      TextEditingController ctrl,
      bool isNumber,
      bool isEmail}) {
    return Row(
      children: <Widget>[
        Flexible(
          child: TextField(
            enabled:
                label == 'Gender' || label == 'Tgl. Lahir' ? false : editMode,
            decoration: InputDecoration(
              labelText: label,
              labelStyle: TextStyle(fontSize: 16, color: Colors.black),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
            controller: ctrl,
            keyboardType: isNumber
                ? TextInputType.number
                : isEmail ? TextInputType.emailAddress : TextInputType.text,
          ),
        ),
        editMode && ctrl == genderCtrl || editMode && ctrl == dobCtrl
            ? IconButton(
                icon: Icon(
                  ctrl == genderCtrl ? Icons.person : Icons.date_range,
                  color: Colors.grey,
                ),
                onPressed: () {
                  if (ctrl == dobCtrl) {
                    _showDatePicker();
                  } else if (ctrl == genderCtrl) {
                    _genderOption();
                    // _editProfileUnit(
                    //     label: label,
                    //     ctrl: ctrl,
                    //     isNumber: isNumber,
                    //     isEmail: isEmail);
                  }
                },
              )
            : Container()
      ],
    );
  }

  _editProfile() async {
    String _name = firstNameCtrl.text;
    String _mobile = mobileCtrl.text;
    String _email = emailCtrl.text;
    String _address = addressCtrl.text;
    String _gender = genderCtrl.text;
    String _dob = dobCtrl.text;

    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            content: _form(editMode: true),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  'Simpan',
                  style: Styles().button(),
                ),
                onPressed: () {
                  //
                },
              ),
              FlatButton(
                child: Text(
                  'Batal',
                  style: Styles().button(),
                ),
                onPressed: () {
                  firstNameCtrl.text = _name;
                  mobileCtrl.text = _mobile;
                  emailCtrl.text = _email;
                  // addressCtrl.text = _address;
                  genderCtrl.text = _gender;
                  dobCtrl.text = _dob;

                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  _genderOption() async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Pilih Gender'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    setState(() {
                      gender = 1;
                      genderCtrl.text = genders[gender - 1];
                      Navigator.of(context).pop();
                    });
                  },
                  child: ListTile(
                    title: Text('Laki-laki'),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      gender = 2;
                      genderCtrl.text = genders[gender - 1];
                      Navigator.of(context).pop();
                    });
                  },
                  child: ListTile(
                    title: Text('Perempuan'),
                  ),
                )
                // ListView(
                //   physics: NeverScrollableScrollPhysics(),
                //   shrinkWrap: true,
                //   children: <Widget>[
                //     ListTile(title: Text('Laki-laki'),),
                //     ListTile(title: Text('Laki-laki'),),
                //   ],
                // ),
              ],
            ),
          );
        });
  }

  _editProfileUnit(
      {String label,
      TextEditingController ctrl,
      bool isNumber,
      bool isEmail}) async {
    TextEditingController tempCtrl = TextEditingController();
    // TextEditingController resetCtrl = TextEditingController();
    tempCtrl.text = ctrl.text;
    List<String> _listGender = ['Laki-Laki', 'Perempuan'];

    _updateGender(int g) {
      print('gender : ${_listGender[g]}');
      setState(() {
        ctrl.text = _listGender[g];
      });
      Navigator.of(context).pop();
    }

    await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                label == 'Gender'
                    ? Container(
                        height: 100,
                        child: ListView(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                FlatButton(
                                  child: Text('Laki-Laki'),
                                  onPressed: () => _updateGender(0),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                FlatButton(
                                  child: Text('Perempuan'),
                                  onPressed: () => _updateGender(1),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    : TextField(
                        keyboardType: isNumber
                            ? TextInputType.number
                            : isEmail
                                ? TextInputType.emailAddress
                                : TextInputType.text,
                        autofocus: true,
                        decoration: InputDecoration(labelText: label),
                        controller: tempCtrl,
                      ),
              ],
            ),
            actions: <Widget>[
              label == 'Gender'
                  ? Container()
                  : FlatButton(
                      child: Text(
                        'Simpan',
                        style: Styles().button(),
                      ),
                      onPressed: () {
                        if (label == 'Tgl. Lahir') {
                        } else {
                          setState(() {
                            ctrl.text = tempCtrl.text;
                            Navigator.of(context).pop();
                          });
                        }
                      },
                    ),
              FlatButton(
                child: Text(
                  'Batal',
                  style: Styles().button(),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}
