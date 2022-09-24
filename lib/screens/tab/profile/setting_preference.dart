import 'package:expense_tracker/constants/color.dart';
import 'package:expense_tracker/constants/share_pref_key.dart';
import 'package:expense_tracker/routes/route.dart';
import 'package:expense_tracker/widgets/largest_button.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingPreference extends StatefulWidget {
  const SettingPreference({Key? key}) : super(key: key);

  @override
  State<SettingPreference> createState() => _SettingPreferenceState();
}

class _SettingPreferenceState extends State<SettingPreference> {
  final Map<String, Object?> _map = Map<String, Object?>();

  bool hasLoadedPref = false;

  Future<List<String>?> getLocalAuth() async {
    List<String> result = [];
    LocalAuthentication auth = LocalAuthentication();

    bool isBiometricSupported = await auth.isDeviceSupported();
    bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;

    if (isBiometricSupported && canAuthenticateWithBiometrics) {
      result.add("Biometrics");
    }

    result.addAll(["PIN", "Google Auth"]);
    return result;
  }

  void initSharePref() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    List<String>? localAuth = await getLocalAuth();

    setState(() {
      //share preference has default values
      _map.addAll({
        SharedPreferencesKey.prefCurrencies:
            _prefs.getStringList(SharedPreferencesKey.prefCurrencies) ??
                ["USD", "VNĐ"]
      });
      _map.addAll({
        SharedPreferencesKey.prefLanguages:
            _prefs.getStringList(SharedPreferencesKey.prefLanguages) ??
                ["English", "Vietnamese"]
      });
      _map.addAll({
        SharedPreferencesKey.prefSecurities:
            _prefs.getStringList(SharedPreferencesKey.prefSecurities) ??
                localAuth
      });
      _map.addAll({
        SharedPreferencesKey.prefThemes:
            _prefs.getStringList(SharedPreferencesKey.prefSecurities) ??
                ["Dark", "Light", "Night"]
      });

      //save value
      _map.addAll({
        SharedPreferencesKey.prefCurrency:
            _prefs.getString(SharedPreferencesKey.prefCurrency) ??
                (_map[SharedPreferencesKey.prefCurrencies] as List<String>)[0]
      });
      _map.addAll({
        SharedPreferencesKey.prefLanguage:
            _prefs.getString(SharedPreferencesKey.prefLanguage) ??
                (_map[SharedPreferencesKey.prefLanguages] as List<String>)[0]
      });
      _map.addAll({
        SharedPreferencesKey.prefSecurity:
            _prefs.getStringList(SharedPreferencesKey.prefSecurity) ??
                (_map[SharedPreferencesKey.prefSecurities] as List<String>)
                    .sublist(0, 2)
      });
      _map.addAll({
        SharedPreferencesKey.prefTheme:
            _prefs.getString(SharedPreferencesKey.prefTheme) ??
                (_map[SharedPreferencesKey.prefThemes] as List<String>)[0]
      });
      _map.addAll({
        SharedPreferencesKey.prefAlert:
            _prefs.getBool(SharedPreferencesKey.prefAlert) ?? false
      });
      _map.addAll({
        SharedPreferencesKey.prefTip:
            _prefs.getBool(SharedPreferencesKey.prefTip) ?? false
      });

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
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                children: data
                    .map((e) => GestureDetector(
                          onTap: () {
                            selected = e;
                            RouteApplication.navigatorKey.currentState?.pop();
                          },
                          child: Container(
                            height: 50.0,
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

  Future<List<String>?> editPrefMulti(
      {required List<String> data, List<String>? currentValue}) async {
    List<String> selected = currentValue ?? [];
    await showModalBottomSheet(
        context: context,
        builder: (context) => Container(
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0))),
            child: StatefulBuilder(
              builder: (context, setState) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListView(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    children: data
                        .map((e) => GestureDetector(
                              onTap: () => setState(() => selected.contains(e)
                                  ? selected.remove(e)
                                  : selected.add(e)),
                              child: Container(
                                padding: EdgeInsets.all(10.0),
                                height: 50.0,
                                color: Colors.transparent,
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        e,
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      if (selected.contains(e))
                                        Icon(
                                          Icons.check,
                                          color: Colors.black,
                                        )
                                    ]),
                              ),
                            ))
                        .toList(),
                  ),
                  SizedBox(
                      width: double.maxFinite,
                      child: largestButton(
                        text: "Done",
                        onPressed: () =>
                            RouteApplication.navigatorKey.currentState?.pop(),
                      ))
                ],
              ),
            )));

    return selected;
  }

  Future<Map<String, _EditItemNotification?>?> editPrefBool(
      {required Map<String, _EditItemNotification?> data}) async {
    Map<String, _EditItemNotification?> selected = data;
    await showModalBottomSheet(
        context: context,
        builder: (context) => Container(
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0))),
            child: StatefulBuilder(
              builder: (context, setState) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListView(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      children: data.entries
                          .map((e) => Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(e.value?.title ?? "",
                                          style:
                                              TextStyle(color: Colors.black)),
                                      Text(e.value?.subTitle ?? "",
                                          style:
                                              TextStyle(color: Colors.black38))
                                    ],
                                  ),
                                  Switch(
                                    value: data[e.key]?.value ?? false,
                                    onChanged: (value) => setState(
                                        () => data[e.key]?.value = value),
                                  )
                                ],
                              ))
                          .toList()),
                  SizedBox(
                      width: double.maxFinite,
                      child: largestButton(
                        text: "Done",
                        onPressed: () =>
                            RouteApplication.navigatorKey.currentState?.pop(),
                      ))
                ],
              ),
            )));

    return selected;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => RouteApplication.navigatorKey.currentState?.pop(),
            icon: Icon(Icons.arrow_back_ios)),
        title: Text("Setting"),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: MyColor.mainBackgroundColor,
      ),
      body: hasLoadedPref
          ? ListView(physics: BouncingScrollPhysics(), children: [
              itemSetting(
                title: "Currency",
                currentValue: _map[SharedPreferencesKey.prefCurrency] as String,
                onTap: () async {
                  String? selected = await editPrefSingle(
                      data: _map[SharedPreferencesKey.prefCurrencies]
                          as List<String>,
                      currentValue:
                          _map[SharedPreferencesKey.prefCurrency] as String);
                  if (selected != null) {
                    SharedPreferences _prefs =
                        await SharedPreferences.getInstance();
                    await _prefs.setString(
                        SharedPreferencesKey.prefCurrency, selected);
                    setState(() {
                      _map[SharedPreferencesKey.prefCurrency] =
                          _prefs.getString(SharedPreferencesKey.prefCurrency);
                    });
                  }
                },
              ),
              itemSetting(
                  title: "Language",
                  currentValue:
                      _map[SharedPreferencesKey.prefLanguage] as String,
                  onTap: () async {
                    String? selected = await editPrefSingle(
                        data: _map[SharedPreferencesKey.prefLanguages]
                            as List<String>,
                        currentValue:
                            _map[SharedPreferencesKey.prefLanguage] as String);
                    if (selected != null) {
                      SharedPreferences _prefs =
                          await SharedPreferences.getInstance();
                      await _prefs.setString(
                          SharedPreferencesKey.prefLanguage, selected);
                      setState(() {
                        _map[SharedPreferencesKey.prefLanguage] =
                            _prefs.getString(SharedPreferencesKey.prefLanguage);
                      });
                    }
                  }),
              itemSetting(
                  title: "Theme",
                  currentValue: _map[SharedPreferencesKey.prefTheme] as String,
                  onTap: () async {
                    String? selected = await editPrefSingle(
                        data: _map[SharedPreferencesKey.prefThemes]
                            as List<String>,
                        currentValue:
                            _map[SharedPreferencesKey.prefTheme] as String);
                    if (selected != null) {
                      SharedPreferences _prefs =
                          await SharedPreferences.getInstance();
                      await _prefs.setString(
                          SharedPreferencesKey.prefTheme, selected);
                      setState(() {
                        _map[SharedPreferencesKey.prefTheme] =
                            _prefs.getString(SharedPreferencesKey.prefTheme);
                      });
                    }
                  }),
              itemSetting(
                  title: "Security",
                  currentValue:
                      (_map[SharedPreferencesKey.prefSecurity] as List<String>)
                          .join(", "),
                  onTap: () async {
                    List<String>? selected = await editPrefMulti(
                        data: _map[SharedPreferencesKey.prefSecurities]
                            as List<String>,
                        currentValue: _map[SharedPreferencesKey.prefSecurity]
                            as List<String>);
                    if (selected != null) {
                      SharedPreferences _prefs =
                          await SharedPreferences.getInstance();
                      await _prefs.setStringList(
                          SharedPreferencesKey.prefSecurity, selected);
                      setState(() {
                        _map[SharedPreferencesKey.prefSecurity] = _prefs
                            .getStringList(SharedPreferencesKey.prefSecurity);
                      });
                    }
                  }),
              itemSetting(
                  title: "Notification",
                  onTap: () async {
                    Map<String, _EditItemNotification?>? selected =
                        await editPrefBool(data: {
                      SharedPreferencesKey.prefAlert: _EditItemNotification(
                          title: "Exceed Budget",
                          subTitle: "Notification when exceed budget",
                          value: _map[SharedPreferencesKey.prefAlert] as bool),
                      SharedPreferencesKey.prefTip: _EditItemNotification(
                          title: "Get Tip",
                          subTitle: "Notification tip to suggest",
                          value: _map[SharedPreferencesKey.prefTip] as bool)
                    });

                    if (selected != null) {
                      SharedPreferences _prefs =
                          await SharedPreferences.getInstance();
                      selected.forEach((key, value) async =>
                          await _prefs.setBool(key, value?.value ?? false));
                      setState(() {
                        selected.forEach((key, value) =>
                            _map[key] = _prefs.getBool(key) ?? false);
                      });
                    }
                  }),
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

class _EditItemNotification {
  String? title;
  String? subTitle;
  bool? value;

  _EditItemNotification({this.title, this.subTitle, this.value});
}
