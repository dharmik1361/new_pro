import 'package:flutter/material.dart';
import 'package:flutter_intro/flutter_intro.dart';


class MyApp1 extends StatelessWidget {
  const MyApp1({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const StartPage(),
    );
  }
}

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Intro'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => Intro(
                      padding: EdgeInsets.zero,
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                      maskColor: const Color.fromRGBO(0, 0, 0, .6),
                      child: const DemoUsage(),
                    ),
                  ),
                );
              },
              child: const Text('Demo'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => Intro(
                      buttonTextBuilder: (order) =>
                      order == 3 ? 'Custom Button Text' : 'Next',
                      child: const SimpleUsage(),
                    ),
                  ),
                );
              },
              child: const Text('Simple Usage'),
            ),
            ElevatedButton(
              child: const Text('Advanced Usage'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => Intro(
                      maskClosable: true,
                      child: const AdvancedUsage(),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}


class SimpleUsage extends StatelessWidget {
  const SimpleUsage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(
            16,
          ),
          child: Center(
            child: Column(
              children: [
                IntroStepBuilder(
                  order: 2,
                  text:
                  'Use IntroStepBuilder to wrap the widget you need to guide.'
                      ' Add the necessary order to it, and then add the key in the builder method to the widget.',
                  builder: (context, key) => Text(
                    'Tap the floatingActionButton to start.',
                    key: key,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                IntroStepBuilder(
                  order: 3,
                  text:
                  'If you need more configuration, please refer to Advanced Usage.',
                  builder: (context, key) => Text(
                    'And you can use `buttonTextBuilder` to set the button text.',
                    key: key,
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: IntroStepBuilder(
          order: 1,
          text: 'OK, let\'s start.',
          builder: (context, key) => FloatingActionButton(
            key: key,
            child: const Icon(
              Icons.play_arrow,
            ),
            onPressed: () {
              Intro.of(context).start();
            },
          ),
        ),
      ),
      onWillPop: () async {
        Intro intro = Intro.of(context);

        if (intro.status.isOpen == true) {
          intro.dispose();
          return false;
        }
        return true;
      },
    );
  }
}


class AdvancedUsage extends StatefulWidget {
  const AdvancedUsage({super.key});

  @override
  State<AdvancedUsage> createState() => _AdvancedUsageState();
}

class _AdvancedUsageState extends State<AdvancedUsage> {
  bool rendered = false;
  bool canPop = false;

  @override
  Widget build(BuildContext context) {
    Intro intro = Intro.of(context);
    bool isOpen = intro.status.isOpen;

    return PopScope(
      canPop: !isOpen || canPop,


      onPopInvoked: (didPop) {
        if (!didPop && isOpen) {
          intro.dispose();
          setState(() {
            canPop = true;
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IntroStepBuilder(
                  /// 2nd guide
                  order: 2,
                  overlayBuilder: (params) {
                    return Container(
                      color: Colors.teal,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          params.onNext == null
                              ? const Column(
                            children: [
                              Text(
                                'Of course, you can also render what you want through overlayBuilder.',
                                style: TextStyle(height: 1.6),
                              ),
                              Text(
                                'In addition, we can finally add new guide widget dynamically.',
                                style: TextStyle(height: 1.6),
                              ),
                              Text(
                                'Click highlight area to add new widget.',
                                style: TextStyle(height: 1.6),
                              )
                            ],
                          )
                              : const Text(
                              'As you can see, you can move on to the next step'),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 16,
                            ),
                            child: Row(
                              children: [
                                IntroButton(
                                  text: 'Prev',
                                  onPressed: params.onPrev,
                                ),
                                const SizedBox(width: 4),
                                IntroButton(
                                  text: 'Next',
                                  onPressed: params.onNext,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  onHighlightWidgetTap: () {
                    setState(() {
                      rendered = true;
                    });
                  },
                  builder: (context, key) => Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Placeholder(
                        key: key,
                        fallbackWidth: 100,
                        fallbackHeight: 100,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                rendered
                    ? IntroStepBuilder(
                  order: 3,
                  onWidgetLoad: () {
                    Intro.of(context).refresh();
                  },
                  overlayBuilder: (params) {
                    return Container(
                      padding: const EdgeInsets.all(16),
                      color: Colors.teal,
                      child: Column(
                        children: [
                          const Text(
                            'That\'s it, hopefully version 3.0 makes you feel better than 2.0',
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 16,
                            ),
                            child: Row(
                              children: [
                                IntroButton(
                                  onPressed: params.onPrev,
                                  text: 'Prev',
                                ),
                                const SizedBox(width: 4),
                                IntroButton(
                                  onPressed: params.onNext,
                                  text: 'Next',
                                ),
                                const SizedBox(width: 4),
                                IntroButton(
                                  onPressed: params.onFinish,
                                  text: 'Finish',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  builder: (context, key) => Text(
                    'I am a delay render widget.',
                    key: key,
                  ),
                )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        ),
        floatingActionButton: IntroStepBuilder(
          /// 1st guide
          order: 1,
          text:
          'Some properties on IntroStepBuilder like `borderRadius` `padding`'
              ' allow you to configure the configuration of this step.',
          padding: const EdgeInsets.symmetric(
            vertical: -5,
            horizontal: -5,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(64)),
          builder: (context, key) => FloatingActionButton(
            key: key,
            child: const Icon(
              Icons.play_arrow,
            ),
            onPressed: () {
              Intro.of(context).start();

              /// Make the component re-render and get the correct isOpen value
              setState(() {});
            },
          ),
        ),
      ),
    );
  }
}


class DemoUsage extends StatefulWidget {
  const DemoUsage({super.key});

  @override
  State<DemoUsage> createState() => _DemoUsageState();
}

class _DemoUsageState extends State<DemoUsage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 100,
              child: IntroStepBuilder(
                order: 2,
                text:
                'I can help you quickly implement the Step By Step guide in the Flutter project.',
                builder: (context, key) => Placeholder(
                  key: key,
                  fallbackHeight: 100,
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            IntroStepBuilder(
              order: 3,
              text:
              'My usage is also very simple, you can quickly learn and use it through example and api documentation.',
              builder: (context, key) => Placeholder(
                key: key,
                fallbackHeight: 100,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            label: 'Home',
            icon: IntroStepBuilder(
              order: 1,
              text: 'Welcome to flutter_intro',
              padding: const EdgeInsets.only(
                bottom: 20,
                left: 16,
                right: 16,
                top: 8,
              ),
              onWidgetLoad: () {
                Intro.of(context).start();
              },
              builder: (context, key) => Icon(
                Icons.home,
                key: key,
              ),
            ),
          ),
          const BottomNavigationBarItem(
            label: 'Book',
            icon: Icon(Icons.book),
          ),
          const BottomNavigationBarItem(
            label: 'School',
            icon: Icon(Icons.school),
          ),
        ],
      ),
    );
  }
}