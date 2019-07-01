import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String codeStack = "";
  String newCodeStack = "";
  bool newCode = false;
  AssetsAudioPlayer _assetsAudioPlayer = AssetsAudioPlayer();

  playPressSound(String c) {
    stackCode(c);

    _assetsAudioPlayer.open(AssetsAudio(
      asset: "press.mp3",
      folder: "assets/audios/",
    ));

    _assetsAudioPlayer.play();
  }

  playOpenSound() {
    _assetsAudioPlayer.open(AssetsAudio(
      asset: "open.mp3",
      folder: "assets/audios/",
    ));

    _assetsAudioPlayer.play();
  }

  playWrongSound() {
    _assetsAudioPlayer.open(AssetsAudio(
      asset: "wrong.mp3",
      folder: "assets/audios/",
    ));

    _assetsAudioPlayer.play();
  }

  playDoorSound() {
    _assetsAudioPlayer.open(AssetsAudio(
      asset: "door.mp3",
      folder: "assets/audios/",
    ));

    _assetsAudioPlayer.play();
  }

  stackCode(String c) {
    if (c == "*") {
      newCode = true;
      newCodeStack = "";
    } else if (c == '#') {
      newCode = false;
    } else {
      if (newCode) {
        newCodeStack = newCodeStack + c;
        debugPrint(
            "pressed $c current new stack $newCodeStack mode = $newCode");
        if (newCodeStack.length == 4) {
          newCode = false;
          setCurrentCode(newCodeStack);
        }
      } else {
        codeStack = codeStack + c;
        debugPrint("pressed $c current stack $codeStack");
        if (codeStack.length == 4) {
          checkCurrentCode(codeStack);
        }
      }
    }
  }

  checkCurrentCode(String check) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String pass = (prefs.getString('passcode') ?? "0000");

    debugPrint("$pass == $check");
    if (pass == check) {
      playOpenSound();
      new Future.delayed(const Duration(seconds: 2), () {
        playDoorSound();
      });
    } else {
      playWrongSound();
    }
    codeStack = "";
  }

  setCurrentCode(String pass) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('passcode', pass);
  }

  Widget buildRow(String key1, String key2, String key3) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ButtonTheme(
          minWidth: 20,    
          buttonColor: Colors.amber,      
          child: RaisedButton(          
          child: Text(key1),
          onPressed: () => playPressSound(key1),
        ),),
        
        ButtonTheme(
          minWidth: 20,       
          buttonColor: Colors.amber,         
          child: RaisedButton(          
          child: Text(key2),
          onPressed: () => playPressSound(key2),
        ),),
        ButtonTheme(
          minWidth: 20,       
           buttonColor: Colors.amber,        
          child: RaisedButton(          
          child: Text(key3),
          onPressed: () => playPressSound(key3),
        ),),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/safe2.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 350,
              right: 22,
           //    top: 425,
           //   right: 15,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildRow("1", "2", "3"),
                  buildRow("4", "5", "6"),
                  buildRow("7", "8", "9"),
                  buildRow("*", "0", "#"),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
