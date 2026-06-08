import 'package:flutter_test/flutter_test.dart';
import 'package:sentra_mobile/core/config/app_environment.dart';

void main() {
  test('environment uses production defaults', () {
    final environment = AppEnvironment.fromDefines();

    expect(environment.baseUrl, 'https://sentra.airforce.lk');
    expect(environment.flavor, AppFlavor.production);
  });
}
