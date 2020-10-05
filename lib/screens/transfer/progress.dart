part of 'transfer.dart';

class ProgressView extends StatelessWidget {
  final WebBloc web;

  const ProgressView({this.web});

  @override
  Widget build(BuildContext context) {
    // Yield Decline Result
    return BlocBuilder<DataBloc, DataState>(
        // Set Build Requirements
        buildWhen: (prev, curr) {
      if (curr is Updating) {
        return false;
      }
      return true;
    }, builder: (context, state) {
      return Column(children: [
        NeumorphicProgressIndeterminate(),
        Divider(),
      ]);
    });
  }
}
