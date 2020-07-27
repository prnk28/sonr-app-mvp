/*
  Pradyumn Nukala 7/20/2020
  Utility Class created to take file extension and turn it into Enum Type.
  Information from article: https://www.computerhope.com/issues/ch001789.htm 
*/
import 'package:sonar_app/data/data.dart';

// *********************
// ** File Type Enum ***
// *********************
enum FileType {
  Audio,
  Compressed,
  Disc,
  Data,
  Email,
  Executable,
  Font,
  Image,
  Internet,
  Presentation,
  Programming,
  Spreadsheet,
  System,
  Unknown,
  Video,
  Word
}

// ***************************
// ** Asset Directory Enum ***
// ***************************
enum AssetDirectory {
  Animations,
  Audio,
  Fonts,
  RootImages,
  HeaderImages,
  SocialImages
}

// *********************************
// ** Get File Type by Extension ***
// *********************************
FileType getFileTypeFromPath(path) {
  // Get File Extension
  var kind = extension(path);

  // Audio
  if (kind == ".aif" ||
      kind == ".cda" ||
      kind == ".mid" ||
      kind == ".midi" ||
      kind == ".mp3" ||
      kind == ".mpa" ||
      kind == ".ogg" ||
      kind == ".wav" ||
      kind == ".wma" ||
      kind == ".wpl") {
    return FileType.Audio;
  }

  // Compressed
  else if (kind == ".7z" ||
      kind == ".arj" ||
      kind == ".deb" ||
      kind == ".pkg" ||
      kind == ".rar" ||
      kind == ".rpm" ||
      kind == ".tar.gz" ||
      kind == ".z" ||
      kind == ".zip") {
    return FileType.Compressed;
  }

  // Disc
  else if (kind == ".bin" ||
      kind == ".dmg" ||
      kind == ".iso" ||
      kind == ".toast" ||
      kind == ".vcd") {
    return FileType.Disc;
  }

  // Data
  else if (kind == ".csv" ||
      kind == ".dat" ||
      kind == ".db" ||
      kind == ".dbf" ||
      kind == ".log" ||
      kind == ".mdb" ||
      kind == ".sav" ||
      kind == ".sql" ||
      kind == ".tar" ||
      kind == ".xml") {
    return FileType.Data;
  }

  // Email
  else if (kind == ".email" ||
      kind == ".eml" ||
      kind == ".emlx" ||
      kind == ".msg" ||
      kind == ".oft" ||
      kind == ".ost" ||
      kind == ".pst" ||
      kind == ".vcf") {
    return FileType.Email;
  }

  // Executable
  else if (kind == ".apk" ||
      kind == ".bat" ||
      kind == ".bin" ||
      kind == ".cgi" ||
      kind == ".pl" ||
      kind == ".com" ||
      kind == ".exe" ||
      kind == ".gadget" ||
      kind == ".jar" ||
      kind == ".msi" ||
      kind == ".py" ||
      kind == ".wsf") {
    return FileType.Executable;
  }

  // Font
  else if (kind == ".fnt" ||
      kind == ".fon" ||
      kind == ".otf" ||
      kind == ".ttf") {
    return FileType.Font;
  }

  // Image
  else if (kind == ".ai" ||
      kind == ".bmp" ||
      kind == ".gif" ||
      kind == ".ico" ||
      kind == ".jpeg" ||
      kind == ".jpg" ||
      kind == ".png" ||
      kind == ".ps" ||
      kind == ".psd" ||
      kind == ".svg" ||
      kind == ".tif" ||
      kind == ".tiff") {
    return FileType.Image;
  }

  // Internet
  else if (kind == ".asp" ||
      kind == ".aspx" ||
      kind == ".cer" ||
      kind == ".cfm" ||
      kind == ".cgi" ||
      kind == ".pl" ||
      kind == ".css" ||
      kind == ".htm" ||
      kind == ".html" ||
      kind == ".js" ||
      kind == ".jsp" ||
      kind == ".part" ||
      kind == ".php" ||
      kind == ".py" ||
      kind == ".rss" ||
      kind == ".xhtml") {
    return FileType.Internet;
  }

  // Presentation
  else if (kind == ".key" ||
      kind == ".odp" ||
      kind == ".pps" ||
      kind == ".ppt" ||
      kind == ".pptx") {
    return FileType.Presentation;
  }

  // Programming
  else if (kind == ".c" ||
      kind == ".class" ||
      kind == ".cpp" ||
      kind == ".cs" ||
      kind == ".dart" ||
      kind == ".h" ||
      kind == ".java" ||
      kind == ".pl" ||
      kind == ".sh" ||
      kind == ".swift" ||
      kind == ".vb") {
    return FileType.Programming;
  }

  // Spreadsheet
  else if (kind == ".ods" ||
      kind == ".xls" ||
      kind == ".xlsm" ||
      kind == ".xlsx") {
    return FileType.Spreadsheet;
  }

  // System
  else if (kind == ".bak" ||
      kind == ".cab" ||
      kind == ".cfg" ||
      kind == ".cpl" ||
      kind == ".cur" ||
      kind == ".dll" ||
      kind == ".dmp" ||
      kind == ".drv" ||
      kind == ".icns" ||
      kind == ".ico" ||
      kind == ".ini" ||
      kind == ".lnk" ||
      kind == ".msi" ||
      kind == ".sys" ||
      kind == ".tmp") {
    return FileType.System;
  }

  // Video
  else if (kind == ".3g2" ||
      kind == ".3gp" ||
      kind == ".avi" ||
      kind == ".flv" ||
      kind == ".h264" ||
      kind == ".m4v" ||
      kind == ".mkv" ||
      kind == ".mov" ||
      kind == ".mp4" ||
      kind == ".mpg" ||
      kind == ".mpeg" ||
      kind == ".rm" ||
      kind == ".swf" ||
      kind == ".vob" ||
      kind == ".wmv") {
    return FileType.Video;
  }

  // Word
  else if (kind == ".doc" ||
      kind == ".docx" ||
      kind == ".odt" ||
      kind == ".pdf" ||
      kind == ".rtf" ||
      kind == ".tex" ||
      kind == ".txt" ||
      kind == ".wpd") {
    return FileType.Word;
  }

  // Unknown
  else {
    return FileType.Unknown;
  }
}
