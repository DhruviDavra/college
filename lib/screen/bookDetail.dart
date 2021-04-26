import 'package:college_management_system/objects/bookObject.dart';
import 'package:college_management_system/providers/bookProvider.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookDetail extends StatefulWidget {
  @override
  _BookDetailState createState() => _BookDetailState();
}

class _BookDetailState extends State<BookDetail> {
  void navigateToPage(BuildContext context) async {
    Navigator.of(context)
        .pop();
  }

  bool _isLoading = false;
  BookObject bookObject = BookObject();
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

    bookObject =
        Provider.of<BookProvider>(context, listen: false).particularBook;
    await _loadFromUrl(bookObject.path);
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
            centerTitle: true,
            title: Text(bookObject.title),
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
