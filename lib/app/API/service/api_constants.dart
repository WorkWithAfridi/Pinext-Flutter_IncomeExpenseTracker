class ApiConstants {
  static const String testResult = '$baseUrl/api/patient/testResult';
  static const String baseUrl = 'http://16.171.46.37:5000';
  static const String imageBaseUrl = 'https://beh-app.s3.eu-north-1.amazonaws.com/';
  static const String patientPromos = '$baseUrl/api/patient/promo/getPromos';
  static const String applyPromoCode = '$baseUrl/api/patient/promo/applyPromo';
  static const String patientDoctorFavorites = '$baseUrl/api/patient/doctor/favorites';
  static const String patientDoctorAddToFavorite = '$baseUrl/api/patient/doctor/addToFavorite/';
  static const String patientDoctorRemoveToFavorite = '$baseUrl/api/patient/doctor/removeFromFavorite/';
  static const String patientDoctor = '$baseUrl/api/patient/doctor';
  static const String patientPrescription = '$baseUrl/api/patient/prescription';
  static const String deletePatientPrescription = '$baseUrl/api/patient/prescription/delete/';
  static const String profileMe = '$baseUrl/api/patient/profile/me';
  static const String clinicalTestResult = '$baseUrl/api/patient/testResult/clinical';
  static const String appTestResult = '$baseUrl/api/patient/testResult/app';
  static const String profileUpdate = '$baseUrl/api/patient/profile/update';
  static const String patientPrescriptionUpload = '$baseUrl/api/patient/prescription/upload';
  static const String patientClinicalResultUpload = '$baseUrl/api/patient/testResult';
  static const String deleteTestResult = '$baseUrl/api/patient/testResult';
  static const String homeBanners = '$baseUrl/api/common/banners';
  static const String specialtiesList = '$baseUrl/api/common/specialties';
  static const String transactionsList = '$baseUrl/api/doctor/wallet/transactions';
  static const String walletStatistics = '$baseUrl/api/doctor/wallet/statistics';
  static const String paymentAccount = '$baseUrl/api/doctor/paymentAccount';
  static const String submitWithdraw = '$baseUrl/api/doctor/wallet/submitWithdraw';
}
