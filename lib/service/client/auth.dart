import 'package:sonr_app/data/model/model_hs.dart';
import 'package:sonr_app/service/api/nb.dart';
import 'package:sonr_app/service/device/device.dart';
import 'package:get/get.dart';

class AuthService extends GetxService {
  final client = NamebaseClient();
  final records = RxList<HSRecord>();
  final prefix = "".obs;
  final fingerprint = "".obs;

  /// Initializes Handshake Service
  Future<AuthService> init() async {
    // Get Records
    var resp = await client.initialize();
    if (resp.success) {
      handleRecords(resp.records);
    }
    return this;
  }

  // @ Handle Records Listed from Response
  void handleRecords(List<HSRecord> data) {
    // Set Records
    records(data);

    // Add Auth Records from All Records
    this.records.forEach((r) async {
      if (r.isAuth) {
        if (await r.checkPrefix("prad", DeviceService.device.id)) {
          print("Same Prefix");
        }
        print(r.toString());
      }
    });
  }
}
