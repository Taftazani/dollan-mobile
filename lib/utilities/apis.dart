class Apis {

  static String baseUrl = "https://dollan.id/adminpanel/api";

  String boarding = '$baseUrl/home/onboarding';

  // auth
  String loginNative = '$baseUrl/getinbro';
  String loginGoogle = '$baseUrl/getinbro/google';
  String loginFb = '$baseUrl/getinbro/facebook';
  String register = '$baseUrl/profile/register';
  String getProfile = '$baseUrl/profile/?iduser='; // id_user
  String updateProfile = '$baseUrl/profile/update';
  String forgotPassword = '$baseUrl/getinbro/reset';

  // Home
  String sliders = '$baseUrl/home';
  String popular = '$baseUrl/home/populer';
  String rekomendasi = '$baseUrl/home/rekomendasi';
  String articles = '$baseUrl/home/artikel';
  String articleAll = '$baseUrl/home/artikelall';
  String bestsellers = '$baseUrl/home/bestseller';
  String moods = '$baseUrl/master/mood';
  String moodsAll = '$baseUrl/master/allmood';
  String history = '$baseUrl/booking/history/?userid=';

  // Preferences
  String prefs = '$baseUrl/home/preference';
  String userPrefs = '$baseUrl/home/preference_user/?userid=';
  String prefsSubmit = '$baseUrl/home/preference_submit';
  String prefsUser = '$baseUrl/home/preference_user/?userid=';


  // Catmood
  String catmodList = '$baseUrl/news/?search=&catmod=108';

  // Detail
  String detailSlider = '$baseUrl/news/getgallery/?postid=';
  String detailProduct = '$baseUrl/news/detail/?idnews=';
  String detailAccomodation = '$baseUrl/news/recentpost/?catname=';
  String wisataSejenis = '$baseUrl/news/recentpost/?catname='; // slug
  String sendFavorite = '$baseUrl/news/sendfavorit';
  String kamusuka = '$baseUrl/news/lovely/?userid=';
  String checkComment = '$baseUrl/news/commentcheck/?iduser=';
  String cancellation = '$baseUrl/news/dynamicpage/?idnews=191';
  String getImportantInfo = '$baseUrl/news/getimportant/?postid=';
  String getOtherInfo = '$baseUrl/news/getother/?postid=';

  // Booking
  String getBooking = '$baseUrl/booking/getbooking/?postid=';
  String sendBooking = '$baseUrl/booking/sendbooking';
  String ketentuan = '$baseUrl/news/dynamicpage/?idnews=193';
  String contactUs = '$baseUrl/news/contact';
  String tos = '$baseUrl/news/dynamicpage/?idnews=102';
  String refund = '$baseUrl/booking/refund';

  // Cart
  String cart = '$baseUrl/booking/cart/?userid=';
  String deleteCartItem = '$baseUrl/booking/deletcart';
  String payBooking = 'https://dollan.id/payment/index.php';
  String payAllBooking = 'https://dollan.id/payment/all.php';

  // Search
  String getPropinsi = '$baseUrl/master/propinsi';
  String getKota = '$baseUrl/master/kota';
  String getActivities = '$baseUrl/master/kategori';

  // Comment
  String getComments = '$baseUrl/news/commentlist/?id=';
  String sendComment = '$baseUrl/news/sendcomment';

  // Favorit
  String getListFavorite = '$baseUrl/news/getListFavorit/?iduser=';
  String deleteFavorit = '$baseUrl/news/deletfavorit';

  // Voucher
  String getVoucher = '$baseUrl/booking/voucher/?userid=';
  String verifyOperator = '$baseUrl/booking/vouche_verify/';
  String voucherDetail = '$baseUrl/booking/voucher_detil/?voucherno=';

}