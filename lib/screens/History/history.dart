import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ShareApp/models/add_history.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  RefreshController _refreshControllerE =
      RefreshController(initialRefresh: false);
  // String s = "null value from start";
  SharedPreferences sharedPreferences;
  List<SaveData> data = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  void loadData() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  loadAllData() async {
    List<String> spList = await sharedPreferences.getStringList('check');
    setState(() {});
    data = spList.map((e) => SaveData.fromMap(jsonDecode(e))).toList() ?? [];
  }

  void _onRefresh() async {
    loadAllData();
    _refreshController.refreshCompleted();
  }

  void _onRefreshE() async {
    loadAllData();
    _refreshControllerE.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    loadAllData();
    if (data.length != 0) {
      return SmartRefresher(
        // onLoading: _onLoading(),
        enablePullDown: true,
        enablePullUp: true,
        header: WaterDropHeader(),
        controller: _refreshController,
        onRefresh: _onRefresh,
        footer: CustomFooter(
          builder: (BuildContext context, LoadStatus status) {
            Widget body;
            if (status == LoadStatus.idle) {
              body = Text("pull up load");
            } else if (status == LoadStatus.loading) {
              body = CupertinoActivityIndicator();
            } else if (status == LoadStatus.failed) {
              body = Text("Load Failed!Click retry!");
            } else if (status == LoadStatus.canLoading) {
              body = Text("release to load more");
            } else {
              body = Text("No more Data");
            }
            return Container(
              height: 55.0,
              child: Center(child: body),
            );
          },
        ),
        child: ListView.separated(
          itemCount: data.length,
          separatorBuilder: (context, index) => Divider(),
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(data[index].fileName),
              subtitle: Text(data[index].whichSide +
                  " to " +
                  data[index].otherUserId +
                  " At " +
                  data[index].dateTime),
              leading: CircleAvatar(
                backgroundColor: data[index].whichSide == "Send"
                    ? Colors.green
                    : Colors.blue,
                child: Icon(data[index].whichSide == "Send"
                    ? Icons.upload_rounded
                    : Icons.download_rounded),
              ),
            );
          },
        ),
      );
    } else {
      return SmartRefresher(
        controller: _refreshControllerE,
        enablePullDown: true,
        enablePullUp: true,
        header: WaterDropHeader(),
        onRefresh: _onRefreshE,
        footer: CustomFooter(
          builder: (BuildContext context, LoadStatus status) {
            Widget body;
            if (status == LoadStatus.idle) {
              body = Text("pull up load");
            } else if (status == LoadStatus.loading) {
              body = CupertinoActivityIndicator();
            } else if (status == LoadStatus.failed) {
              body = Text("Load Failed!Click retry!");
            } else if (status == LoadStatus.canLoading) {
              body = Text("release to load more");
            } else {
              body = Text("No more Data");
            }
            return Container(
              height: 55.0,
              child: Center(child: body),
            );
          },
        ),
        child: ListTile(
          title: Text("Pull down to reload the data or Tap "),
          leading: Icon(Icons.arrow_downward),
          onTap: () {
            loadAllData();
          },
        ),
      );
    }
  }
}
