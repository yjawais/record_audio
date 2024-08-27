import 'package:flutter_test/flutter_test.dart';
import 'package:pesuvl/services/permission_service.dart';

void main() {
  test('requestMicrophonePermission returns true when granted', () async {
    final permissionService = PermissionService();
    final result = await permissionService.requestMicrophonePermission();
    expect(result, true);
  });
}
