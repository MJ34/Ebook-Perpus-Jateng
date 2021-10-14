import 'package:dio/dio.dart';
import 'package:ebook/controller/api.dart';
import 'package:ebook/model/model_category.dart';

Future<List<ModelCategory>> fetchCategory(List<ModelCategory> category) async {
  var request = await Dio().get(ApiConstant().baseUrl+ApiConstant().api+ApiConstant().category);
  for(Map<String, dynamic> cat in request.data) {
    category.add(ModelCategory(catId: cat['cat_id'],
        photoCat: cat['photo_cat'],
        name: cat['name'],
        status: cat['status']));
  }
  return category;
}
