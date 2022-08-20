import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:math_geometry/themes/textStyles.dart';
import 'package:math_geometry/widgets/appbarIcon.dart';
import 'package:math_geometry/widgets/customDialog.dart';

class CustomAppBar extends StatefulWidget {
  final String level;
  final String question;
  final String answer;
  final String pick;
  final String hint;
  final int timeLimit;
  int score;
  final Function onUpdateScore;
  CustomAppBar(this.level, this.question, this.answer, this.pick, this.hint,
      this.score, this.onUpdateScore, this.timeLimit);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  int initTime = 0;
  int retries = 0;
  bool isStartTimer = false;
  bool isCorrect = false;
  bool usedHint = false;
  bool selected = false;

///////////timer function
  void _startCountDown() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        initTime++;
      });
      if (isStartTimer) {
        timer.cancel();
      }
    });
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      final player = AudioPlayer();
      await player.play(AssetSource('popup.wav'));
      showDialog(
          context: context,
          builder: (context) {
            return CustomDialog(
                title: 'Level ${widget.level}',
                clsBtnTitle: 'Quit',
                onClsBtnPressed: () async {
                  final player = AudioPlayer();
                  await player.play(AssetSource('satisfying_click.wav'));
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                message: widget.question,
                attempt: true,
                header: FontAwesomeIcons.question,
                headerColor: Colors.purple,
                secBtnTitle: 'Attempt',
                secOnPress: () async {
                  final player = AudioPlayer();
                  await player.play(AssetSource('satisfying_click.wav'));
                  Navigator.pop(context);
                  _startCountDown();
                });
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    void _showDialog() async {
      final player = AudioPlayer();
      await player.play(AssetSource('popup.wav'));
      showDialog(
          context: context,
          builder: (context) {
            return CustomDialog(
              title: 'Level${widget.level}',
              clsBtnTitle: 'Close',
              onClsBtnPressed: () {
                Navigator.pop(context);
              },
              message: widget.question,
              attempt: false,
              header: FontAwesomeIcons.question,
              headerColor: Colors.purple,
            );
          });
    }

////////hint function
    void _showHint() async {
      final player = AudioPlayer();
      await player.play(AssetSource('hint.wav'));
      showDialog(
          context: context,
          builder: (context) {
            return CustomDialog(
                title: "Hint",
                message: widget.hint,
                clsBtnTitle: "Close",
                onClsBtnPressed: () {
                  Navigator.pop(context);
                },
                attempt: false,
                header: FontAwesomeIcons.solidLightbulb,
                headerColor: Colors.amber);
          });
    }

//////dialog on submit, plus checks if answer is right or wrong
    void _showResult() {
      if (isCorrect) {
        showDialog(
            context: context,
            builder: (context) {
              return CustomDialog(
                  title: 'Correct',
                  clsBtnTitle: 'Next',
                  onClsBtnPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  message: 'Good Job!!',
                  attempt: false,
                  header: FontAwesomeIcons.check,
                  headerColor: Colors.green);
            });
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return CustomDialog(
                header: FontAwesomeIcons.x,
                headerColor: Colors.red,
                title: "Wrong",
                message: "Ooo!! You just missed it, try again.",
                attempt: true,
                clsBtnTitle: "Quit",
                onClsBtnPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                secBtnTitle: "Retry",
                secOnPress: () {
                  retries++;
                  Navigator.pop(context);
                },
              );
            });
      }
    }

    return Stack(
      alignment: AlignmentDirectional.topCenter,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 15),
          decoration: const BoxDecoration(
              color: Color.fromARGB(255, 242, 242, 242),
              borderRadius: BorderRadius.all(Radius.circular(20))),
          height: 50,
          width: 400,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 35,
                    child: Text(
                      "${initTime}s",
                      style: ThemeText.chapter,
                      maxLines: 1,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Container(
                    height: 35,
                    width: 1,
                    color: const Color.fromARGB(255, 60, 64, 58),
                  )
                ],
              ),
              AppBarIcon(FontAwesomeIcons.question, () {
                _showDialog();
              }, Colors.purple),
              AppBarIcon(FontAwesomeIcons.lightbulb, () {
                _showHint();
                usedHint = true;
              }, Colors.amber),
              const SizedBox(
                height: 50,
                width: 50,
              ),
              AppBarIcon(FontAwesomeIcons.check, () async {
                if (widget.pick == widget.answer) {
                  widget.score++;
                  setState(() {
                    isStartTimer = true;
                    isCorrect = true;
                  });
                } else {
                  final player = AudioPlayer();
                  await player.play(AssetSource('wrong.wav'));
                  setState(() {
                    isCorrect = false;
                  });
                }
                _showResult();

                if (initTime < widget.timeLimit) {
                  widget.score++;
                }
                if (retries == 0) {
                  widget.score++;
                }
                if (!usedHint) {
                  widget.score++;
                }
              }, Colors.green),
              AppBarIcon(FontAwesomeIcons.repeat, () {}, Colors.grey),
              AppBarIcon(FontAwesomeIcons.x, () async {
                final player = AudioPlayer();
                await player.play(AssetSource('satisfying_click.wav'));
                Navigator.pop(context);
              }, Colors.red)
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 15),
          padding: const EdgeInsets.all(10),
          height: 80,
          width: 80,
          decoration: const BoxDecoration(
              color: Color.fromARGB(255, 242, 242, 242),
              borderRadius: BorderRadius.all(Radius.circular(60))),
          child: const Image(
              filterQuality: FilterQuality.high,
              image: AssetImage("images/characters/male_character.png")),
        )
      ],
    );
  }
}
