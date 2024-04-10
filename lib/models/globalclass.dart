library ONLINE_MUSIC_PLAYER.globalclass;

import 'dart:async';

import 'package:online_music_player/models/song_fetch.dart';

List<Song> songs = [];
List<Song> search = [];
List<Song> hindi = [];
List<Song> bengali = [];
List<Song> artist = [];
List<Music> musics = [];
StreamController<bool> controller = StreamController.broadcast();
