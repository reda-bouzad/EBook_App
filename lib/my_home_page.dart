import 'dart:convert';

import 'package:ebook_app/login.dart';
import 'package:ebook_app/main.dart';
import 'package:ebook_app/my_tabs.dart';
import 'package:flutter/material.dart';
import 'app_colors.dart' as AppColors;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  // Variables
  List? popularBooks = [];
  ScrollController? _scrollController;
  TabController? _tabController;
  // Functions
  readData() async {
    await DefaultAssetBundle.of(context)
        .loadString("json/popularBooks.json")
        .then((s) => setState(() {
              popularBooks = json.decode(s);
            }));
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _scrollController = ScrollController();
    readData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 16, 16, 92),
      child: SafeArea(
        child: Scaffold(
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
                          ));
                    }),
              ),
              Expanded(
                  child: NestedScrollView(
                controller: _scrollController,
                headerSliverBuilder: (BuildContext context, bool isScroll) {
                  return [
                    SliverAppBar(
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
                              indicator: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
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
                  children: const [
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
