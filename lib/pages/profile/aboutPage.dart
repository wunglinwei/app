import 'package:app/app.dart';
import 'package:app/service/index.dart';
import 'package:app/service/walletApi.dart';
import 'package:app/utils/UI.dart';
import 'package:app/utils/Utils.dart';
import 'package:app/utils/i18n/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:polkawallet_sdk/utils/i18n.dart';
import 'package:polkawallet_ui/utils/index.dart';
import 'package:polkawallet_ui/components/v3/back.dart';

class AboutPage extends StatefulWidget {
  AboutPage(this.service);

  final AppService service;

  static final String route = '/profile/about';

  @override
  _AboutPage createState() => _AboutPage();
}

class _AboutPage extends State<AboutPage> {
  bool _loading = false;
  bool _updateLoading = false;
  String _appVersion;

  Future<void> _checkUpdate() async {
    if (_updateLoading) return;

    setState(() {
      _updateLoading = true;
    });
    final versions = await WalletApi.getLatestVersion();
    setState(() {
      _updateLoading = false;
    });
    AppUI.checkUpdate(context, versions, WalletApp.buildTarget);
  }

  Future<void> _jumpToLink(String uri) async {
    if (_loading) return;

    setState(() {
      _loading = true;
    });

    await UI.launchURL(uri);

    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getAppVersion();
  }

  getAppVersion() async {
    var appVersion = await Utils.getAppVersion();
    setState(() {
      _appVersion = appVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dic = I18n.of(context).getDic(i18n_full_dic_app, 'profile');
    final currentJSVersion = WalletApi.getPolkadotJSVersion(
        widget.service.store.storage,
        widget.service.plugin.basic.name,
        widget.service.plugin.basic.jsCodeVersion);
    final colorGray = Theme.of(context).unselectedWidgetColor;
    final labelStyle = TextStyle(fontSize: 16);
    final contentStyle = TextStyle(fontSize: 14, color: colorGray);
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      appBar: AppBar(
          title: Text(dic['about.title']),
          centerTitle: true,
          leading: BackBtn(
            onBack: () => Navigator.of(context).pop(),
          )),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(16),
            child: Column(
              children: <Widget>[
                GestureDetector(
                  child: Container(
                    padding: EdgeInsets.only(top: 16, bottom: 16),
                    child: Row(
                      children: [
                        Expanded(
                            child: Text(dic['about.terms'], style: labelStyle)),
                        Icon(Icons.arrow_forward_ios,
                            size: 16, color: colorGray),
                      ],
                    ),
                  ),
                  onTap: () => _jumpToLink(
                      'https://polkawallet.io/terms-conditions.html'),
                ),
                GestureDetector(
                  child: Container(
                    padding: EdgeInsets.only(top: 16, bottom: 16),
                    child: Row(
                      children: [
                        Expanded(
                            child:
                                Text(dic['about.privacy'], style: labelStyle)),
                        Icon(Icons.arrow_forward_ios,
                            size: 16, color: colorGray),
                      ],
                    ),
                  ),
                  onTap: () => _jumpToLink(
                      'https://github.com/polkawallet-io/app/blob/master/privacy-policy.md'),
                ),
                GestureDetector(
                  child: Container(
                    padding: EdgeInsets.only(top: 16, bottom: 16),
                    child: Row(
                      children: [
                        Expanded(child: Text('Github', style: labelStyle)),
                        Icon(Icons.arrow_forward_ios,
                            size: 16, color: colorGray),
                      ],
                    ),
                  ),
                  onTap: () => _jumpToLink(
                      'https://github.com/polkawallet-io/app/issues'),
                ),
                GestureDetector(
                  child: Container(
                    padding: EdgeInsets.only(top: 16, bottom: 16),
                    child: Row(
                      children: [
                        Expanded(
                            child:
                                Text(dic['about.feedback'], style: labelStyle)),
                        Text("hello@polkawallet.io", style: contentStyle),
                        Icon(Icons.arrow_forward_ios,
                            size: 16, color: colorGray),
                      ],
                    ),
                  ),
                  onTap: () => _jumpToLink('mailto:hello@polkawallet.io'),
                ),
                Divider(height: 1),
                GestureDetector(
                  child: Container(
                    padding: EdgeInsets.only(top: 16, bottom: 16),
                    child: Row(
                      children: [
                        Expanded(
                            child:
                                Text(dic['about.version'], style: labelStyle)),
                        Visibility(
                          visible: _updateLoading,
                          child: Container(
                            padding: EdgeInsets.only(right: 8),
                            child: CupertinoActivityIndicator(radius: 8),
                          ),
                        ),
                        Text(_appVersion ?? "", style: contentStyle),
                        Icon(Icons.arrow_forward_ios,
                            size: 16, color: colorGray),
                      ],
                    ),
                  ),
                  onTap: _checkUpdate,
                ),
                Container(
                  padding: EdgeInsets.only(top: 16, bottom: 16),
                  child: Row(
                    children: [
                      Expanded(child: Text('API', style: labelStyle)),
                      Text(currentJSVersion.toString(), style: contentStyle),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
