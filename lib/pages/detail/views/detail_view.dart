import 'dart:io';
import 'package:sonr_app/style.dart';

class DetailView {
  static Widget contact() {
    return DetailContactView();
  }

  static Widget file() {
    return DetailFileView();
  }

  static Widget media(SonrFile_Item item, {File? file}) {
    return DetailMediaView(item: item, file: file);
  }

  static Widget url() {
    return DetailUrlView();
  }
}

class DetailContactView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class DetailFileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class DetailMediaView extends StatelessWidget {
  final SonrFile_Item item;
  final File? file;

  const DetailMediaView({Key? key, required this.item, this.file}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width,
      child: Hero(
        tag: item.path,
        child: Material(
          color: Colors.transparent,
          child: InteractiveViewer(child: file != null ? Image.file(file!) : Image.file(File(item.path))),
        ),
      ),
    );
  }
}

class DetailUrlView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
