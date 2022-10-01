import 'package:dollan/models/booking/booking_response.dart';
import 'package:dollan/utilities/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';

class BookingModel extends Model{
  GetBookingData _getBookingData;
  GetBookingData get getBookingData => _getBookingData;

  bool _busy = false;
  bool get busy => _busy;

  bool _dataDone = false;
  bool get dataDone => _dataDone;

  getData(String id){
    _busy = true;
    notifyListeners();

    Services().getBooking(id).then((res){


      if(res.statusCode==200){
        GetBookingResponse getBookingResponse = getBookingResponseFromJson(res.body);
        if(getBookingResponse.success == 'true'){
          _getBookingData = getBookingResponse.data;
          _dataDone = true;
          notifyListeners();

          _busy = false;
          notifyListeners();
        }
      }
    });
  }

}
