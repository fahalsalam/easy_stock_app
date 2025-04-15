import 'dart:developer';

import 'package:easy_stock_app/models/masters/general/general_get_model.dart';
import 'package:easy_stock_app/services/api_services/masters/general_settings/validity_get.dart';
import 'package:easy_stock_app/services/api_services/masters/general_settings/validity_post.dart';
import 'package:easy_stock_app/utils/common_widgets/smackbar.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class GeneralSettingProvider with ChangeNotifier {
  int time=0;
Future<void> getGeneralSettingsApi() async {
  GeneralsettingModel? settings = await getGeneralSettings();
  if (settings != null) {
    log("Settings fetched: ${settings.data}");
    time=settings.data.first.editTimeValidityInMinutes;
  } else {
    log("Failed to fetch settings.");
  }
}

  postGenaralsettingsApi(int value, context) async{
    var res =await postGeneralSettings(value);
    if (res != false) {
      showSnackBar(context, "Saved Sucessfully", "Saved", Colors.white);
    } else {
      showSnackBar(context, "Error", "Please try again", Colors.white);
    }
  }
}
