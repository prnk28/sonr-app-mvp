import 'dart:io';
import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart';
import 'package:sonr_app/pages/transfer/transfer_controller.dart';
import 'package:sonr_app/theme/theme.dart';

/// Converts file to Thumbnail off Main Thread and Loads to Invite Request
class Thumbnail extends StatefulWidget {
  final Size size;
  final File image;

  const Thumbnail({Key key, this.size, this.image}) : super(key: key);
  @override
  _ThumbnailState createState() => _ThumbnailState();
}

class _ThumbnailState extends State<Thumbnail> {
  List<int> imgBytes;
  Isolate isolate;

  @override
  void initState() {
    _asyncInit();

    super.initState();
  }

  static _isolateEntry(dynamic d) async {
    final ReceivePort receivePort = ReceivePort();
    d.send(receivePort.sendPort);

    final config = await receivePort.first;

    print(config);

    final file = File(config['path']);
    final bytes = await file.readAsBytes();

    img.Image image = img.decodeImage(bytes);
    img.Image thumbnail = img.copyResize(
      image,
      width: config['size'].width.toInt(),
    );

    d.send(img.encodeNamedImage(thumbnail, basename(config['path'])));
  }

  _asyncInit() async {
    final ReceivePort receivePort = ReceivePort();
    isolate = await Isolate.spawn(_isolateEntry, receivePort.sendPort);

    receivePort.listen((dynamic data) {
      if (data is SendPort) {
        if (mounted) {
          data.send({
            'path': widget.image.path,
            'size': widget.size,
          });
        }
      } else {
        if (mounted) {
          setState(() {
            imgBytes = data;
            Get.find<TransferController>().setThumbnail(data);
          });
        }
      }
    });
  }

  @override
  void dispose() {
    if (isolate != null) {
      isolate.kill();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.size.height,
      width: widget.size.width,
      child: imgBytes != null
          ? Image.memory(
              imgBytes,
              fit: BoxFit.cover,
            )
          : Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.grey[100], Colors.grey[300]],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
    );
  }
}
