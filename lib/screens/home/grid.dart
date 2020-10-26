part of 'home.dart';

class FileGrid extends StatelessWidget {
  // References
  final List<Metadata> files;
  FileGrid(this.files);

  // Build Widget
  @override
  Widget build(BuildContext context) {
    return ListView(
        padding: const EdgeInsets.all(8),
        children: _buildMetadataListCells(context));
  }

  _buildMetadataListCells(BuildContext context) {
    // Initialize
    List<Widget> cells = new List<Widget>();

    // Iterate Through Files
    files.forEach((metadata) {
      // Generate Cell
      var cell = new FileCard(metadata);

      // Add Cell to List
      cells.add(cell);
    });

    // Return Cells
    return cells;
  }
}
