import 'package:expense_tracker/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingPreference extends StatefulWidget {
  const SettingPreference({Key? key}) : super(key: key);

  @override
  State<SettingPreference> createState() => _SettingPreferenceState();
}

class _SettingPreferenceState extends State<SettingPreference> {
  final Map<String, Object?> _map = Map<String, Object?>();

  bool hasLoadedPref = false;

  void initSharePref() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    setState(() {
      _map.addAll({
        "currencies": _prefs.getStringList('currencies') ?? ["USD", "VNĐ"]
      });
      _map.addAll({
        "languages":
            _prefs.getStringList('languages') ?? ["English", "Vietnamese"]
      });

      _map.addAll({
        "prefSecurity":
            _prefs.getStringList('security') ?? ["Fingerprint", "Pin"]
      });
      _map.addAll({
        "prefCurrency": _prefs.getString('currency') ??
            (_map['currencies'] as List<String>)[0]
      });
      _map.addAll({
        "prefLanguage": _prefs.getString('language') ??
            (_map['languages'] as List<String>)[0]
      });
      _map.addAll({"prefTheme": _prefs.getString('theme') ?? "Dark"});
      _map.addAll({"prefAlert": _prefs.getString('alert') ?? "Fingerprint"});
      _map.addAll({"prefTip": _prefs.getBool('tip') ?? false});

      hasLoadedPref = true;
    });
  }

  @override
  void initState() {
    super.initState();
    initSharePref();
  }

  Widget itemSetting(
          {required String title,
          String? currentValue,
          void Function()? onTap}) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          color: MyColor.mainBackgroundColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (currentValue != null)
                    Text(
                      currentValue,
                      style: TextStyle(color: Colors.white70),
                    ),
                  SizedBox(
                    width: 16.0,
                  ),
                  Icon(Icons.arrow_forward_ios)
                ],
              )
            ],
          ),
        ),
      );

  Future<String?> editPrefSingle(
      {required List<String> data, String? currentValue}) async {
    String? selected;
    await showModalBottomSheet(
        context: context,
        builder: (context) => Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0))),
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: data
                    .map((e) => GestureDetector(
                          onTap: () {
                            selected = e;
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: EdgeInsets.all(10.0),
                            color: Colors.transparent,
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    e,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  if (currentValue != null && currentValue == e)
                                    Icon(
                                      Icons.check,
                                      color: Colors.black,
                                    )
                                ]),
                          ),
                        ))
                    .toList(),
              ),
            ));

    return selected;
  }

  //Future<List<String>?> editPrefMulti() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: null, icon: Icon(Icons.arrow_back_ios)),
        title: Text("Setting"),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: MyColor.mainBackgroundColor,
      ),
      body: hasLoadedPref
          ? ListView(physics: BouncingScrollPhysics(), children: [
              itemSetting(
                title: "Currency",
                currentValue: _map["prefCurrency"] as String,
                onTap: () async => await editPrefSingle(
                    data: _map["currencies"] as List<String>,
                    currentValue: _map["prefCurrency"] as String),
              ),
              itemSetting(
                  title: "Language",
                  currentValue: _map["prefLanguage"] as String,
                  onTap: () async => await editPrefSingle(
                      data: _map["languages"] as List<String>,
                      currentValue: _map["prefLanguage"] as String)),
              itemSetting(
                  title: "Theme",
                  currentValue: _map["prefTheme"] as String,
                  onTap: () async => await editPrefSingle(
                      data: ["Dark", "Night", "Light"],
                      currentValue: _map["prefTheme"] as String)),
              itemSetting(
                  title: "Security",
                  currentValue:
                      (_map["prefSecurity"] as List<String>).join(", ")),
              itemSetting(title: "Notification"),
              SizedBox(
                height: 32.0,
              ),
              itemSetting(title: "About"),
              itemSetting(title: "Help")
            ])
          : Center(child: Text("Loading")),
    );
  }
}
