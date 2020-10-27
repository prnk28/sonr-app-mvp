part of 'window.dart';

Widget buildProgressView(BuildContext context) {
  return BlocBuilder<ProgressCubit, double>(
      cubit: context.getCubit(CubitType.Progress),
      builder: (context, state) {
        // State as Text
        String percent = (state * 100).round().toString();

        // Set Progress Indicator
        return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          NeumorphicProgress(percent: state),
          Divider(),
          Text(percent)
        ]);
      });
}
