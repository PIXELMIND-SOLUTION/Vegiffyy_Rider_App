// lib/services/api_constant.dart
class ApiConstant {
  // put your real base url here
  static const String baseUrl = 'http://31.97.206.144:5051';
    static String location(String userId) => '$baseUrl/api/delivery-boy/location/$userId';
}
