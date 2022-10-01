import 'package:dollan/models/booking/voucher_list_response.dart';
import 'package:dollan/models/profile/profile_model.dart';
import 'package:dollan/models/viewmodels/cart_model.dart';
import 'package:dollan/models/viewmodels/categories_model.dart';
import 'package:dollan/models/viewmodels/main_model.dart';
import 'package:dollan/models/viewmodels/search_model.dart';
import 'package:dollan/models/viewmodels/trans_history_model.dart';
import 'package:dollan/pages/boarding.dart';
import 'package:dollan/pages/booking.dart';
import 'package:dollan/pages/cart.dart';
import 'package:dollan/pages/categories.dart';
import 'package:dollan/pages/chat.dart';
import 'package:dollan/pages/checkout.dart';
import 'package:dollan/pages/child/detail_review.dart';
import 'package:dollan/pages/detail.dart';
import 'package:dollan/pages/favorit.dart';
import 'package:dollan/pages/forgot_password.dart';
import 'package:dollan/pages/init.dart';
import 'package:dollan/pages/login.dart';
import 'package:dollan/pages/maingate.dart' as prefix0;
import 'package:dollan/pages/operator_profile.dart';
import 'package:dollan/pages/payment.dart';
import 'package:dollan/pages/payment_gateway.dart';
import 'package:dollan/pages/profile.dart';
import 'package:dollan/pages/search.dart';
import 'package:dollan/pages/signup.dart';
import 'package:dollan/pages/splashscreen.dart';
import 'package:dollan/pages/survey.dart';
import 'package:dollan/pages/profile_transaction_history.dart';
import 'package:dollan/pages/voucher_detail.dart';
import 'package:dollan/pages/profile_vouchers.dart';
import 'package:dollan/templates/DetailArguments.dart';
import 'package:dollan/templates/RouteArguments.dart';
import 'package:flutter/material.dart';
import 'package:dollan/pages/parent.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'models/viewmodels/booking_model.dart';
import 'models/viewmodels/detail_model.dart';
import 'models/viewmodels/home_model.dart';
import 'models/viewmodels/login_model.dart';

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return


      ScopedModel<MainModel>(
      model: MainModel.instance,
      child:
      
      MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Dollan',
        theme: ThemeData(
            primaryColor: Color(0xfffcef57),
            primaryTextTheme: TextTheme(
              title: TextStyle(
                  color: Color(0xff221f1f), fontWeight: FontWeight.bold),
              body1: TextStyle(color: Color(0xff221f1f)),
              subtitle: TextStyle(color: Color(0xff221f1f)),
              subhead: TextStyle(
                  color: Color(0xff221f1f), fontWeight: FontWeight.bold),
              caption: TextStyle(
                  color: Color(0xff221f1f), fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.white,
            scaffoldBackgroundColor: Colors.white,
          fontFamily: 'Airbnb'),
        initialRoute: 'splashscreen',
        onGenerateRoute: generateRoute,
      ),

    );
  }



  Route generateRoute(RouteSettings settings) {
  //  var args = settings.arguments;
    RouteArguments routeArguments = settings.arguments;

    switch (settings.name) {
      case 'splashscreen':
        return MaterialPageRoute(
            settings: settings, builder: (context) => SplashScreen());
      case 'boarding':
        return MaterialPageRoute(
            settings: settings, builder: (context) => BoardingPage());

      case 'maingate':
        return MaterialPageRoute(
            settings: settings, builder: (context) => prefix0.MainGatePage());

      case 'review':
        return MaterialPageRoute(
            settings: settings, builder: (context) => DetailReview(id: routeArguments.id, userid: routeArguments.userid,));
      case 'home':
        return MaterialPageRoute(
            settings: settings, builder: (context) => ScopedModel<MainModel>(
              model: MainModel.instance,
              child: Parent(tabIndex: routeArguments.tabIndex,),
            ));
      case 'categories':
        return MaterialPageRoute(
            settings: settings,
            builder: (context) => ScopedModel<CategoriesModel>(
                  child: 
                  
                  // CategoriesPage(title: routeArguments.title, id: routeArguments.id, type: routeArguments.type,),

                  CategoriesPage(routeArguments),

                  model: CategoriesModel(),
                ));
      case 'detail':
//        print('argumtents: ${settings.arguments}');
//        DetailArguments detailArguments = settings.arguments;
// RouteArguments routeArguments = settings.arguments;
        return MaterialPageRoute(
          
            settings: settings,
            builder: (context) => ScopedModel<MainModel>(
                  child: DetailPage(
                    id: routeArguments.id,
                  ),
                  model: MainModel.instance,
                ));
      // case 'search':
      //   return MaterialPageRoute(
      //       settings: settings, builder: (context) =>SearchPage(args: routeArguments,));
      case 'checkout':
        return MaterialPageRoute(
            settings: settings, builder: (context) => CheckoutPage());

      case 'signUp':
        return MaterialPageRoute(
            settings: settings, builder: (context) => SignUp());
      case 'login':
        return MaterialPageRoute(
            settings: settings,
            builder: (context) => ScopedModel<MainModel>(
                  model: MainModel.instance,
                  child: Login(),
                ));
      case 'vouchers':
        return MaterialPageRoute(
            settings: settings, builder: (context) => VouchersPage());
      case 'vouchers/detail':
        return MaterialPageRoute(
            settings: settings, builder: (context) => VoucherDetailPage(item: routeArguments.voucherItem,));
      case 'operator':
        return MaterialPageRoute(
            settings: settings, builder: (context) => OperatorProfilePage());
      case 'survey':
        return MaterialPageRoute(
            settings: settings, builder: (context) => SurveyPage());
      case 'favorite':
        return MaterialPageRoute(
            settings: settings, builder: (context) => FavoritePage());
      case 'booking':
        // BookingArguments bookArgs = settings.arguments;
        return MaterialPageRoute(
            settings: settings, builder: (context) => ScopedModel<BookingModel>(
          model: BookingModel(),
          child: BookingPage(id: routeArguments.id, companyId: routeArguments.companyId,)),
        );
      case 'profile':
        return MaterialPageRoute(
            settings: settings, builder: (context) => ScopedModel<ProfileModel>(
          model: ProfileModel(),
          child: ProfilePage(),
        ));
      case 'chat':
        return MaterialPageRoute(
            settings: settings, builder: (context) => ChatPage(map: routeArguments.map, title: routeArguments.title,));
      case 'payment':
        return MaterialPageRoute(
            settings: settings, builder: (context) => PaymentPage(url: routeArguments.url,));
      case 'forgot':
        return MaterialPageRoute(
            settings: settings, builder: (context) => ForgotPassword());

      case 'cart':
        return MaterialPageRoute(
            settings: settings,
            builder: (context) => ScopedModel<CartModel>(
                  child: CartPage(),
                  model: CartModel(),
                ));
      case 'history':
        return MaterialPageRoute(
            settings: settings,
            builder: (context) => TransactionHistoryPage());
      default:
        return MaterialPageRoute(
            settings: settings, builder: (context) => InitPage());
    }
  }
}
