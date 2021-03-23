import 'package:flutter/material.dart';
import 'homeScreen.dart';

class AdminLeave extends StatefulWidget {
  @override
  _AdminLeaveState createState() => _AdminLeaveState();
}

class _AdminLeaveState extends State<AdminLeave> {
  bool _isLoading = false;

  void navigateToPage(BuildContext context) async {
    Navigator.of(context)
        .pop(MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  bool showfab = true;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blueGrey[700],
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                navigateToPage(context);
              },
            ),
            title: Text('Leaves'),
          ),
          body: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.all(20),
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.75,
                    child: _isLoading
                        ? CircularProgressIndicator()
                        : ListView.builder(
                            scrollDirection: Axis.vertical,
                            //  itemCount: catagorylist.length,

                            itemBuilder: (context, i) => Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                child: Row(
                                  children: [
                                    Text("ABC"),
                                    Text("\nxyz"),
                                    Spacer(),
                                    InkWell(
                                      onTap: () {},
                                      child: Image.asset(
                                        'assets/images/right.JPG',
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.04,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {},
                                      child: Image.asset(
                                        'assets/images/wrong.JPG',
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.04,
                                      ),
                                      onLongPress: (){Tooltip(message: 'delete');},
                                    ),

                                  ],
                                ),
                                height:
                                    MediaQuery.of(context).size.height * 0.07,
                                width: MediaQuery.of(context).size.width * 0.01,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey,
                                      offset: Offset(0.0, 1.0), //(x,y)
                                      blurRadius: 6.0,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.blueGrey,
            child: Icon(Icons.add),
            onPressed: () {},
            // onPressed: () => _startAddNewTransaction(context),
          ),
        ),
      ),
    );
  }
}