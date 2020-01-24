import 'package:sonar_app/data/data.dart';
import 'package:meta/meta.dart';

class SonarRepository {
  final SonarClient sonarClient;

  // Constructer
  SonarRepository({@required this.sonarClient})
      : assert(sonarClient != null);
}