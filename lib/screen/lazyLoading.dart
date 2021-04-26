import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    getDocuments();
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels == 0)
          print('ListView scroll at top');
        else {
          print('ListView scroll at bottom');
          getDocumentsNext(); // Load next documents
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: listDocument.length != 0
            ? RefreshIndicator(
                child: ListView.builder(
                  physics: AlwaysScrollableScrollPhysics(),
                  controller: scrollController,
                  itemCount: listDocument.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text('${listDocument[index].documentName}'),
                    );
                  },
                ),
                onRefresh: getDocuments, // Refresh entire list
              )
            : CircularProgressIndicator(),
      ),
    );
  }

  List<DocObj> listDocument;
  QuerySnapshot collectionState;
  // Fetch first 15 documents
  Future<void> getDocuments() async {
    listDocument = List();
    var collection = FirebaseFirestore.instance
        .collection('tbl_student')
        .orderBy("rno")
        .limit(15);
    print('getDocuments');
    fetchDocuments(collection);
  }

  // Fetch next 5 documents starting from the last document fetched earlier
  Future<void> getDocumentsNext() async {
    // Get the last visible document
    var lastVisible = collectionState.docs[collectionState.docs.length-1] ;
    print('listDocument legnth: ${collectionState.size} last: $lastVisible');

    var collection = FirebaseFirestore.instance
        .collection('tbl_student')
        .orderBy("rno").startAfterDocument(lastVisible).limit(5);

    fetchDocuments(collection);
  }

  fetchDocuments(Query collection){
    collection.get().then((value) {
      collectionState = value; // store collection state to set where to start next
      value.docs.forEach((element) {
        print('getDocuments ${element.data()}');
        setState(() {
          listDocument.add(DocObj(DocObj.setDocDetails(element.data())));
        });
      });
    });
  }

}
class DocObj {
  var documentName;

  DocObj(DocObj doc) {
    this.documentName = doc.getDocName();
  }

  dynamic getDocName() => documentName;

  DocObj.setDocDetails(Map<dynamic, dynamic> doc)
      : documentName = doc['name'];
}