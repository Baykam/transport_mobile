part of '../home.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key, required this.loads, required this.secondLoads});
  final List<SimpleLoad> loads;
  final List<SimpleLoad2> secondLoads;
  @override
  Widget build(BuildContext context) {
    bool isSecond = secondLoads.isNotEmpty;
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: isSecond ? secondLoads.length : loads.length,
            itemBuilder: (BuildContext context, int index) {
              return SimpleLoadMain(
                  simpleLoads: loads[index],
                  onPressed: (load) {
                    context.pushNamed(
                        AppPath.loadDetail.name,
                        pathParameters: {'id' : load?.id ?? 0.toString()},
                      extra: {
                          "load": load,
                      }
                    );
                  },
                );
              },
          ),
        ),
      ],
    );
  }
}
