import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';


class WeightLifting extends StatefulWidget {
  const WeightLifting({super.key});

  @override
  State<WeightLifting> createState() => _WeightLiftingState();
}
class _WeightLiftingState extends State<WeightLifting> {
 
final videoURL = "https://www.youtube.com/watch?v=BNsKEG3hIzI";

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
    return Scaffold(
      appBar: AppBar(
         centerTitle: true,
        title: const Text('Weight Lifting',
            style: TextStyle(
                color: Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.bold))
      ),
      body: SingleChildScrollView(
        padding:const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

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


          const   SizedBox(height: 10,),
            _buildSectionTitle('Required Tools'),
            _buildToolItem(
                'Dumbbells', 'Versatile and essential for lightweight lifting.',"assets/weight lifting/dumbell.png"),
            _buildToolItem(
                'Resistance Bands', 'Great for adding resistance to exercises.',"assets/weight lifting/workout.png"),
            _buildToolItem(
                'Yoga Mat', 'Provides cushioning and stability for floor exercises.',"assets/weight lifting/yoga-mat.png"),
            _buildSectionTitle('Tips for Lightweight Lifting'),
            _buildTipItem(
                'Start with proper form',
                'Maintaining proper form is crucial to prevent injuries and get the most out of your workout.'),
            _buildTipItem(
                'Increase weight gradually',
                'Don\'t try to lift too heavy too soon. Gradually increase the weight to avoid strain.'),
            _buildTipItem(
                'Listen to your body',
                'Pay attention to how your body feels during the workout. If something doesn\'t feel right, stop and reassess.'),
            _buildSectionTitle('Warm-up Exercises'),
            _buildToolItem(
                'Jumping Jacks', 'Helps increase heart rate and warm up muscles.', "assets/weight lifting/jumping-jack.png"),
            _buildToolItem(
                'Arm Circles', 'Loosens up shoulders and arms before lifting.',"assets/running/arm_circles.png"),
            _buildToolItem(
                'Bodyweight Squats', 'Prepares legs for squat exercises.',"assets/weight lifting/squats.png"),
            
            // Add more sections and items as needed
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding:const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style:const TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
            color: Colors.blue
        ),
      ),
    );
  }

   Widget _buildTipItem(String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.check_circle,
              color: Color.fromARGB(255, 34, 89, 241),
            ),
            const SizedBox(width: 10.0),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5.0),
        Text(
          description,
          style: const TextStyle(
            fontSize: 14.0,
          ),
        ),
        const SizedBox(height: 10.0),
      ],
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
