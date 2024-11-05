import 'package:connectivity_plus/connectivity_plus.dart';
import 'databasehelper.dart';
import 'contactinfomodel.dart';
import 'package:http/http.dart' as htpp;

class SyncronizationData {
static Future<bool> isInternet() async {
  // var connectivityResult = await (Connectivity().checkConnectivity());
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

  final conn = SqfliteDatabaseHelper.instance;

  Future<List<ContactinfoModel>> fetchAllInfo() async {
    final dbClient = await conn.db;
    List<ContactinfoModel> contactList = [];
    try {
      final maps = await dbClient.query(SqfliteDatabaseHelper.contactinfoTable);
      for (var item in maps) {
        contactList.add(ContactinfoModel.fromJson(item));
      }
    } catch (e) {
      print(e.toString());
    }
    return contactList;
  }

  Future saveToMysqlWith(List<ContactinfoModel> contactList) async {
    for (var i = 0; i < contactList.length; i++) {
      Map<String, dynamic> data = {
        "contact_id": contactList[i].id.toString(),
        "user_id": contactList[i].userId.toString(),
        "name": contactList[i].name,
        "email": contactList[i].email,
        "gender": contactList[i].gender,
        "created_at": contactList[i].createdAt,
      };
      final response = await htpp.post(
          'https://pro.lpkbegawan.com/load_from_sqflite.php' as Uri,
          body: data);
      if (response.statusCode == 200) {
        print("Saving Data ");
      } else {
        print(response.statusCode);
      }
    }
  }

  Future<List> fetchAllCustoemrInfo() async {
    final dbClient = await conn.db;
    List contactList = [];
    try {
      final maps = await dbClient.query(SqfliteDatabaseHelper.contactinfoTable);
      for (var item in maps) {
        contactList.add(item);
      }
    } catch (e) {
      print(e.toString());
    }
    return contactList;
  }

  Future saveToMysql(List contactList) async {
    for (var i = 0; i < contactList.length; i++) {
      Map<String, dynamic> data = {
        "contact_id": contactList[i]['id'].toString(),
        "user_id": contactList[i]['user_id'].toString(),
        "name": contactList[i]['name'],
        "email": contactList[i]['email'],
        "gender": contactList[i]['gender'],
        "created_at": contactList[i]['created_at'],
      };
      final response = await htpp.post(
          'https://pro.lpkbegawan.com/load_from_sqflite.php' as Uri,
          body: data);
      if (response.statusCode == 200) {
        print("Saving Data ");
      } else {
        print(response.statusCode);
      }
    }
  }
}
