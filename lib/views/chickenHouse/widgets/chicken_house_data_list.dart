import 'package:flutter/material.dart';
import 'package:mksc/model/chicken_house_data.dart';
import 'package:mksc/providers/chicken_house_provider.dart';
import 'package:mksc/providers/theme_provider.dart';
import 'package:mksc/views/chickenHouse/widgets/chicken_house_data_card.dart';
import 'package:mksc/widgets/ball_pulse_indicator.dart';
import 'package:provider/provider.dart';

class ChickenHouseDataList extends StatefulWidget {
  final String title;
  final String date;
  const ChickenHouseDataList({
    super.key, 
    required this.title, 
    required this.date
  });

  @override
  State<ChickenHouseDataList> createState() => _ChickenHouseDataListState();
}

class _ChickenHouseDataListState extends State<ChickenHouseDataList> {

  @override
  Widget build(BuildContext context) {
    final chickenHouseProviderListenTrue = Provider.of<ChickenHouseProvider>(context);
    bool isFetchingChickenHouseData = chickenHouseProviderListenTrue.isFetchingChickenHouseData;
    List<ChickenHouseData> chickenHouseDataList = chickenHouseProviderListenTrue.chickenHouseDataList;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          widget.date == DateTime.now().toString().split(' ')[0] ? "Today's Chicken House Data" : "Chicken House Data on ${widget.date}",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(
          height: 21,
        ),
        isFetchingChickenHouseData ? const BallPulseIndicator() :
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            chickenHouseDataList.isEmpty ? 
            SizedBox(
              height: chickenHouseDataList.isEmpty ? MediaQuery.of(context).size.height * 0.5 : MediaQuery.of(context).size.height * 0.2,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Sorry, no chicken house data available on ${widget.date}",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
                  ),
                  IconButton(
                    onPressed: () {
                      fetchChickenHousesLocalDataByDate();
                    },
                    tooltip: 'Reload',
                    icon: Icon(
                      Icons.refresh,
                      size: Provider.of<ThemeProvider>(context).fontSize + 21,
                      color: Theme.of(context).colorScheme.primary,
                    )
                  )
                ],
              ),
            ) 
            :
            ListView.builder(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              reverse: true,
              itemCount: chickenHouseDataList.length,
              itemBuilder: (BuildContext context, int index) {
                var chickenHouseData = chickenHouseDataList[index];
                return ChickenHouseDataCard(
                  chickenHouseData: chickenHouseData, 
                  date: widget.date,
                  title: widget.title,
                );
              },
            ), 
          ],
        )
      ],
    );
  }

  void fetchChickenHousesLocalDataByDate() async{
    final chickenHouseProviderListenFalse = Provider.of<ChickenHouseProvider>(context, listen: false);
    await chickenHouseProviderListenFalse.fetchChickenHouseDataOnlineAndOffline(
      context: context, 
      date: widget.date,
      title: widget.title
    );
  }
}