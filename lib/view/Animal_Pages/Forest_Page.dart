// ignore_for_file: avoid_print

import 'dart:typed_data';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intro/flutter_intro.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:new_pro/controller/animal_Controller/Animal_Control.dart';
import '../../controller/animal_Controller/tap_controller.dart';
import '../../database/db_helper.dart';
import '../Ads/admob.dart';
import '../Widget/Description_screen.dart';
import '../Widget/theme/text.dart';

class Forest extends StatelessWidget {
  final int catId;
  final Uint8List imageBytes;

  const Forest({super.key, required this.imageBytes, required this.catId});

  @override
  Widget build(BuildContext context) {
    final ForestController controller = Get.put(ForestController(catId: catId, Image: imageBytes));
    final AdManager adManager = AdManager();
    CarouselController buttonController = CarouselController();
    final MyController myController = MyController();

    return Obx(() {
      if (!controller.isDataLoaded.isTrue) {
        return Scaffold(
          body: Stack(
            children: [
              const Positioned(
                child: Image(
                  image: AssetImage("assets/Home/BG.png"),
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
              Center(
                child: SizedBox(
                  height: 150,
                  width: 330,
                  child: Column(
                    children: [
                      const SizedBox(height: 50),
                      Center(
                        child: Text("Asset Downloading", style: AppTheme.droppedtitle),
                      ),
                      const SizedBox(height: 50),
                      SizedBox(
                        height: 5,
                        width: 320,
                        child: LinearProgressIndicator(value: controller.progressBarValue.value / 100),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      } else {
        return Scaffold(
          body: Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                child: Image.memory(
                  imageBytes,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 80,
                right: 270,
                child: controller.droppedImage.value != null
                    ? GestureDetector(
                  onTap: () {
                    myController.toggleVisibility();
                  },
                  child: Align(
                    alignment: Alignment.topRight,
                    child: SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.17,
                      width: MediaQuery.sizeOf(context).width * 0.10,
                      child: Image.asset("assets/Game/Language.png"),
                    ),
                  ),
                )
                    : Container(),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: SizedBox(
                  height: 410,
                  width: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Align(
                        alignment: const Alignment(-0.7, -0.1),
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Image.asset("assets/Setting/Arrowback.png", height: 40, width: 40,),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          buttonController.previousPage(duration: const Duration(milliseconds: 200), curve: Curves.linear);
                        },
                        child: IntroStepBuilder(
                          order: 1,
                          text: "drag to next target",
                          padding: const EdgeInsets.only(bottom: 2, top: 40),
                          borderRadius: BorderRadius.circular(50),
                          onWidgetLoad: () {
                            Intro.of(context).start();
                          },
                          builder: (context, key) => Align(
                            key: key,
                            alignment: const Alignment(-0.12, 0),
                            child: Image.asset("assets/Game/Up.png", height: 38, width: 38),
                          ),
                        ),
                      ),
                      ValueListenableBuilder(
                        valueListenable: myController.refresshNotifier,
                        builder: (context, value, child) {
                          return FutureBuilder<List<Map<String, dynamic>>>(
                            future: Future.delayed(const Duration(milliseconds: 100), () => DbHelper.dbHelper.getForestImageData(catId)),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                return const Center(child: Text('No data available'));
                              } else {
                                List<Map<String, dynamic>> forestImage = snapshot.data!;
                                return CarouselSlider.builder(
                                  itemCount: forestImage.length,
                                  itemBuilder: (context, index, realIndex) {
                                    final Uint8List imageBytes = forestImage[index]["Image"];
                                    final int ID = forestImage[index]["animalId"];
                                    controller.date.value = forestImage[index]["Date"];
                                    return Draggable(
                                      data: imageBytes,
                                      feedback: CircleAvatar(
                                        backgroundImage: const AssetImage("assets/Game/animal image.png"),
                                        radius: 45,
                                        child: Image.memory(imageBytes, fit: BoxFit.contain, width: 80, height: 80),
                                      ),
                                      onDragCompleted: () {
                                        controller.Dragimage(imageBytes, forestImage[index]['Title'], "", ID,);
                                        controller.DLanId.value;
                                      },
                                      child: GestureDetector(
                                        onTap: () async {
                                          if (index != 0 && index != 1 && index != 2) {
                                            if (controller.date.value != DateFormat('yyyy-MM-dd').format(DateTime.now())) {
                                              showDialog<void>(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    backgroundColor: const Color(0xffF1DEBE),
                                                    title: const Text('Watch Ads'),
                                                    content: const Text('you want to show ads'),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        style: TextButton.styleFrom(textStyle: Theme.of(context).textTheme.labelLarge),
                                                        onPressed: () {
                                                          Navigator.pop(context);
                                                        },
                                                        child: const Text('Cancel'),
                                                      ),
                                                      TextButton(
                                                        style: TextButton.styleFrom(textStyle: Theme.of(context).textTheme.labelLarge),
                                                        onPressed: () {
                                                          adManager.showRewardedAd();
                                                          controller.updateForestDate(ID, () {
                                                            controller.update();
                                                            myController.toggletherefresh();
                                                          });
                                                          Navigator.pop(context);
                                                        },
                                                        child: const Text('Watch'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            }
                                          }
                                        },
                                        child: Stack(
                                          children: [
                                            CircleAvatar(
                                              backgroundImage: const AssetImage("assets/Game/animal image.png"),
                                              radius: 45,
                                              child: Image.memory(imageBytes, fit: BoxFit.contain, width: 70, height: 70),
                                            ),
                                            if (index != 0 && index != 1 && index != 2)
                                              if (controller.date.value != DateFormat('yyyy-MM-dd').format(DateTime.now()))
                                                Positioned(
                                                  top: MediaQuery.of(context).size.height * 0.04,
                                                  left: MediaQuery.of(context).size.width * 0.03,
                                                  child: const Icon(Icons.lock, size: 40, color: Colors.white),
                                                ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  carouselController: buttonController,
                                  options: CarouselOptions(
                                    scrollDirection: Axis.vertical,
                                    viewportFraction: 0.35,
                                    enlargeFactor: 0.3,
                                    enlargeCenterPage: true,
                                    height: 273,
                                    initialPage: 1,
                                  ),
                                );
                              }
                            },
                          );
                        },
                      ),
                      InkWell(
                        onTap: () => buttonController.nextPage(duration: const Duration(milliseconds: 200), curve: Curves.linear),
                        child: Align(
                          alignment: const Alignment(-0.12, 0),
                          child: Image.asset("assets/Game/Down.png", height: 38, width: 38),
                        ),
                      ),
                      const SizedBox(height: 2),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 170,
                child: DragTarget(
                  builder: (BuildContext context, List<dynamic> accepted, List<dynamic> rejected) {
                    print("Drag target builder. Accepted: $accepted, Rejected: $rejected");
                    return SizedBox(
                      width: 250,
                      height: 250,
                      child: controller.droppedImage.value != null
                          ? SizedBox(
                        height: 200,
                        width: 200,
                        child: Image.memory(controller.droppedImage.value!, alignment: Alignment.bottomCenter),
                      )
                          : IntroStepBuilder(
                        order: 2,
                        text: "drop here",
                        padding: const EdgeInsets.only(left: 50, right: 80),
                        builder: (context, key) => Container(
                          key: key,
                          color: Colors.transparent,
                        ),
                      ),
                    );
                  },
                  onWillAccept: (data) {
                    if (controller.date.value != DateFormat('yyyy-MM-dd').format(DateTime.now())) {
                      return true;
                    } else {
                      return false;
                    }
                  },
                  onAccept: (data) {
                    print("Accepted: $data");
                    try {
                      Uint8List imageBytes = data as Uint8List;
                      controller.Dragimage(imageBytes, '', "", 1);
                    } catch (e) {
                      print("Error accepting dropped data: $e");
                    }
                  },
                ),
              ),

              Positioned(
                bottom: MediaQuery.sizeOf(context).height * 0.03,
                right: MediaQuery.sizeOf(context).width * 0.0,
                child: DragTarget(
                  builder: (BuildContext context, List<dynamic> accepted, List<dynamic> rejected) {
                    print("Drag target builder. Accepted: $accepted, Rejected: $rejected");
                    return SizedBox(
                      width: 340,
                      height: 370,
                      child: Stack(
                        children: [
                          controller.droppedImage.value != null
                              ? Positioned(
                            top: MediaQuery.sizeOf(context).height * 0.02,
                            right: MediaQuery.sizeOf(context).width * 0.0,
                            child: Container(
                              height: 360,
                              width: 300,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage("assets/Game/BG.png"),
                                  fit: BoxFit.contain,
                                ),
                              ),
                              child: Column(
                                children: [
                                  const SizedBox(height: 3),
                                  controller.droppedImage.value != null
                                      ? Align(
                                    alignment: Alignment.center,
                                    child: Text(controller.droppedTitle.value, style: AppTheme.droppedtitle),
                                  )
                                      : Container(),
                                  const SizedBox(height: 10),
                                  controller.droppedImage.value != null
                                      ? SizedBox(
                                    height: 290,
                                    width: 255,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Builder(
                                        builder: (context) {
                                          return ValueListenableBuilder<bool>(
                                            valueListenable: myController.languageChangedNotifier,
                                            builder: (context, languageChanged, child) {
                                              return FutureBuilder(
                                                future: Future.delayed(const Duration(milliseconds: 100), () {
                                                  int selectedIndex = controller.DLanId.value;
                                                  return controller.desc.value[selectedIndex]["description"];
                                                }),
                                                builder: (context, snapshot) {
                                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                                    return const Center(child: CircularProgressIndicator());
                                                  } else if (snapshot.hasError) {
                                                    return Text('Error: ${snapshot.error}');
                                                  } else {
                                                    controller.Descrip.value = snapshot.data ?? "";
                                                    return Stack(
                                                      children: [
                                                        ListView(
                                                          children: [
                                                            Text(
                                                              controller.Descrip.value,
                                                              overflow: TextOverflow.clip,
                                                              maxLines: 130,
                                                              style: const TextStyle(
                                                                color: Colors.black,
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    );
                                                  }
                                                },
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  )
                                      : Container(),
                                ],
                              ),
                            ),
                          )
                              : Container(),
                          Positioned(
                            bottom: 13,
                            right: 28,
                            child: controller.droppedImage.value != null
                                ? IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => NewScreen(
                                      description: controller.Descrip.value,
                                      title: controller.droppedTitle.value,
                                    ),
                                  ),
                                );
                              },
                              icon: Container(
                                height: 50,
                                width: 50,
                                color: const Color(0xffF9E5C5),
                                child: Padding(
                                  padding: const EdgeInsets.all(6),
                                  child: Image.asset(
                                    "assets/Home/read-more (1).png",
                                    height: 40,
                                    width: 40,
                                  ),
                                ),
                              ),
                            )
                                : Container(),
                          ),
                          Positioned(
                            top: 50,
                            right: 30,
                            child: ValueListenableBuilder<bool>(
                              valueListenable: myController.isAlgContainerVisible,
                              builder: (context, isVisible, child) {
                                return Visibility(
                                  visible: isVisible,
                                  child: Container(
                                    height: 290,
                                    width: 240,
                                    decoration: BoxDecoration(
                                      image: const DecorationImage(
                                        image: AssetImage("assets/Game/Top BG for Language.png"),
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ListView.builder(
                                      itemCount: controller.desc.value.length,
                                      itemBuilder: (context, index) {
                                        String title = controller.desc.value[index]["title"];
                                        return Column(
                                          children: [
                                            TextButton(
                                              onPressed: () {
                                                controller.changeLanguage(index);
                                                myController.notifyLanguageChanged();
                                                myController.toggleVisibility();
                                              },
                                              child: Text(
                                                title,
                                                style: AppTheme.droppedtitle,
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  onWillAccept: (data) {
                    print("Will accept: $data");
                    return true;
                  },
                  onAccept: (data) {
                    print("Accepted: $data");
                    try {
                      Uint8List imageBytes = data as Uint8List;
                      controller.Dragimage(imageBytes, '', "", 1);
                    } catch (e) {
                      print("Error accepting dropped data: $e");
                    }
                  },
                ),
              ),
            ],
          ),
        );
      }
    });
  }
}
