import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
class swimming extends StatefulWidget {
  const swimming({super.key});

  @override
  State<swimming> createState() => _swimmingState();
}
class _swimmingState extends State<swimming> {
  

  final videoURL = "https://www.youtube.com/watch?v=p6ROh-M7S0k";

  late YoutubePlayerController _controller;
  @override
  void initState() {
    final videoID = YoutubePlayer.convertUrlToId(videoURL);
    _controller = YoutubePlayerController(
        initialVideoId: videoID!,
        flags: const YoutubePlayerFlags(autoPlay: false, mute: false));
    super.initState();
  }
   @override
  Widget build(BuildContext context) {
    return 
      
       Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title:const Text('Swimming',  style: TextStyle(
                color: Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.bold)),
        ),
        body: SingleChildScrollView(
          padding:const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[

ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: YoutubePlayer(
                  controller: _controller,
                  showVideoProgressIndicator: true,
                  onReady: () => debugPrint('Ready'),
                  bottomActions: [
                    CurrentPosition(),
                    ProgressBar(
                      isExpanded: true,
                      colors: const ProgressBarColors(
                          playedColor: Colors.blue,
                          handleColor: Colors.blueGrey),
                    ),
                    const PlaybackSpeedButton(),
                    
                    FullScreenButton()
                  ],
                ),
              ),
             const SizedBox(height: 10,),

 _buildSectionTitle('Required Tools'),
              _buildToolItem('Swimsuit', "Choose a comfortable swimsuit that allows for freedom of movement.",'assets/Swimming/swimming-suit.png'),
              _buildToolItem('Goggles'," Protect your eyes and improve visibility with a good pair of goggles.", 'assets/Swimming/goggles.png'),
              _buildToolItem('Swim Cap',"Keep your hair out of your face and reduce drag with a swim cap.", 'assets/Swimming/cap.png'),

              _buildSectionTitle('Warm-Up Routines'),
              _buildTipItem(
                '1. Start with a gentle jog or brisk walk around the pool deck to get your heart rate up.',
              ),
              _buildTipItem(
                '2. Perform dynamic stretches such as arm circles, leg swings, and torso twists to loosen up your muscles.',
              ),
              _buildTipItem(
                '3. Gradually ease into your strokes, starting with slow and controlled movements.',
              ),
              _buildSectionTitle('Swimming Tips'),
              _buildTipItem(
                '1. Focus on proper breathing technique by exhaling underwater and inhaling above water.',
              ),
              _buildTipItem(
                '2. Keep your body streamlined to reduce drag, with your head in line with your spine.',
              ),
              _buildTipItem(
                '3. Practice bilateral breathing to improve symmetry and endurance.',
              ),
             
            ],
          ),
        ),
      
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style:const TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTipItem(String tip) {
    return Padding(
      padding:const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
         const Icon(
            Icons.check_circle,
             color: Color.fromARGB(255, 34, 89, 241),
          ),
       const   SizedBox(width: 8.0),
          Expanded(
            child: Text(
              tip,
              style: const TextStyle(fontSize: 16.0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolItem(String toolName,String subtitle, String imagePath) {
    return Padding(
      padding:const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: <Widget>[
          Container(
            width: 80.0,
            height: 80.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
        const  SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  toolName,
                  style:const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),

                  
                ),
                Text(subtitle)
              ],
            ),
          ),
        ],
      ),
    );
  }
}