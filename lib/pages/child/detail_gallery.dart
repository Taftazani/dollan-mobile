import 'package:dollan/templates/list_item.dart';
import 'package:flutter/material.dart';

class DetailGallery extends StatefulWidget {
  @override
  _DetailGalleryState createState() => _DetailGalleryState();
}

class _DetailGalleryState extends State<DetailGallery> {

  

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    _showFull(int idx) async{
    await showDialog(context: context, builder: (context){
      return AlertDialog(
        contentPadding: EdgeInsets.all(5),
        content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
        Container(
          child: Image.asset('assets/images/$idx.jpg', fit: BoxFit.cover,),)
      ],),);
    });
  }

    return 
    Padding(
        padding: const EdgeInsets.all(8.0),
        child: 
        Container(
          height: 300,
          child: 
          GridView.count(
            // controller: scrollController,
            padding: EdgeInsets.only(top: 0),
            childAspectRatio: 1,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            crossAxisCount: 3,
            children: List.generate(5, (_index) {
              return Container(
                color: Colors.yellow,
                child: GestureDetector(
                  onTap: (){
                    _showFull(_index+1);
                  },
                  child: ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.asset('assets/images/${_index+1}.jpg', fit: BoxFit.cover,),)),
              );
            }),
          ),
        ),
      );
  }

  
}
