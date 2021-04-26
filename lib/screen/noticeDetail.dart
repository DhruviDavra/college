import 'package:college_management_system/objects/noticeObject.dart';
import 'package:college_management_system/providers/noticeProvider.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NoticeDetail extends StatefulWidget {
  @override
  _NoticeDetailState createState() => _NoticeDetailState();
}

class _NoticeDetailState extends State<NoticeDetail> {
  void navigateToPage(BuildContext context) async {
    Navigator.of(context)
        .pop();
  }

  bool _isLoading = false;
  NoticeObject noticeObject = NoticeObject();
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

    noticeObject =
        Provider.of<NoticeProvider>(context, listen: false).particularNotice;
    await _loadFromUrl(noticeObject.spath);
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
            title: Text(noticeObject.docname),
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
