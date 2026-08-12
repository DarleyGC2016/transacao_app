import 'package:flutter/material.dart';

import '../grafico/dashboard.dart';
import 'my_home_page.dart';

class MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      body:
         Center(
           child: DashboardPage(),
         )
    );
  }
}