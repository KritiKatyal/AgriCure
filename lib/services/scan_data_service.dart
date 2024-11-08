// scan_data_service.dart
class ScanDataService {
  static final ScanDataService _instance = ScanDataService._internal();
  
  // Singleton pattern
  factory ScanDataService() {
    return _instance;
  }

  ScanDataService._internal();

  // Shared scan data
  Map<String, dynamic>? latestScanData;

  void updateScanData(Map<String, dynamic> scanData) {
    latestScanData = scanData;
  }

  Map<String, dynamic>? getScanData() {
    return latestScanData;
  }
}