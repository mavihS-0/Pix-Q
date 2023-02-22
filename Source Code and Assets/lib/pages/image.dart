import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ImageScreen extends StatefulWidget {
  const ImageScreen({Key? key}) : super(key: key);

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  late String url;
  @override
  Widget build(BuildContext context) {
    url= ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      body: Column(children: [
        Container(
          margin: const EdgeInsets.fromLTRB(0, 30, 0, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: (){Navigator.pop(context);},
                icon: const Icon(Icons.arrow_back_rounded),
                color: const Color(0xFFF03A56),
                iconSize: 30.0,
              ),
              IconButton(
                onPressed: () async {
                  await Permission.storage.request();
                  await GallerySaver.saveImage(url);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Downloaded to Gallery!'),
                      backgroundColor: Colors.blue,
                    ),
                  );

                },
                icon: const Icon(Icons.download),
                color: const Color(0xFFF03A56),
                iconSize: 30.0,
              ),
            ],
          ),
        ),
        Expanded(child: Image.network(
            url,
          loadingBuilder: (BuildContext context, Widget child,
              ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: SpinKitThreeBounce(color: Color(0xFFF03A56),size: 50,),
              // child: CircularProgressIndicator(
              //   value: loadingProgress.expectedTotalBytes != null
              //       ? loadingProgress.cumulativeBytesLoaded /
              //       loadingProgress.expectedTotalBytes!
              //       : null,
              // ),
            );
          },
        )),
      ],),
    );
}
}