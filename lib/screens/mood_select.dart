import 'dart:math';

import 'package:flutter/material.dart';
import 'package:moody/api/api.dart';
import 'package:moody/route/route_generator.dart';
import 'package:moody/widgets/widgets.dart';

import '../api/exception/user_feedback_exception.dart';
import '../structs/profile.dart';
import '../structs/team.dart';
import '../widgets/settings.dart';

class MoodSelect extends StatefulWidget {
  final Map data;

  const MoodSelect(this.data, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MoodSelectState();
}

bool isLoading = true;
Team _team = Team.empty();
Profile _profile = Profile.empty();
Mood _currentSelectedMood = Mood();
int randomNum = 0;

class _MoodSelectState extends State<MoodSelect> {
  TextEditingController noteController = TextEditingController();
  Random rand = Random(DateTime.now().second);
  List<String> motivationalQuotes = [
    "You do not find the happy life. You make it.",
    "The most wasted of days is one without laughter.",
    "Stay close to anything that makes you glad you are alive.",
    "Make each day your masterpiece.",
    "Happiness is not by chance, but by choice.",
    "Impossible is for the unwilling.",
    "No pressure, no diamonds.",
    "Believe you can and you’re halfway there.",
    "Failure is the condiment that gives success its flavor.",
    "It is never too late to be what you might have been.",
    "You must be the change you wish to see in the world.",
    "Stay foolish to stay sane.",
    "Stay hungry. Stay foolish.",
    "Whatever you are, be a good one.",
    "You must do the things you think you cannot do.",
    "Wherever you go, go with all your heart.",
    "Be faithful to that which exists within yourself.",
    "Dream big and dare to fail.",
    "You are enough just as you are.",
    "To be the best, you must be able to handle the worst.",
    "Every moment is a fresh beginning.",
    "No guts, no story.",
    "Keep going. Be all in.",
    "Leave no stone unturned.",
    "Nothing is impossible. The word itself says I’m possible!",
    "If it matters to you, you’ll find a way.",
    "Tough times never last, but tough people do.",
    "Turn your wounds into wisdom.",
    "If you’re going through hell, keep going.",
    "Don’t wait, the time will never be just right.",
    "Try to be a rainbow in someone’s cloud.",
    "Simplicity is the ultimate sophistication.",
    "No one has ever become poor by giving.",
    "Try Again. Fail again. Fail better.",
    "Good things happen to those who hustle.",
    "No greater gift there is, than a generous heart.",
    "Solitary trees, if they grow at all, grow strong.",
    "You can if you think you can.",
    "Worrying is like paying a debt you don’t owe.",
    "The wisest mind has something yet to learn.",
    "Be yourself; everyone else is already taken.",
    "In the middle of every difficulty lies opportunity.",
    "He who has a why to live can bear almost any how.",
    "Persistence guarantees that results are inevitable.",
    "Hate cannot drive out hate: only love can do that.",
    "Always do what you are afraid to do.",
    "Every noble work is at first impossible.",
    "If you can dream it, you can do it.",
    "Rise above the storm and you will find the sunshine.",
    "Do what you feel in your heart to be right",
    "Pain is temporary. Quitting lasts forever.",
    "The bird a nest, the spider a web, man friendship.",
    "When one door of happiness closes, another opens.",
    "It is not the mountain we conquer but ourselves.",
    "Begin anywhere.",
    "Have faith in yourself and in the future.",
    "Despite the forecast, live like it’s spring.",
    "Do it Now!",
    "The best way to prepare for life is to begin to live.",
    "No great thing is created suddenly.",
    "Man doesn’t know what he is capable of until he is asked.",
    "Courage is fear that has said its prayers.",
    "Live your dreams.",
    "The true vocation of man is to find his way for himself.",
    "No wind favors he who has no destined port.",
    "Only a life lived for others is a life worthwhile.",
    "To know oneself, one should assert oneself.",
    "Men do less than they ought unless they do all they can.",
    "People living deeply have no fear of death.",
    "A clever man commits no minor blunders.",
    "All limitations are self-imposed.",
    "Determine your priorities and focus on them.",
    "Trees that are slow to grow bear the best fruit.",
    "Luck is a matter of preparation meeting opportunity.",
    "Let the beauty of what you love be what you do.",
    "Be sure what you want and be sure about yourself.",
    "Have enough courage to start and enough heart to finish.",
    "With our thoughts, we make the world.",
    "Be so good they can’t ignore you.",
    "If opportunity doesn’t knock, build a door.",
    "Don’t you know your imperfections is a blessing?",
    "Who you are tomorrow begins with what you do today.",
    "Happiness depends upon ourselves.",
    "You can’t have everything. Where would you put it?",
    "Tough times never last but tough people do.",
    "I could agree with you but then we’d both be wrong.",
    "Yesterday you said tomorrow. Just do it.",
    "There is no substitute for hard work.",
    "The meaning of life is to give life meaning.",
    "We accept the love we think we deserve.",
    "Everything you can imagine is real.",
    "Do what you can, with what you have, where you are.",
    "May you live every day of your life.",
    "When in doubt, throw doubt out and have a little faith….",
    "Nothing is impossible to a willing heart.",
    "As soon as you trust yourself, you will know how to live.",
    "My life is my message.",
    "Nothing can dim the light which shines from within.",
    "Never regret anything that made you smile.",
    "You receive from the world what you give to the world.",
    "Everything has beauty, but not everyone sees it.",
    "In a gentle way, you can shake the world.",
    "Aim for the moon. If you miss, you may hit a star.",
    "All progress takes place outside of your comfort zone.",
    "It always seems impossible until it’s done.",
    "None but ourselves can free our minds.",
    "I don’t need it to be easy, I need it to be worth it.",
    "In the middle of difficulty lies opportunity.",
    "He that can have patience can have what he will.",
    "Energy and initiative count as much as talent and luck.",
    "Spread love everywhere you go.",
    "Belief creates the actual fact.",
    "There can be glory in failure and despair in success.",
    "A wise man will make more opportunities than he finds.",
    "None preaches better than the ant, and she says nothing.",
    "A man’s true wealth is the good he does in the world.",
    "Positive anything is better than negative nothing.",
    "I’m a slow walker, but I never walk back.",
    "You can’t live an exceptional life by being normal.",
    "Either you run the day or the day runs you.",
    "We will either find a way, or make one.",
    "Whether you think you can, or you think you can’t",
    "Don’t wish it were easier. Wish you were better.",
    "The best way out is always through.",
    "It’s kind of fun to do the impossible.",
    "The mind is everything. What you think you become.",
    "Every strike brings me closer to the next home run.",
    "I don’t walk away from things I think are unfinished.",
    "Life shrinks or expands in proportion to one’s courage.",
    "You miss 100% of the shots you don’t take.",
    "If you want to be happy, be.",
    "I am a part of all that I have met.",
  ];

