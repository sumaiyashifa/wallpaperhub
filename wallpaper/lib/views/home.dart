import 'dart:convert';
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wallpaper/Data/data.dart';
import 'package:wallpaper/model/categories_model.dart';
import 'package:wallpaper/model/wallpaper_model.dart';
import 'package:wallpaper/widgets/widget.dart';
ímport 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<CategoriesModel> categories = [];
  List<WallpaperModel>wallpapers=[];
getTrendingWallpapers() async {
  var response= await http.get( "https://api.pexels.com/v1/curated?per_page=1"
,   Headers:{
  "Authorization":apiKEY
});
// print(response.body.toString());
 Map<String, dynamic> jsonData = jsonDecode(response.body);
      jsonData["photos"].forEach((element) {
        // print(element);
           WallpaperModel photosModel = new WallpaperModel();
        photosModel = WallpaperModel.fromMap(element);
        wallpapers.add(photosModel);
        });
        setState(() {});
   
}
  @override
  void initState() {
    getTrendingWallpapers();
    categories = getCategories();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: brandName(),
        elevation: 0.0,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  color: Color(0xfff5f8fd),
                  borderRadius: BorderRadius.circular(30)),
              margin: EdgeInsets.symmetric(horizontal: 24),
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: TextField(
                    // controller: searchController,
                    decoration: InputDecoration(
                        hintText: "search wallpapers",
                        border: InputBorder.none),
                  )),
                  Icon(Icons.search)
                ],
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Container(
              height: 80,
              child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  itemCount: categories.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return CatagoriesTile(
                      title: categories[index].categorieName,
                      imgUrl: categories[index].imgUrl,
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}

class CatagoriesTile extends StatelessWidget {
  final String imgUrl, title;
  CatagoriesTile({required this.title, required this.imgUrl});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 4),
      child: Stack(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(imgUrl,
                height: 50, width: 100, fit: BoxFit.cover),
          ),
          Container(
            color: Colors.black26,
            height: 50,
            width: 100,
            alignment: Alignment.center,
            child: Text(
              title,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 15),
            ),
          )
        ],
      ),
    );
  }
}
