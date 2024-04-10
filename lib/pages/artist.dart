import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:online_music_player/main.dart';
import 'package:online_music_player/models/globalclass.dart' as globalclass;
import 'package:online_music_player/models/myurl.dart';
import 'package:online_music_player/models/song_fetch.dart';
import 'package:online_music_player/pages/homepage.dart';
import 'package:online_music_player/pages/songpage.dart';

class Artist extends StatefulWidget {
  String name;
  String image;
  Artist(this.name, this.image);

  @override
  State<Artist> createState() => _ArtistState(name, image);
}

class _ArtistState extends State<Artist> {
  String name;
  String image;
  _ArtistState(this.name, this.image);

  @override
  void initState() {
    filterItems(name);
    // TODO: implement initState
    super.initState();
  }

  List<Song> trackUrls = [];

  List<AudioSource> buildPlaylist(song) {
    setState(() {
      trackUrls = song;
    });

    List<AudioSource> playlist = [];
    playlist.clear();

    for (int i = 0; i < trackUrls.length; i++) {
      try {
        playlist.add(
          AudioSource.uri(
            Uri.parse(MyUrl.fullurl + trackUrls[i].filepath),
            tag: MediaItem(
              id: trackUrls[i].id,
              title: trackUrls[i].title,
              artist: trackUrls[i].singer,
              genre: trackUrls[i].genre,
              album: trackUrls[i].lyrics,
              displayDescription: trackUrls[i].filepath,
              duration: Duration(minutes: int.parse(trackUrls[i].duration)),
              artUri: Uri.parse(MyUrl.fullurl + trackUrls[i].image),
            ),
          ),
        );
      } catch (e) {
        Fluttertoast.showToast(msg: e.toString());
      }
    }
    setState(() {});
    return playlist;
  }

  void filterItems(String query) {
    globalclass.artist.clear();
    query = query.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        globalclass.artist.clear();
      } else {
        globalclass.artist = globalclass.songs
            .where((item) => item.singer.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 16, 22, 42),
        ),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 400,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: CachedNetworkImageProvider(image),
                        fit: BoxFit.cover)),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomRight,
                      colors: [
                        Colors.black.withOpacity(.9),
                        Colors.black.withOpacity(.3)
                      ],
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Text(
                          name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(
                child: globalclass.artist.isNotEmpty
                    ? ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        primary: false,
                        itemCount: globalclass.artist.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            key: UniqueKey(),
                            leading: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 35,
                              child: CachedNetworkImage(
                                imageUrl: MyUrl.fullurl +
                                    globalclass.artist[index].image,
                                placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                                imageBuilder: (context, imageProvider) {
                                  return Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                        image: DecorationImage(
                                            image: imageProvider)),
                                  );
                                },
                              ),
                            ),
                            title: Text(
                              globalclass.artist[index].title,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 18,
                                  color: Colors.white),
                            ),
                            subtitle: Text(
                              globalclass.artist[index].singer,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: const TextStyle(color: Colors.grey),
                            ),
                            onTap: () {
                              SongPageState.beforeid = 0;
                              setState(() {
                                player.seek(Duration.zero, index: index);
                                HomePageState.playlist =
                                    ConcatenatingAudioSource(
                                        children:
                                            buildPlaylist(globalclass.artist));
                                HomePageState.musicindex = index;
                                HomePageState.songclass =
                                    globalclass.artist[index];
                                HomePageState.listsong = globalclass.artist;
                                HomePageState.id =
                                    int.parse(HomePageState.songclass.id);
                                HomePageState.img =
                                    '${MyUrl.fullurl}${HomePageState.songclass.image}';
                                HomePageState.title =
                                    globalclass.artist[index].title;
                                HomePageState.subtitle =
                                    '${globalclass.artist[index].singer}';
                                globalclass.controller.add(true);
                                Get.to(
                                    () => SongPage(
                                        HomePageState.playlist,
                                        HomePageState.musicindex,
                                        HomePageState.id,
                                        HomePageState.listsong),
                                    transition: Transition.downToUp);
                              });
                            },
                          );
                        },
                      )
                    : const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'No Result Found',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 25),
                              ),
                            ],
                          )
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
