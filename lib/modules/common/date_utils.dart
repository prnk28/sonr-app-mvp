import 'package:intl/intl.dart';
import 'package:sonr_app/style.dart';

class DateText extends StatelessWidget {
  final DateTime date;
  final Color? color;
  final double fontSize;
  final FontStyle fontStyle;
  final DisplayTextStyle textStyle;

  factory DateText.fromMilliseconds(
    int date, {
    Color? color,
    double fontSize = 16,
    FontStyle fontStyle = FontStyle.normal,
    DisplayTextStyle textStyle = DisplayTextStyle.Paragraph,
  }) {
    return DateText(
      date: DateTime.fromMillisecondsSinceEpoch(date),
      color: color,
      fontSize: fontSize,
      fontStyle: fontStyle,
      textStyle: textStyle,
    );
  }

  const DateText({
    Key? key,
    required this.date,
    this.color,
    this.fontSize = 16,
    this.fontStyle = FontStyle.normal,
    this.textStyle = DisplayTextStyle.Paragraph,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(
      _buildDateTime(),
      style: textStyle.style(
        color: color,
        fontSize: fontSize,
        fontStyle: fontStyle,
      ),
    );
  }

  String _buildDateTime() {
    final dateFormatter = DateFormat.yMMMd('en_US').add_jm();
    return dateFormatter.format(date);
  }
}

/// Received DateTime Text Widget
class ReceivedText extends StatelessWidget {
  final bool isDateTime;
  final DateTime received;

  /// Create Received Date Time Text with only Date
  factory ReceivedText.date({required DateTime received}) {
    return ReceivedText(isDateTime: false, received: received);
  }

  /// Create Received Date Time Text with Date AND Time
  factory ReceivedText.dateTime({required DateTime received}) {
    return ReceivedText(isDateTime: true, received: received);
  }

  const ReceivedText({Key? key, required this.isDateTime, required this.received}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (isDateTime) {
      // Formatters
      final dateFormat = DateFormat.yMd();
      final timeFormat = DateFormat.jm();

      // Get String
      String dateText = dateFormat.format(this.received);
      String timeText = timeFormat.format(this.received);
      return Row(children: [dateText.paragraph(color: SonrColor.White), timeText.paragraph(color: SonrColor.White)]);
    } else {
      // Formatters
      final dateFormat = DateFormat.yMd();

      // Get String
      return dateFormat.format(this.received).paragraph(color: SonrColor.White);
    }
  }
}
