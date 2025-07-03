// ignore_for_file: constant_identifier_names

import 'dart:developer';

import 'package:easy_stock_app/utils/token_manager/token_manager.dart';

// production url
const baseUrl = 'https://easystockapi.scanntek.com';

// debug url
//  const baseUrl = "http://winserv19.scanntek1.com:517";

const loginRoute = '$baseUrl/api/6663/getAuthenticated';
const productLoadRoute = '$baseUrl/api/6364/getProductMasterLoad';
const addCategoryRoute = '$baseUrl/api/6364/postCategoryMaster';
const CategoryListRoute = '$baseUrl/api/6364/getCategoryMaster';
const EditCategoryRoute = '$baseUrl/api/6364/putCategoryMaster';
const UOMAddRoute = '$baseUrl/api/6364/postUOMMaster';
const UOMGETRoute = '$baseUrl/api/6364/getUOMMaster';
const UOMEditRoute = '$baseUrl/api/6364/putUOMMaster';
const itemGETRoute = '$baseUrl/api/6364/getProductMaster';
const itemPOSTRoute = '$baseUrl/api/6364/postProductMaster';
const itemPUTRoute = '$baseUrl/api/6364/putProductMaster';
const ImageUploadRoute =
    'https://fileserver.sacrosys.net/api/1234/UploadImages';
const addVehicleDetailsRoute = '$baseUrl/api/6364/postVehicleMaster';
const getVehicleDetailsRoute = '$baseUrl/api/6364/getVehicleMaster';
const UpdateVehicleDetailsRoute = '$baseUrl/api/6364/putVehicleMaster';
const getCategoryByidRoute = '$baseUrl/api/6365/getProductListByCategory';
const barcodeApiRoute = '$baseUrl/api/6365/getProductListByBarcode';
const postPurchaseOrdeRoute = '$baseUrl/api/6365/postPurchaseOrder';

const getPurchaseorderRoute = '$baseUrl/api/6365/getPurchaseOrderList';
const getPurchaseorderDetailsRoute =
    '$baseUrl/api/6365/getPurchaseOrderListByID';
const postUserMasterRoute = '$baseUrl/api/6364/postUserMaster';
const putUserMasterRoute = '$baseUrl/api/6364/putUserMaster';
const getUserMasterRoute = '$baseUrl/api/6364/getUserMaster';
const customerGetRoute = '$baseUrl/api/6364/getCustomerMaster';
const customerPostRoute = '$baseUrl/api/6364/postCustomerMaster';
const customerPutRoute = '$baseUrl/api/6364/putCustomerMaster';
const getPurchaseOrderbyProductRoute =
    '$baseUrl/api/6365/getPurchaseOrderbyProduct';
const getPurchaseOrderRoute = '$baseUrl/api/6365/getPurchaseOrderListBPO';
const getPurchaseUpdateRoute = '$baseUrl/api/6365/BPOOrderstatusUpdate';
const getBPOvehiclesRoute = '$baseUrl/api/6365/getBPOByVehicles';
const getProductSummaryRoute = '$baseUrl/api/6365/getProductSummary';
const getBPODetailsByVehicleIDRoute =
    '$baseUrl/api/6365/getBPODetailsByVehicleID';
const getOrderDetailsByCustomerIDRoute =
    '$baseUrl/api/6365/getOrderDetailsByCustomerID';
const getpendingRoute = '$baseUrl/api/6365/getPendingBPO';
const getpendingDetailsRoute = '$baseUrl/api/6365/getPendingBPODetailsByID';
// history
const getHistoryRoute = '$baseUrl/api/6365/getRequestHistory';
//  general settings
const postvalidityRoute = '$baseUrl/api/6364/postGeneralSettings';
const getvalidityRoute = '$baseUrl/api/6364/getGeneralSettings';
// po
const getPoRoute = '$baseUrl/api/6365/getPurchaseOrderListbySingleRow';
// edit order
const orderCancelRoute = '$baseUrl/api/6365/OrderCancel';
// orderid
// edit no
// header
Future<String?> getToken() async {
  TokenManager tokenObj = TokenManager();
  var _accessToken = await tokenObj.getAccessToken();
  var bearerToken = "Bearer " + "${_accessToken}";
  log("token: ${bearerToken}");
  return _accessToken;
}
