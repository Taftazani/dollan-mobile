import 'package:dollan/models/profile/post_profile_data_model.dart';
import 'package:dollan/templates/RouteArguments.dart';
import 'package:dollan/utilities/apis.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Services {
  Future<http.Response> boarding() async {
    final response = await http.get('${Apis().boarding}');
    return response;
  }

  Future<http.Response> loginNative(Map authData) async {
    final response = await http.post('${Apis().loginNative}',
        headers: {"Accept": "application/json"}, body: authData);
    return response;
  }

  Future<http.Response> loginGoogle(Map authData) async {
    final response = await http.post('${Apis().loginGoogle}',
        headers: {"Accept": "application/json"}, body: authData);
    return response;
  }

  Future<http.Response> loginFb(Map authData) async {
    final response = await http.post('${Apis().loginFb}',
        headers: {"Accept": "application/json"}, body: authData);
    return response;
  }

  Future<http.Response> register(Map authData) async {
    print('register data : $authData');
    final response = await http.post('${Apis().register}',
        headers: {"Accept": "application/json"}, body: authData);
    return response;
  }

//  Future<http.Response> getProfile(Map authData) async {
//    final response = await http.post('${Apis().getProfile}',
//        headers: {"Accept": "application/json"}, body: authData);
//    return response;
//  }

  Future<int> updateProfile(PostProfileDataModel item) async {
    var request = http.MultipartRequest("POST", Uri.parse(Apis().updateProfile));

    request.fields['id'] = item.id;
    request.fields['firstname'] = item.firstname==null? '' : item.firstname;
    request.fields['lastname'] = item.lastname==null? '' : item.lastname;
    request.fields['mobilephone'] = item.mobilephone==null? '' : item.mobilephone;
    request.fields['gender'] = item.gender==null? '' : item.gender;
    request.fields['birth_date'] = item.birthDate==null? '' : item.birthDate;
    request.fields['address'] = item.address==null? '' : item.address;
    request.fields['email'] = item.email==null? '' : item.email;
    request.fields['photo'] = item.photo==null? '' : item.photo;
    request.fields['password'] = item.password==null? '' : item.password;

//    request.fields['id'] = '37';
//    request.fields['firstname'] = 'Ucok';
//    request.fields['lastname'] = 'Aka';
//    request.fields['mobilephone'] = '0987654321';
//    request.fields['gender'] = '';
//    request.fields['birth_date'] = '';
//    request.fields['address'] = 'Jl Sas 123';
//    request.fields['email'] = 'ucok@aka.com';
//    request.fields['photo'] = null;
//    request.fields['password'] = '';

    print('--------------------------------------');
    print('---->>>> request: ${request.fields}');
    print('--------------------------------------');

    if (item.photo != '') {
      print('send pictures...: ${item.photo}');

      request.files
          .add(await http.MultipartFile.fromPath('photo', item.photo));
    }

    final response = await request.send();
    return response.statusCode;
  }

  Future<http.Response> getProfile(String userid) async {
    final response = await http.get('${Apis().getProfile}$userid');
    return response;
  }

  // --- Home

  Future<http.Response> getSliders() async {
    final response = await http.get('${Apis().sliders}');
    return response;
  }

  Future<http.Response> getPopular() async {
    final response = await http.get('${Apis().popular}');
    return response;
  }

  Future<http.Response> getRecommendation() async {
    final response = await http.get('${Apis().rekomendasi}');
    return response;
  }

  Future<http.Response> getArticles() async {
    final response = await http.get('${Apis().articles}');
    return response;
  }

  Future<http.Response> getArticleAll() async {
    final response = await http.get('${Apis().articleAll}');
    return response;
  }

  Future<http.Response> getBestSeller() async {
    final response = await http.get('${Apis().bestsellers}');
    return response;
  }

  Future<http.Response> getMoods() async {
    final response = await http.get('${Apis().moods}');
    return response;
  }

  Future<http.Response> getAllMoods() async {
    final response = await http.get('${Apis().moodsAll}');
    return response;
  }

  // --- Detail

  Future<http.Response> getDetailSlider(String id) async {
    // print('${Apis().detailSlider}$id');
    final response = await http.get('${Apis().detailSlider}$id');
    return response;
  }

  Future<http.Response> getDetailProduct(String id) async {
    // print('${Apis().detailSlider}$id');
    final response = await http.get('${Apis().detailProduct}$id');
    return response;
  }

  Future<http.Response> getDetailAccomodation(String id) async {
    // print('${Apis().detailSlider}$id');
    final response = await http.get('${Apis().detailAccomodation}$id');
    return response;
  }

  Future<http.Response> getBooking(String id) async {
    // print('${Apis().detailSlider}$id');
    final response = await http.get('${Apis().getBooking}$id');
    return response;
  }

  Future<http.Response> sendBooking(Map authData) async {
    print('sendBooking data: $authData');
    final response = await http.post('${Apis().sendBooking}', body: authData);
    return response;
  }

  Future<http.Response> getCart(String userid) async {
    final response = await http.get('${Apis().cart}$userid');
    return response;
  }

  Future<http.Response> deleteCartItem(Map authData) async {
    print('${Apis().deleteCartItem}');
    print(authData);
    final response = await http.post('${Apis().deleteCartItem}', body: authData);
    return response;
  }

  Future<http.Response> payBooking(Map authData) async {
  
    final response = await http.post('${Apis().payBooking}', body: authData);
    return response;
  }

  Future<http.Response> payAllBooking(Map authData) async {
    print('services: pay all booking');
    print(authData);
    final response = await http.post('${Apis().payAllBooking}', body: authData);
    return response;
  }

  Future<http.Response> getPrefsQuestion() async {
    // print('${Apis().detailSlider}$id');
    final response = await http.get('${Apis().prefs}');
    return response;
  }

  Future<http.Response> savePrefs(Map authData) async {
    final response = await http.post('${Apis().prefsSubmit}',
        headers: {"Accept": "application/json"}, body: authData);
    return response;
  }

  Future<http.Response> getImportantInfo(String id) async {
    final response = await http.get('${Apis().getImportantInfo}$id');
    return response;
  }

  Future<http.Response> getOtherInfo(String id) async {
    final response = await http.get('${Apis().getOtherInfo}$id');
    return response;
  }

  Future<http.Response> getCatMood(
    
    // {String id, String search, String price, String adventure, String kota, int page}

    RouteArguments args
    
    ) async {
    
    print('${Apis.baseUrl}/news/?page=${args.page==null?'':args.page}&search=${args.search==null?'':args.search}&catmod=${args.id==null?'':args.id}&adventure=${args.adventure==null?'':args.adventure}&price=${args.price==null?'':args.price}&kota=${args.kota==null?'':args.kota}&sort=${args.sort==null?'':args.sort}');

    // final response = await http.get('${Apis.baseUrl}/news/?page=$page&search=$search&catmod=$id&adventure=$adventure&price=&kota=$kota');

    final response = await http.get('${Apis.baseUrl}/news/?page=${args.page==null?'':args.page}&search=${args.search==null?'':args.search}&catmod=${args.id==null?'':args.id}&adventure=${args.adventure==null?'':args.adventure}&price=${args.price==null?'':args.price}&kota=${args.kota==null?'':args.kota}&sort=${args.sort==null?'':args.sort}');

    return response;
  }

  Future<http.Response> getPrefsUser(String userid) async {
    // print('${Apis().detailSlider}$id');
    final response = await http.get('${Apis().prefsUser}$userid');
    return response;
  }

  Future<http.Response> getPropinsi() async {
    final response = await http.get('${Apis().getPropinsi}');
    return response;
  }

  Future<http.Response> getKota() async {
    final response = await http.get('${Apis().getKota}');
    return response;
  }

  Future<http.Response> getActivities() async {
    final response = await http.get('${Apis().getActivities}');
    return response;
  }

  Future<http.Response> getWisataSejenis(String catname) async {
    final response = await http.get('${Apis().wisataSejenis}$catname');
    return response;
  }

  Future<http.Response> getComments(String id) async {
    final response = await http.get('${Apis().getComments}$id');
    return response;
  }

  Future<http.Response> sendComment(Map authData) async {
    final response = await http.post('${Apis().sendComment}', body: authData);
    return response;
  }

  Future<http.Response> sendFavorite(Map authData) async {
    final response = await http.post('${Apis().sendFavorite}', body: authData);
    return response;
  }

  Future<http.Response> getFavorite(String userId, String productId) async {
    final response = await http.get('${Apis.baseUrl}/news/getfavorit/?iduser=$userId&postid=$productId');
    return response;
  }

  Future<http.Response> getKamuSuka(String userid) async {
    final response = await http.get('${Apis().kamusuka}$userid');
    return response;
  }

  Future<http.Response> sendEmailForgotPassword(Map authData) async {
    final response = await http.post('${Apis().forgotPassword}', body: authData);
    return response;
  }

  Future<http.Response> getListFavorit(String userid) async {
    final response = await http.get('${Apis().getListFavorite}$userid');
    return response;
  }

  Future<http.Response> deleteFavorit(Map authData) async {
    print('deleteFavorit: $authData');
    final response = await http.post('${Apis().deleteFavorit}', body: authData);
    return response;
  }

  Future<http.Response> getUserPrefs(String userid) async {
    final response = await http.get('${Apis().userPrefs}$userid');
    return response;
  }

  Future<http.Response> checkUserComment(String userid, String postid) async {
    // cek apakah user sudah pernah kasi review
    final response = await http.get('${Apis().checkComment}$userid&postid=$postid');
    return response;
  }

  Future<http.Response> getHistory(String userid) async {
    final response = await http.get('${Apis().history}$userid');
    return response;
  }

  Future<http.Response> getVoucher(String userid) async {
    print('${Apis().getVoucher}$userid');
    final response = await http.get('${Apis().getVoucher}$userid');
    return response;
  }

  Future<http.Response> getVoucherDetail(String voucherNo) async {
    final response = await http.get('${Apis().voucherDetail}$voucherNo');
    return response;
  }

  Future<http.Response> verifyOperator(Map authData) async {
    print('verify operator data: $authData');
    final response = await http.post('${Apis().verifyOperator}', body: authData);
    return response;
  }

  Future<http.Response> getCancellationPolicy() async {
    final response = await http.get('${Apis().cancellation}');
    return response;
  }

  Future<http.Response> getKetentuan() async {
    final response = await http.get('${Apis().ketentuan}');
    return response;
  }

  Future<http.Response> getTos() async {
    final response = await http.get('${Apis().tos}');
    return response;
  }

  Future<http.Response> getContact() async {
    final response = await http.get('${Apis().contactUs}');
    return response;
  }

  Future<http.Response> refund(Map data) async {
    final response = await http.post('${Apis().refund}', body: data);
    return response;
  }
  
}
