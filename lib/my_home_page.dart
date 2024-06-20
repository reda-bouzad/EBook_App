import 'dart:convert';

import 'package:ebook_app/book.dart';
import 'package:ebook_app/login.dart';
import 'package:ebook_app/main.dart';
import 'package:ebook_app/my_tabs.dart';
import 'package:flutter/material.dart';
import 'app_colors.dart' as AppColors;
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  // Variables
  List? popularBooks = [];
  List? books = [];
  ScrollController? _scrollController;
  TabController? _tabController;
  // Functions
  readData() async {
    await DefaultAssetBundle.of(context)
        .loadString("json/popularBooks.json")
        .then((s) => setState(() {
              popularBooks = json.decode(s);
            }));
    await DefaultAssetBundle.of(context)
        .loadString("json/books.json")
        .then((s) => setState(() {
              books = json.decode(s);
            }));
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _scrollController = ScrollController();
    readData();
  }

  void _addBook(Book book) {
    setState(() {
      books?.add(book);
    });
  }

  //
  Future<void> _showAddBookDialog() async {
    final titleController = TextEditingController();
    final textController = TextEditingController();
    final imageController = TextEditingController();
    final audioController = TextEditingController();
    final ratingController = TextEditingController();

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Book'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(hintText: 'Title'),
                ),
                TextField(
                  controller: textController,
                  decoration: InputDecoration(hintText: 'Text'),
                ),
                TextField(
                  controller: imageController,
                  decoration: InputDecoration(hintText: 'Image URL'),
                ),
                TextField(
                  controller: audioController,
                  decoration: InputDecoration(hintText: 'Audio URL'),
                ),
                TextField(
                  controller: ratingController,
                  decoration: InputDecoration(hintText: 'Rating'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Add'),
              onPressed: () {
                final title = titleController.text;
                final text = textController.text;
                final image = imageController.text;
                final audio = audioController.text;
                final rating = double.tryParse(ratingController.text) ?? 0.0;

                if (title.isNotEmpty && text.isNotEmpty) {
                  _addBook(Book(
                      title: title,
                      text: text,
                      image: image,
                      audio: audio,
                      rating: rating));
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
  //

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 16, 16, 92),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 15, left: 10, right: 10),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(Icons.dashboard),
                      Row(
                        children: [
                          const Icon(Icons.search),
                          const SizedBox(width: 10),
                          const Icon(Icons.notifications),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()),
                              );
                            },
                            child: const Icon(Icons.login),
                          ),
                        ],
                      ),
                    ]),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 15),
                    child: const Text(
                      "Popular Books",
                      style: TextStyle(fontSize: 30),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 180,
                child: PageView.builder(
                    controller: PageController(viewportFraction: 0.8),
                    itemCount: popularBooks?.length ?? 0,
                    itemBuilder: (_, i) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 180,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                                image: AssetImage(popularBooks?[i]["img"])),
                          ),
                        ),
                      );
                    }),
              ),
              Expanded(
                  child: NestedScrollView(
                controller: _scrollController,
                headerSliverBuilder: (BuildContext context, bool isScroll) {
                  return [
                    SliverAppBar(
                      backgroundColor: AppColors.tabVarViewColor,
                      pinned: true,
                      forceElevated: false,
                      elevation: 0,
                      bottom: PreferredSize(
                        preferredSize: const Size.fromHeight(20),
                        child: Container(
                          decoration: const BoxDecoration(boxShadow: [
                            BoxShadow(
                                color: Colors.white,
                                blurRadius: 0.0,
                                spreadRadius: 0,
                                offset: Offset(0, 2))
                          ]),
                          child: TabBar(
                              indicatorPadding: const EdgeInsets.all(0),
                              indicatorSize: TabBarIndicatorSize.label,
                              controller: _tabController,
                              isScrollable: false,
                              labelColor: AppColors.tabVarViewColor,
                              indicator: const BoxDecoration(
                                  color: Colors.transparent),
                              tabs: const [
                                AppTabs(
                                    tabText: "New",
                                    tabColor: AppColors.menu1Color),
                                AppTabs(
                                    tabText: "Popular",
                                    tabColor: AppColors.menu2Color),
                                AppTabs(
                                    tabText: "Trending",
                                    tabColor: AppColors.menu3Color),
                              ]),
                        ),
                      ),
                    )
                  ];
                },
                body: TabBarView(
                  controller: _tabController,
                  children: [
                    ListView.builder(
                        itemCount: books?.length ?? 0,
                        itemBuilder: (_, i) {
                          return Container(
                            margin: const EdgeInsets.only(
                                left: 20, right: 20, top: 10, bottom: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: AppColors.tabVarViewColor,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 2,
                                        offset: const Offset(0, 0),
                                        color: Colors.grey.withOpacity(0.2))
                                  ]),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 80,
                                      height: 90,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                          image: AssetImage(books?[i]["img"]),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.star,
                                              size: 24,
                                              color: AppColors.startColor,
                                            ),
                                            Text(books?[i]["rating"])
                                          ],
                                        ),
                                        Text(
                                          books?[i]["title"],
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          books?[i]["text"],
                                          style: const TextStyle(
                                              fontSize: 15, color: Colors.grey),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                    Material(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.green,
                        ),
                        title: Text("data"),
                      ),
                    ),
                    Material(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.green,
                        ),
                        title: Text("data"),
                      ),
                    ),
                  ],
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
