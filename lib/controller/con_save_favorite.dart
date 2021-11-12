import 'package:dio/dio.dart';
import 'package:ebook/controller/api.dart';
import 'package:ebook/shared_pref.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

saveFavorite({
  required BuildContext context,
  required String idEbook,
  required String idUser
}) async{
  var data = {'id_course': idEbook, 'id_user': idUser};
  var request = await Dio().post(ApiConstant().baseUrl+ApiConstant().saveFavorite, data: data);

  //check favorite di db
  var checkFav = await Dio().post(ApiConstant().baseUrl+ApiConstant().checkFavorite, data: data);

  if (request.data == "success") {
    await Alert(
      context: context,
      type: AlertType.success,
      onWillPopActive: true,
      title: 'Berhasil',
      desc: 'Berhasil menambahkan ke favorite',
      style: AlertStyle(
        animationType: AnimationType.fromBottom,
        backgroundColor: Colors.white
      ),
        buttons: [
          DialogButton(
            padding: EdgeInsets.all(1),
            child: Container(
              height: 40,
              child: Text('Okay'),
            ),
            onPressed: (){
              Navigator.pop(context);
              //save favorite
              saveFavoriteEbook(checkFav.data);
            },
          )
        ]
    ).show();
  } else {
    await Alert(
        context: context,
        type: AlertType.success,
        onWillPopActive: true,
        title: 'Hapus Favorite',
        desc: 'Berhasil menghapus data favorite',
        style: AlertStyle(
            animationType: AnimationType.fromBottom,
            backgroundColor: Colors.white
        ),
        buttons: [
          DialogButton(
            padding: EdgeInsets.all(1),
            child: Container(
              height: 40,
              child: Text('Okay'),
            ),
            onPressed: (){
              Navigator.pop(context);
              //hapus favorite
              saveFavoriteEbook(checkFav.data);
            },
          )
        ]
    ).show();
  }
}