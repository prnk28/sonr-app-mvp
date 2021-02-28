import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:metadata_fetch/metadata_fetch.dart';
import 'api_primitive.dart';

class URLData {
  String title;
  String description;
  String image;
  String url;
  String host;
  String path;

  // ^ URLData Constructer ^ //
  URLData(Metadata data) {
    print(data);
    // Initialize Data
    title = data.title;
    description = data.description;
    image = data.image;
    url = data.url;

    // Parse URL
    Uri uri = Uri.parse(url);
    int segmentCount = uri.pathSegments.length;
    host = uri.host;
    path = "/";

    // Check host for Sub
    if (host.contains("mobile")) {
      host = host.substring(5);
      host.replaceAt(0, "m");
    }

    // Create Path
    int directories = 0;
    for (int i = 0; i <= segmentCount - 1; i++) {
      // Check if final Segment
      if (i == segmentCount - 1) {
        directories > 0 ? path += path += "/${uri.pathSegments[i]}" : path += uri.pathSegments[i];
      } else {
        directories += 1;
        path += ".";
      }
    }
  }

  // ^ Method Returns Text Span for URL Text ^ //
  List<TextSpan> get displayText {
    return [
      TextSpan(
          text: host,
          style: GoogleFonts.poppins(
              decoration: TextDecoration.underline,
              decorationStyle: TextDecorationStyle.dotted,
              fontWeight: FontWeight.w300,
              fontSize: 16,
              fontStyle: FontStyle.italic,
              color: Colors.blueGrey[300])),
      TextSpan(
          text: path,
          style: GoogleFonts.poppins(
              decoration: TextDecoration.underline,
              decorationStyle: TextDecorationStyle.dotted,
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Colors.blue[600]))
    ];
  }
}
