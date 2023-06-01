import 'dart:io';

import 'package:pinext/app/API/service/api_service.dart';

class ApiRepo {
  final ApiService _apiService = ApiService();

  // Future<IpLocationData> getIpLocationData() async {
  //   final userIpAddress = await getUserIPAddress();
  //   if (userIpAddress == null) {
  //     return _returnDefaultIpData();
  //   }
  //   log(userIpAddress);
  //   final response = await _apiService.getGetResponse('https://api.iplocation.net/?ip=$userIpAddress');
  //   if (response['response_code'] == '200') {
  //     return IpLocationData.fromMap(response as Map<String, dynamic>);
  //   } else {
  //     return _returnDefaultIpData();
  //   }
  // }

  // IpLocationData _returnDefaultIpData() {
  //   return IpLocationData.fromMap({
  //     'ip': '182.160.102.225',
  //     'ip_number': '3063965409',
  //     'ip_version': 4,
  //     'country_name': 'Bangladesh',
  //     'country_code2': 'BD',
  //     'isp': 'Assigned for Safura POP Customers',
  //     'response_code': '200',
  //     'response_message': 'OK'
  //   });
  // }

// prints local ip
  Future printIps() async {
    for (final interface in await NetworkInterface.list()) {
      print('== Interface: ${interface.name} ==');
      for (final addr in interface.addresses) {
        print(
          '${addr.address} ${addr.host} ${addr.isLoopback} ${addr.rawAddress} ${addr.type.name}',
        );
      }
    }
  }

  // Future<String?> getUserIPAddress() async {
  //   // try {
  //   final response = await _apiService.getGetResponse('https://httpbin.org/ip');
  //   final data = response.data as Map<String, dynamic>;
  //   final ipAddress = data['origin'] as String;

  //   return ipAddress;
  //   // } catch (e) {
  //   //   return null;
  //   // }
  // }
}
