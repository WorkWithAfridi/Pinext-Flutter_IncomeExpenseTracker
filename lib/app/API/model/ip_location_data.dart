import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class IpLocationData {
  String? ip;
  String? ip_number;
  String? ip_version;
  String? country_name;
  String? country_code2;
  String? isp;
  String? response_code;
  String? response_message;
  IpLocationData({
    this.ip,
    this.ip_number,
    this.ip_version,
    this.country_name,
    this.country_code2,
    this.isp,
    this.response_code,
    this.response_message,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'ip': ip,
      'ip_number': ip_number,
      'ip_version': ip_version,
      'country_name': country_name,
      'country_code2': country_code2,
      'isp': isp,
      'response_code': response_code,
      'response_message': response_message,
    };
  }

  factory IpLocationData.fromMap(Map<String, dynamic> map) {
    return IpLocationData(
      ip: map['ip'] != null ? map['ip'].toString() : null,
      ip_number: map['ip_number'] != null ? map['ip_number'].toString() : null,
      ip_version: map['ip_version'] != null ? map['ip_version'].toString() : null,
      country_name: map['country_name'] != null ? map['country_name'].toString() : null,
      country_code2: map['country_code2'] != null ? map['country_code2'].toString() : null,
      isp: map['isp'] != null ? map['isp'].toString() : null,
      response_code: map['response_code'] != null ? map['response_code'].toString() : null,
      response_message: map['response_message'] != null ? map['response_message'].toString() : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory IpLocationData.fromJson(String source) => IpLocationData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'IpLocationData(ip: $ip, ip_number: $ip_number, ip_version: $ip_version, country_name: $country_name, country_code2: $country_code2, isp: $isp, response_code: $response_code, response_message: $response_message)';
  }
}
