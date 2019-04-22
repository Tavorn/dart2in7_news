import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

//All Articles Mentioning Apple
final String _apiUrl1 = "https://newsapi.org/v2/everything?q=apple&from="
        + currentDate +
            "&to=" + currentDate +
                "&sortBy=popularity&apiKey=e58170db67724ae2a077c9e99332d354";

//Articles about bitcoin from the last month
final String _apiUrl2 = "https://newsapi.org/v2/everything?q=bitcoin&from="
        + currentDate +
            "&sortBy=publishedAt&apiKey=e58170db67724ae2a077c9e99332d354";

//Variables to store the data
List _provider1;
List _provider2;

List _provider;
String _headlines ="Apple News";

var now = DateTime.now();
var formatter = DateFormat("yyyy-MM-dd");
String currentDate = formatter.format(now);

void main() async{
  _provider1 = await fetchData(_apiUrl1);
  _provider2 = await fetchData(_apiUrl2);

  _provider = _provider1;

  for(int i=0; i<_provider.length; i++){
    print(_provider[i]['title']);
  }
  runApp(MaterialApp(
    home: Home(),
    debugShowCheckedModeBanner: false,
  ));
  }

  class Home extends StatefulWidget {
    @override
    _HomeState createState() => _HomeState();
  }
  
  class _HomeState extends State<Home> {
    @override
    Widget build(BuildContext context) {
      return Container(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Image.asset("images/background.jpg", fit: BoxFit.cover,),
            Scaffold(
              drawer: Drawer(
                child: ListView(
                  children: <Widget>[
                    DrawerHeader(
                      child: Text("CHOOSE A NEWS PROVIDER", style: TextStyle(color: Colors.white, fontFamily: "Times New Roman", fontSize: 18.0),),
                      decoration: BoxDecoration(color: Colors.blue),
                    ),
                    ListTile(
                      title: Text("Apple News", style: TextStyle(fontFamily: "Times New Roman", fontSize: 18.0, fontStyle: FontStyle.italic),),
                      subtitle: Text("News Articles Mentioning Apple", style: TextStyle(fontFamily: "Times New Roman", fontSize: 18.0, fontStyle: FontStyle.italic),),
                      onTap: (){
                        setState(() {
                         _provider = _provider1;
                        _headlines = "Apple News"; 
                        });
                      },
                    ),
                    ListTile(
                      title: Text("Bitcoin News", style: TextStyle(fontFamily: "Times New Roman", fontSize: 18.0, fontStyle: FontStyle.italic),),
                      subtitle: Text("Articles about Bitcoin from the Past Month", style: TextStyle(fontFamily: "Times New Roman", fontSize: 18.0, fontStyle: FontStyle.italic),),
                      onTap: (){
                        setState(() {
                         _provider = _provider2;
                        _headlines = "Bitcoin News"; 
                        });
                      },
                    ),
                  ],
                ),
              ),
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                centerTitle: true,
                title: Text("${_headlines.toUpperCase()}",style: TextStyle(
                  fontFamily: "Times New Roman"
                ),),
                elevation: 3.0,
                backgroundColor: Colors.blue.withOpacity(0.5),
              ),
              body: Center(
                child: ListView.builder(
                  padding: EdgeInsets.all(12.0),
                  itemCount: _provider.length,
                  itemBuilder: (BuildContext context, int position){
                    return Card(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            title: CachedNetworkImage(
                              imageUrl: "${_provider[position]["urlToImage"]}",
                              placeholder: (context, url)=>CircularProgressIndicator(),
                              errorWidget: (context, url, error)=> Icon(Icons.error),
                            ),
                            subtitle: Text("${_provider[position]["title"]}",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                              fontFamily: "Times New Roman",
                            ),
                            ),
                            onTap: ()=> _showNewsSnippet(context, _provider[position]["description"]),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

//Functions
Future<List>fetchData(String apiUrl)async {
  http.Response response = await http.get(apiUrl);
  return (json.decode(response.body))['articles'];
}

void _showNewsSnippet(BuildContext context, String snippet){
  var alert = AlertDialog(
    title: Text("Headline", style: TextStyle(
      fontSize: 16.0, fontFamily: "Times New Roman", fontWeight: FontWeight.w500
    ),),
    content: Text(snippet),
    actions: <Widget>[
      FlatButton(
        child: Text("Dismiss", style: TextStyle(
          fontSize: 16.0, fontFamily: "Times New Roman", fontStyle: FontStyle.italic
        )),
        onPressed: ()=> Navigator.pop(context),
      ),
    ],
  );
  showDialog(
    context: context,
    builder: (context) => alert
  );
}
