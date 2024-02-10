import 'package:audioplayers/audioplayers.dart';

import 'package:flutter/material.dart';


class AudioPlayerWidget extends StatefulWidget {
  final String audioPath;

  AudioPlayerWidget({Key? key, required this.audioPath}) : super(key: key);

  @override
  _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState(audioPath);
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late AudioPlayer _player;
  late bool _isPlaying;
  late String audioPath;
  _AudioPlayerWidgetState(this.audioPath);
  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _isPlaying = false;
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  void _play() {
    setState(() {
      _isPlaying = true;
    });
    Source url=UrlSource(audioPath);
    _player.play(url);
    _player.onPlayerComplete.listen((event) {
      setState(() {
        _isPlaying=false;
      });
    });
    // _player.onPlayerCompletion.listen((event) {
    //   setState(() {
    //     _isPlaying = false;
    //   });
    // });
  }

  void _stop() {
    setState(() {
      _isPlaying = false;
    });
    _player.stop();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        _isPlaying ? _stop() : _play();
      },
      icon: _isPlaying ? const Icon(Icons.stop, color: Colors.red) : const Icon(Icons.play_arrow, color: Colors.black),
    );
  }
}