  void loadData(Mood selectedMood, Team team) async {
    try {
      _currentSelectedMood = selectedMood;
      // _team = await Api.api.getTeam(team.id);
      _team = team;
      _profile = await Api.api.getProfile();
      randomNum = rand.nextInt(motivationalQuotes.length);
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      //no need to handle
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Container(
            color: Colors.white,
            child: const SizedBox(
              child: Align(
                child: CircularProgressIndicator(),
              ),
              width: 50,
              height: 50,
            ))
        : Scaffold(body: SafeArea(child: LayoutBuilder(builder: (builder, constraints) {
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Widgets.getNavBar(constraints, _back, "Wie geht es dir heute?", _goToProfile, _profile),
                  Widgets.displayInfoBoxWithTitle("Motivational Quote", motivationalQuotes.elementAt(randomNum), constraints),
                  Widgets.getMoodEmojis("Wie geht es Dir heute?", () {}, _renderNew, () {}, constraints, _currentSelectedMood),
                  Widgets.getInputField(noteController, TextInputType.text, constraints),
                  getButtonStyleOrangeWithAnimation(_submitMood, constraints, "Fertig", isLoading),
                ],
              ),
            );
          })));
  }

  Future<void> _submitMood() async {
    isLoading = !isLoading;
    try {
      await Api.api.setMood(_team.id, _currentSelectedMood.activeMood, noteController.text);
    } catch (e) {
      print(e);
    }
    Navigator.pop(context);
    setState(() {});
  }

  void _renderNew() {
    setState(() {});
  }

  @override
  void initState() {
    loadData(widget.data["selectedMood"], widget.data["team"]);
    super.initState();
  }

  void _back() {
    isLoading = true;
    Navigator.pop(context);
  }

  void _goToProfile() {
    Navigator.popAndPushNamed(context, RouteGenerator.profileOverview);
  }

  //button with a circularbtn animation for sending the mood to our backend
  static Widget getButtonStyleOrangeWithAnimation(VoidCallback func, BoxConstraints constraints, String btnText, bool isLoading) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(left: 10, right: 10),
      child: Material(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.orange,
            textStyle: TextStyle(fontSize: 20),
            shape: StadiumBorder(),
          ),
          onPressed: func,
          //borderRadius: BorderRadius.circular(50),
          child: isLoading
              ? Container(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: Colors.white,
                      ),
                      //animation/infotext?
                    ],
                  ),
                )
              : Container(
                  height: 50,
                  alignment: Alignment.center,
                  child: Text(
                    btnText,
                    style: const TextStyle(fontSize: Settings.mainFontSize, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
        ),
      ),
    );
  }
}

/*
Container(
            height: 60,
            alignment: Alignment.center,
            child: Text(btnText,
              style: const TextStyle(
                  fontSize: Settings.mainFontSize,
                   
fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
 */
