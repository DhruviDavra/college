import 'package:college_management_system/objects/syllabusObject.dart';
import 'package:college_management_system/providers/syllabusProvider.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SyllabusDetail extends StatefulWidget {
  @override
  _SyllabusDetailState createState() => _SyllabusDetailState();
}

class _SyllabusDetailState extends State<SyllabusDetail> {
  void navigateToPage(BuildContext context) async {
    Navigator.of(context)
        .pop();
  }

  bool _isLoading = false;
  SyllabusObject syllabusObject = SyllabusObject();
  PDFDocument doc;

  Future _loadFromUrl(String url) async {
    doc = await PDFDocument.fromURL(url);
  }

  @override
  void initState() {
    super.initState();

    getData();
  }

  getData() async {
    if (mounted)
      setState(() {
        _isLoading = true;
      });

    syllabusObject =
        Provider.of<SyllabusProvider>(context, listen: false).particularSyllabus;
    await _loadFromUrl(syllabusObject.path);
    if (mounted)
      setState(() {
        _isLoading = false;
      });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
          backgroundColor: Colors.blueGrey[50],
          appBar: AppBar(
            title: Text(syllabusObject.title),
            backgroundColor: Colors.blueGrey[700],
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                navigateToPage(context);
              },
            ),
          ),
          body: _isLoading
              ? Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.4,
                    ),
                    SpinKitChasingDots(
                      color: Colors.blueGrey,
                    ),
                  ],
                )
              : PDFViewer(
                  document: doc,
                ),
        ),
      ),
    );
  }
}
