import 'package:pinext/app/API/model/ip_location_data.dart';
import 'package:pinext/app/API/service/api_service.dart';

class ApiRepo {
  final ApiService _apiService = ApiService();

  Future<IpLocationData> getIpLocationData() async {
    final userIpAddress = await getUserIPAddress();
    if (userIpAddress == null) {
      return _returnDefaultIpData();
    }
    final response = await _apiService.getGetResponse('https://api.iplocation.net/?ip=$userIpAddress');
    if (response['response_code'] == '200') {
      return IpLocationData.fromMap(response as Map<String, dynamic>);
    } else {
      return _returnDefaultIpData();
    }
  }

  IpLocationData _returnDefaultIpData() {
    return IpLocationData.fromMap({
      'ip': '182.160.102.225',
      'ip_number': '3063965409',
      'ip_version': 4,
      'country_name': 'Bangladesh',
      'country_code2': 'BD',
      'isp': 'Assigned for Safura POP Customers',
      'response_code': '200',
      'response_message': 'OK',
    });
  }

  Future<String?> getUserIPAddress() async {
    try {
      final res = await _apiService.getGetResponse('https://icanhazip.com/');

      /// Need to substring res, cause the ip contains an end line.
      return res.toString().substring(0, res.toString().length - 1);
    } catch (err) {
      return null;
    }
  }
}
