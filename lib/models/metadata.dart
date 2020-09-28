import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

@HiveType()
class Metadata extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  int size;

  @HiveField(3)
  String type;

  @HiveField(4)
  String path;

  @HiveField(5)
  Map sender;

  @HiveField(6)
  DateTime received;

  @HiveField(7)
  DateTime lastOpened;

  Metadata() {
    // Set Id
    var uuid = Uuid();
    id = uuid.v1();
  }
}

class MetadataAdapter extends TypeAdapter<Metadata> {
  @override
  final typeId = 1;

  @override
  Metadata read(BinaryReader reader) {
    return Metadata()..id = reader.read();
  }

  @override
  void write(BinaryWriter writer, Metadata obj) {
    writer.write(obj.id);
  }
}
