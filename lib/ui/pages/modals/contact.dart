part of 'invite.dart';

class ContactInviteView extends StatelessWidget {
  final Contact contact;

  const ContactInviteView(this.contact, {Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // Build View
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Padding(padding: EdgeInsets.all(8)),
      Column(
        children: [
          Text(contact.firstName, style: mediumTextStyle()),
          Text(contact.lastName, style: mediumTextStyle())
        ],
      ),
    ]); // FlatButton// Container
  }
}
