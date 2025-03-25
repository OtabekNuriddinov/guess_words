import 'package:flutter/material.dart';
import 'package:guess_words/core/theme/dimens.dart';
import 'package:guess_words/core/theme/icons.dart';
import 'package:guess_words/core/theme/strings.dart';
import 'package:guess_words/core/theme/text_styles.dart';
import 'package:guess_words/core/utils/app_dialog.dart';
import 'package:guess_words/core/widgets/description_container.dart';
import 'package:guess_words/core/widgets/options_container.dart';
import 'package:guess_words/models/charade.dart';
import 'package:guess_words/services/app_service.dart';
import 'package:just_audio/just_audio.dart';
import '../core/widgets/my_image_container.dart';
import '../core/widgets/my_wrap.dart';
import '/core/theme/colors.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/services.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late AppService appService;
  late Future<void> _dataFuture;
  String animationPath = "assets/animation/well_anim.json";

  late List<GameData> questions;
  GameData? currentQuestion;
  int level = 1;
  int sanoq = 0;
  bool isChecked = false;

  /// kerak bo'ladigan listlar
  List<String?> placedLetters = [];
  List<String> leftLetters = [];
  List<String> rightLetters = [];
  List<Color> leftSpaceColors = [];
  List<Color> rightSpaceColors = [];
  List<Color> middleSpaceColors = [];
  List <Color>originalList = [];
  List<String> letters = [];

  @override
  void initState() {
    super.initState();
    appService = AppService();
    _dataFuture = _loadData();
  }

  Future<void> _loadData() async {
    await appService.initialize();
    if (appService.items.isNotEmpty) {
      setState(() {
        currentQuestion = appService.items.first;
        AppService.initializeLetters(currentQuestion, leftLetters, rightLetters, leftSpaceColors, rightSpaceColors, middleSpaceColors, originalList, placedLetters);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _floatingActionButton(),
      backgroundColor: AppColors.white,
      appBar: _appBar(),
      body: FutureBuilder<void>(
          future: _dataFuture,
          builder: (context, _) {
            if (appService.items.isEmpty) {
              return Center(child: CircularProgressIndicator());
            }
            letters = currentQuestion!.letters;
            List<String> dragLetters = currentQuestion!.word.split("");
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Column(
                children: [
                  Stack(children: [
                    MyImageContainer(
                        currentQuestion: currentQuestion,
                        leftLetters: leftLetters,
                        rightLetters: rightLetters),
                    if (isChecked)
                      Align(
                        alignment: const Alignment(0, -0.3),
                        child: SizedBox(
                          width: AppDimens.d310,
                          height: AppDimens.d170,
                          child: Lottie.asset("assets/animation/well_anim.json",
                              fit: BoxFit.cover),
                        ),
                      ),
                  ]),
                  AppDimens.h30,
                  DescriptionContainer(currentQuestion: currentQuestion),
                  OptionsContainer(
                      dragLetters: dragLetters, 
                      word: currentQuestion!.word, 
                      currentLeft: AppService.getColorFromInt(currentQuestion!.left.color), 
                      currentRight: AppService.getColorFromInt(currentQuestion!.right.color), 
                      placedLetters: placedLetters, 
                      originalList: originalList,
                      leftSpaceColors: leftSpaceColors,
                      rightSpaceColors: rightSpaceColors,
                      middleSpaceColors: middleSpaceColors,
                      onAccept: (data, index){
                        setState(() {
                          if(placedLetters[index]==null){
                            placedLetters[index] = data;
                          }
                          checking();
                        });
                      },
                  ),
                  AppDimens.h30,
                  MyWrap(letters: letters),
                ],
              ),
            );
          }),
    );
  }

  FloatingActionButton _floatingActionButton() {
    return FloatingActionButton(
      onPressed: nextQuestion,
      child: Icon(Icons.arrow_forward),
    );
  }

  AppBar _appBar() {
    return AppBar(
      backgroundColor: AppColors.white,
      leading: Padding(
        padding: AppDimens.p105,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(AppStrings.level, style: AppTextStyles.level),
            Text(level.toString(), style: AppTextStyles.levelCount),
          ],
        ),
      ),
      title: Padding(
        padding: const EdgeInsets.only(left: 120),
        child: Container(
          width: AppDimens.d130,
          height: AppDimens.d32,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey.shade300),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.monetization_on, color: AppColors.yellow800),
                SizedBox(width: 15),
                Text(currentQuestion?.coin.toString() ?? "0")
              ],
            ),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: AppDimens.pO10R,
          child: IconButton(onPressed: replay, icon: AppIcons.replay),
        )
      ],
    );
  }

  void replay() {
    setState(() {
      isChecked = false;
      placedLetters = List.of(List.filled(originalList.length, null));
      letters.shuffle();
      currentQuestion = appService.items[sanoq];

    });
  }

  void checking(){
    if (!placedLetters.contains(null)) {
      if (placedLetters.join("") == currentQuestion!.word) {
        isChecked = true;
        AppService.playWin();
        Future.delayed(Duration(seconds: 5), () {
          if(mounted) {
            AppDialog.showMyDialog(
              currentQuestion!.imageUrl,
              nextQuestion,
              currentQuestion!.word,
                  (){
                AppService.initializeLetters(currentQuestion, leftLetters, rightLetters, leftSpaceColors, rightSpaceColors, middleSpaceColors, originalList, placedLetters);
              },
              context,
            );
          }
        });
      } else {
        AppService.playWrong();
        replay();
        letters.shuffle();
      }
    }
  }

  void nextQuestion() {
    setState(() {
      if (sanoq < appService.items.length - 1) {
        sanoq++;
        level++;
        currentQuestion = appService.items[sanoq];
        AppService.initializeLetters(currentQuestion, leftLetters, rightLetters, leftSpaceColors, rightSpaceColors, middleSpaceColors, originalList, placedLetters);
        isChecked = false;
      }
    });
  }
}
