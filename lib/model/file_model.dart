// ^ OpenFilesError couldnt open DB at path ^
class OpenFilesError extends Error {
  final String message;
  OpenFilesError(this.message);
}
