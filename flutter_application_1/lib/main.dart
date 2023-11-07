import 'bootstrap.dart';
import 'services/services.dart';

void main() {
  bootstrap(Flavor.prod, APIProvider.polygon);
}
