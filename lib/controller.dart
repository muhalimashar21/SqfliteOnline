import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:sqflitetoonline/contactinfomodel.dart';
import 'databasehelper.dart';

class Controller {
  final conn = SqfliteDatabaseHelper.instance;

  static Future<bool> isInternet() async {
    final List<ConnectivityResult> connectivityResult =
        await (Connectivity().checkConnectivity());

    // This condition is for demo purposes only to explain every connection type.
    // Use conditions which work for your requirements.
    if (connectivityResult == ConnectivityResult.mobile) {
      // Mobile network available.
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // Wi-fi is available.
      // Note for Android:
      // When both mobile and Wi-Fi are turned on system will return Wi-Fi only as active network type
      return true;
    } else if (connectivityResult == ConnectivityResult.ethernet) {
      // Ethernet connection available.
      return true;
    } else if (connectivityResult == ConnectivityResult.vpn) {
      // Vpn connection active.
      // Note for iOS and macOS:
      // There is no separate network interface type for [vpn].
      // It returns [other] on any device (also simulator)
      return true;
    } else if (connectivityResult == ConnectivityResult.bluetooth) {
      // Bluetooth connection available.
      return true;
    } else if (connectivityResult == ConnectivityResult.other) {
      // Connected to a network which is not in the above mentioned networks.
      return true;
    } else if (connectivityResult == ConnectivityResult.none) {
      // No available network types
      return false;
    }
    return false;
  }

  Future<int> addData(ContactinfoModel contactinfoModel) async {
    var dbclient = await conn.db;
    int result = 0;
    try {
      result = await dbclient.insert(
          SqfliteDatabaseHelper.contactinfoTable, contactinfoModel.toJson());
    } catch (e) {
      print(e.toString());
    }
    return result;
  }

  Future<int> updateData(ContactinfoModel contactinfoModel) async {
    var dbclient = await conn.db;
    int result = 0;
    try {
      result = await dbclient.update(
          SqfliteDatabaseHelper.contactinfoTable, contactinfoModel.toJson(),
          where: 'id=?', whereArgs: [contactinfoModel.id]);
    } catch (e) {
      print(e.toString());
    }
    return result;
  }

  Future fetchData() async {
    var dbclient = await conn.db;
    List userList = [];
    try {
      List<Map<String, dynamic>> maps = await dbclient
          .query(SqfliteDatabaseHelper.contactinfoTable, orderBy: 'id DESC');
      for (var item in maps) {
        userList.add(item);
      }
    } catch (e) {
      print(e.toString());
    }
    return userList;
  }
}
