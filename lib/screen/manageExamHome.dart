import 'package:flutter/material.dart';
import 'itemModel.dart';
import 'manageInternalExam.dart';
import 'package:provider/provider.dart';
import 'package:college_management_system/providers/examProvider.dart';

class ExamHome extends StatefulWidget {
  @override
  _ExamHomeState createState() => _ExamHomeState();
}

class _ExamHomeState extends State<ExamHome> {
  void navigateToPage(BuildContext context) async {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[700],
        title: Text('Select Semester'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            navigateToPage(context);
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: ListView.builder(
          itemCount: prepareData.length,
          itemBuilder: (BuildContext context, int index) {
            return ExpansionPanelList(
              animationDuration: Duration(seconds: 1),
              children: [
                ExpansionPanel(
                  body: Container(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            color: Colors.blueGrey[500],
                            onPressed: () {
                              Provider.of<ExamProvider>(context, listen: false)
                                  .sem = prepareData[index].header;
                              Provider.of<ExamProvider>(context, listen: false)
                                  .etype = "Internal";
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Internal()));
                            },
                            child: Text(
                              'Internal',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            color: Colors.blueGrey[500],
                            onPressed: () {
                              Provider.of<ExamProvider>(context, listen: false)
                                  .sem = prepareData[index].header;

                              Provider.of<ExamProvider>(context, listen: false)
                                  .etype = "External";
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Internal()));
                            },
                            child: Text(
                              'External',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        prepareData[index].header + " Semester",
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 18,
                        ),
                      ),
                    );
                  },
                  isExpanded: prepareData[index].isExpanded,
                )
              ],
              expansionCallback: (int item, bool status) {
                setState(() {
                  prepareData[index].isExpanded =
                      !prepareData[index].isExpanded;
                });
              },
            );
          },
        ),
      ),
    );
  }

  List<ItemModel> prepareData = <ItemModel>[
    ItemModel(
      header: 'First',
    ),
    ItemModel(
      header: 'Second',
    ),
    ItemModel(
      header: 'Third',
    ),
    ItemModel(
      header: 'Fourth',
    ),
    ItemModel(
      header: 'Fifth',
    ),
    ItemModel(
      header: 'Sixth',
    ),
  ];
}
