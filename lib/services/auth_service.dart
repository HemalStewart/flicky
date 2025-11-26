import '../data/auth_api.dart';
import '../data/auth_repository.dart';
import '../data/local_storage.dart';

class AuthService {
  AuthService._internal()
      : _storage = LocalStorage(),
        _api = AuthApi();

  static final AuthService instance = AuthService._internal();

  final LocalStorage _storage;
  final AuthApi _api;
  late final AuthRepository _repository =
      AuthRepository(api: _api, storage: _storage);

  Future<bool> hasActiveSession() => _repository.hasActiveSession();

  Future<OtpRequestResult> requestOtp(String mobile) async {
    return _repository.requestOtp(mobile);
  }

  Future<OtpVerifyResult> verifyOtp({
    required String mobile,
    required String otp,
  }) async {
    return _repository.verifyOtp(mobile: mobile, otp: otp);
  }

  Future<String?> getSavedMobile() => _repository.getSavedMobile();

  Future<void> logout() => _repository.logout();

  Future<void> unsubscribe() => _repository.unsubscribe();
}
