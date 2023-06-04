abstract class BaseService {
  Future<dynamic> getGetResponse(String url);
  Future<dynamic> getPostResponse(String url, dynamic data);
  Future<dynamic> getPutResponse(String url, dynamic data);
  Future<dynamic> getPatchResponse(String url, dynamic data);
  Future<dynamic> getDeleteResponse(String url);
}
