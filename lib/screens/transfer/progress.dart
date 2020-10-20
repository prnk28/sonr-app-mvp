part of 'transfer.dart';

class ProgressView extends StatelessWidget {
  final WebBloc web;

  const ProgressView({this.web});

  @override
  Widget build(BuildContext context) {
    // Yield Decline Result
    return BlocBuilder<ProgressCubit, double>(
        // Set Build Requirements
        buildWhen: (prev, curr) {
          return true;
        },
        cubit: context.getCubit(CubitType.Progress),
        builder: (context, state) {
          return Column(children: [
            NeumorphicProgress(percent: state),
            Divider(),
          ]);
        });
  }
}
