import 'package:flutter/material.dart';
import 'package:flutter_application_2/config/colors.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  RxBool isDark = true.obs;
  // late SharedPreferences storage;
  @override
  void onInit() {
    super.onInit();
  }

  void setTheme(String themeName) async {
    var pref = await SharedPreferences.getInstance();
    pref.setString('theme', themeName);
    print(pref.getString('theme'));
  }

  final ThemeData lightTheme = ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.deepPurple,
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.deepPurple,
        titleTextStyle: TextStyle(
            color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      colorScheme: ColorScheme.light(
        background: lightBgColor, //for scaffoldBackgroundColor ----->white
        onBackground: ltextColor, //for text color ------>black
        primary: Colors.deepPurple, //for appbar background color
        onPrimary: Colors.white, //for appbar text color
        surface: lmainColor, //for card background color
        onSurface: lightmainColor, //for card text color
        secondary: buttonColor, //for button background color
        onSecondary: darkColor, //for button text color
        onError: Colors.red, //for error text color
        error: lightDivColor, //for error background color
        primaryContainer: lightDivColor, //for container background color
        secondaryContainer: lightDivColor, //for container background color
        onPrimaryContainer: lightTextColor, //for container text color
        onSecondaryContainer: lightTextColor, //for container text color
      ));

  final ThemeData darkTheme = ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.deepOrange,
      useMaterial3: true,
      scaffoldBackgroundColor: darkBgColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: Color.fromARGB(255, 59, 58, 58),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      colorScheme: ColorScheme.dark(
        background: darkBgColor, //for scaffoldBackgroundColor ------->black
        onBackground: dtextColor, //for text color ------>white
        primary: Colors.deepPurple, //for appbar background color
        onPrimary: Colors.white, //for appbar text color
        surface: dmainColor, //for card background color
        onSurface: darkmainColor, //for card text color
        secondary: buttonColor, //for button background color
        onSecondary: darkColor, //for button text color
        onError: Colors.red, //for error text color
        error: darkDivColor, //for error background color
        primaryContainer: darkDivColor, //for container background color
        secondaryContainer: darkDivColor, //for container background color
        onPrimaryContainer: darkTextColor, //for container text color
        onSecondaryContainer: darkTextColor,
      ));

  changeTheme(String name) {
    if (name == 'dark') {
      setTheme(name);
      Get.changeThemeMode(ThemeMode.dark);
    } else if (name == 'light') {
      setTheme(name);
      Get.changeThemeMode(ThemeMode.light);
    }
  }

  themeSet() async {
    String themeNamesf = '';
    var pref = await SharedPreferences.getInstance();
    if (pref.getString('theme') == null) {
      themeNamesf = 'light';
    } else {
      themeNamesf = pref.getString('theme')!;
    }
    if (themeNamesf == 'dark') {
      Get.changeThemeMode(ThemeMode.dark);
    } else if (themeNamesf == 'light') {
      Get.changeThemeMode(ThemeMode.light);
    }
  }
}
