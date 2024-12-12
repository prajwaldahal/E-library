import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../providers/pdf_provider.dart';

class PDFViewerPage extends StatelessWidget {
  const PDFViewerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final pdfProvider = Provider.of<PDFProvider>(context, listen: false);
    final File? file = pdfProvider.secureFile;

    return Scaffold(
      body: file != null
          ? SfPdfViewer.file(
              file,
              canShowScrollHead: false,
              canShowScrollStatus: false,
              enableDoubleTapZooming: true,
            )
          : const Center(
              child: Text('Failed to load PDF'),
            ),
    );
  }
}
