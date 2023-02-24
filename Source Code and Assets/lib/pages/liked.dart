import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LikedPage extends StatefulWidget {
  const LikedPage({Key? key}) : super(key: key);

  @override
  State<LikedPage> createState() => _LikedPageState();
}

class _LikedPageState extends State<LikedPage> {
  User? CurrentUser;
  List <dynamic> likedUrls = [];
  List <bool> liked=[];
  late DocumentReference docRef;
  void getCurrentUser() async {
    try{
      CurrentUser=await FirebaseAuth.instance.currentUser;
      //print(CurrentUser?.email);
      docRef = await FirebaseFirestore.instance.collection('liked urls').doc(CurrentUser?.email);
      await docRef.get().then((value) {likedUrls=value.get('urls');});
      for(int i=0;i<likedUrls.length;i++) liked.add(true);
      //TODO: remove print
      //print(likedUrls);
    }catch(e){print(e);}
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    getCurrentUser();
    super.initState();

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
                        onPressed: () {
                          //TODO: remove print
                          //print(liked);
                          List <dynamic> tempList =[];
                          for(int i=0;i<likedUrls.length;i++) {
                            if(liked[i]==true) {
                              tempList.add(likedUrls.elementAt(i));
                            }
                          }
                          //print(tempList);
                          docRef.set({
                            'urls': tempList
                          });
                          Navigator.pop(context);
                        },
                        color: const Color(0xFFF03A56),
                        icon: const Icon(Icons.arrow_back_rounded ),
                        iconSize: 30.0,
                      ),
                      IconButton(
                        onPressed: (){
                          //print(liked);
                          List <dynamic> tempList =[];
                          for(int i=0;i<likedUrls.length;i++) {
                            if(liked[i]==true) {
                              tempList.add(likedUrls.elementAt(i));
                            }
                          }
                          //print(tempList);
                          //docRef.delete();
                          docRef.set({
                            'urls': tempList
                          });
                          FirebaseAuth.instance.signOut();
                          Navigator.pop(context);
                        },
                        color: const Color(0xFFF03A56),
                        icon: const Icon(Icons.logout),
                        iconSize: 30.0,
                      ),
                    ],
                  ),
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
                      itemCount: likedUrls.length,
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
                                child: Image.network('https://th.wallhaven.cc/small/${likedUrls.elementAt(index).substring(41,43)}/${likedUrls.elementAt(index).substring(41,47)}.jpg',
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
                              onTap: (){Navigator.pushNamed(context, 'image screen',arguments: likedUrls.elementAt(index));},
                            ),
                          ),
                          floatingActionButton: FloatingActionButton(
                            onPressed: (){
                              liked[index]=false;
                              setState(() {});
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
        ),
    );
  }
}
