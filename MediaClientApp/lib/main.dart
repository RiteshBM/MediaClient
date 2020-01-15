import 'package:flutter/material.dart';
import 'src/app.dart';

void main(){
  runApp(App());
}

// import 'chewie_list_item.dart';
// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Video Player'),
//       ),
//       body: ListView(
//         children: <Widget>[
//           ChewieListItem(
//             videoPlayerController: VideoPlayerController.network(
//               'http://192.168.43.186:8080/movies/Solo.A.Star.Wars.Story.2018.720p.BluRay.x264-[YTS.AM].mp4',
//             ),
//             looping: true,
//           ),
//           ChewieListItem(
//             videoPlayerController: VideoPlayerController.network(
//               'http://192.168.43.186:8080/movies/Full.Metal.Jacket.1987.720p.BrRip.YIFY.mp4',
//             ),
//           ),
//           ChewieListItem(
//             videoPlayerController: VideoPlayerController.network(
//               'http://192.168.43.186:8080/movies/Your.Name.2016.720p.BluRay.x264-[YTS.AM].mp4',
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }