import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';


class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  String search='anime';
  List <String> urls= ["https://w.wallhaven.cc/full/zy/wallhaven-zyym7g.png", "https://w.wallhaven.cc/full/yx/wallhaven-yx8zkk.jpg", "https://w.wallhaven.cc/full/3l/wallhaven-3lzx76.png", "https://w.wallhaven.cc/full/9d/wallhaven-9dm3kd.png", "https://w.wallhaven.cc/full/yx/wallhaven-yx8z9k.png", "https://w.wallhaven.cc/full/l8/wallhaven-l83ed2.jpg", "https://w.wallhaven.cc/full/2y/wallhaven-2y8p2y.jpg", "https://w.wallhaven.cc/full/rr/wallhaven-rrdv21.jpg", "https://w.wallhaven.cc/full/ex/wallhaven-ex7jk8.jpg", "https://w.wallhaven.cc/full/we/wallhaven-weq2rx.png", "https://w.wallhaven.cc/full/9d/wallhaven-9dmjxw.png", "https://w.wallhaven.cc/full/d6/wallhaven-d6p1qo.jpg", "https://w.wallhaven.cc/full/qz/wallhaven-qz278r.jpg", "https://w.wallhaven.cc/full/kx/wallhaven-kx7yr7.jpg", "https://w.wallhaven.cc/full/d6/wallhaven-d6p13g.jpg", "https://w.wallhaven.cc/full/1p/wallhaven-1pkvjv.jpg", "https://w.wallhaven.cc/full/2y/wallhaven-2y8l66.png"];
  List <bool> liked=[false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false];
  int urlLength=17;
  User? CurrentUser;
  List <dynamic> likedUrls = [];
  late DocumentReference docRef;
  void getCurrentUser() async {
    try{
      CurrentUser=await FirebaseAuth.instance.currentUser;
      //print(CurrentUser?.email);
      docRef = await FirebaseFirestore.instance.collection('liked urls').doc(CurrentUser?.email);
      await docRef.get().then((value) {likedUrls=value.get('urls');});
      //print(likedUrls);
    }catch(e){print(e);}
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  void getSearchInfo() async {
    liked.clear();
    urls.clear();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context)=> const Center(child: CircularProgressIndicator()),
    );
    var url = Uri.https('www.wallhaven.cc', '/api/v1/search', {'q': search,'ratios':'9x16'});
    var response = await get(url);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      urlLength=jsonResponse['data'].length;
      for(int i=0;i<urlLength;i++) {
        urls.add(jsonResponse['data'][i]['path']);
        liked.add(false);
      }
      //TODO: remove print
      print(urls);
      //print(urlLength);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Request failed with status: ${response.statusCode}.'),
          backgroundColor: Colors.blue,
        ),
      );
      print('Request failed with status: ${response.statusCode}.');
    }
    if(urlLength==0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No results found!'),
          backgroundColor: Colors.blue,
        ),
      );
    }
    Navigator.pop(context);
    setState(() {});
  }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        onPressed: (){
                          docRef.set({
                            'urls': likedUrls
                          });
                          Navigator.pushNamed(context, 'liked screen').then((value){
                            getCurrentUser();
                          });
                        },
                        color: const Color(0xFFF03A56),
                        icon: const Icon(Icons.favorite ),
                        iconSize: 30.0,
                      ),
                      IconButton(
                        onPressed: (){
                          FirebaseAuth.instance.signOut();
                        },
                        color: const Color(0xFFF03A56),
                        icon: const Icon(Icons.logout),
                        iconSize: 30.0,
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20.0,20.0,10.0,20.0),
                        child: TextField(
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(color: Color(0xFFF03A56))
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            labelText: 'search',
                            //labelStyle: const TextStyle(color: Color(0xFFF03A56)),
                          ),
                          onChanged: (String value) => search=value,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: (){
                        getSearchInfo();
                      },
                      icon: const Icon(Icons.search),
                      iconSize: 40.0,
                      color: const Color(0xFFF03A56),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12.0,
                          mainAxisSpacing: 12.0,
                          mainAxisExtent: 170,
                      ),
                      itemCount: urlLength,
                      itemBuilder: (_SearchPageState,index){
                        return Scaffold(
                          body: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.0),
                                border: Border.all(
                                  color: const Color(0xFFF03A56),
                                  width: 3.0,
                                ),
                              ),
                              child: GestureDetector(
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(16.0),
                                    topRight: Radius.circular(16.0),
                                    bottomRight: Radius.circular(16.0),
                                    bottomLeft: Radius.circular(16.0),
                                  ),
                                  child: Image.network('https://th.wallhaven.cc/small/${urls.elementAt(index).substring(41,43)}/${urls.elementAt(index).substring(41,47)}.jpg',
                                    height: 170,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    loadingBuilder: (BuildContext context, Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress.expectedTotalBytes != null
                                              ? loadingProgress.cumulativeBytesLoaded /
                                              loadingProgress.expectedTotalBytes!
                                              : null,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                onTap: (){Navigator.pushNamed(context, 'image screen',arguments: urls.elementAt(index));},
                              ),
                        ),
                          floatingActionButton: FloatingActionButton(
                            onPressed: (){
                              setState(() {
                                likedUrls.add(urls.elementAt(index));
                                likedUrls=likedUrls.toSet().toList();
                                liked[index] = true;
                              });
                            },
                            backgroundColor: Color(0xFF262626).withOpacity(0.8),
                            child: liked.elementAt(index)==false ? const Icon(Icons.favorite_outline,size: 30.0,color: Color(0xFFF03A56),):const Icon(Icons.favorite,size: 30.0,color: Color(0xFFF03A56),),
                          ),
                        );
                      }
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}
