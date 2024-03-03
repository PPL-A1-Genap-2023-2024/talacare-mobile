import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:talacare/talacare.dart';

// import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setPortrait();

//   final assetManifest = await AssetManifest.loadFromAssetBundle(rootBundle);
// // This returns a List<String> with all your images
//   final imageAssetsList = assetManifest.listAssets().where((string) => string.startsWith("assets/images/")).toList();
//   print(imageAssetsList);

  TalaCare game = TalaCare();
  runApp(GameWidget(game: kDebugMode ? TalaCare() : game));
}
