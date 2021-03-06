import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:wanandroid/model/knowledge_system.dart';
import 'package:wanandroid/net/dio_manager.dart';
import 'package:wanandroid/ui/knowledge/knowledge_detail_page.dart';
import 'package:wanandroid/widget/custom_refresh.dart';
import 'package:wanandroid/widget/page_widget.dart';
import 'package:wanandroid/utils/utils.dart';

class KnowledgePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _KnowledgePageState();
  }
}

class _KnowledgePageState extends State<KnowledgePage>
    with AutomaticKeepAliveClientMixin {
  GlobalKey<EasyRefreshState> _easyRefreshKey =
  new GlobalKey<EasyRefreshState>();
  List datas = List<KnowledgeSystem>();
  PageStateController _pageStateController;

  @override
  void initState() {
    super.initState();
    _pageStateController=PageStateController();
    getList();
  }

  void _onRefresh(bool up) {
    if (up) {
      getList();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return PageWidget(
      reload: (){
        getList();
      },
      controller: _pageStateController,
      child: CustomRefresh(
        easyRefreshKey: _easyRefreshKey,
        onRefresh: () {
          _onRefresh(true);
        },
        child: ListView.builder(
            itemCount: datas.length,
            itemBuilder: (context, index) {
              var data = datas[index];
              return _buildItem(data);
            }),
      ),
    );
  }

  void getList() {
    DioManager.singleton.get("tree/json").then((result) {
      _easyRefreshKey.currentState.callRefreshFinish();
      _easyRefreshKey.currentState.callLoadMoreFinish();
      if (result != null) {
        _pageStateController.changeState(PageState.LoadSuccess);
        datas.clear();
        List<KnowledgeSystem> knowledges =
        KnowledgeSystem.parseList(result.data);
        setState(() {
          datas.addAll(knowledges);
        });
        if (knowledges.length == 0) {
          _pageStateController.changeState(PageState.NoData);
        }
      }else{
        _pageStateController.changeState(PageState.LoadFail);
      }
    });
  }

  Widget _buildItem(KnowledgeSystem item) {
    return GestureDetector(
      onTap: () {
        CommonUtils.push(
            context,
            knowledgeDetailPage(
              knowledge: item,
            ));
      },
      child: Card(
        margin: EdgeInsets.all(5),
        child: Container(
          padding: EdgeInsets.all(10),
          child: Row(
            children: <Widget>[
              Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        item.name,
                        style: TextStyle(
                            fontSize: TextSizeConst.middleTextSize,
                            color: ColorConst.color_333),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: Text(
                          _parseDetail(item.children),
                          style: TextStyle(
                              fontSize: TextSizeConst.smallTextSize,
                              color: ColorConst.color_555),
                        ),
                      ),
                    ],
                  )),
              Icon(
                Icons.keyboard_arrow_right,
                color: ColorConst.color_555,
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  String _parseDetail(List<KnowledgeSystem> children) {
    StringBuffer sb = StringBuffer();
    for (var item in children) {
      sb.write(item.name + "   ");
    }
    return sb.toString();
  }
}
