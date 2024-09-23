import 'package:flutter/material.dart';
import 'package:mksc/model/population_data.dart';
import 'package:mksc/provider/data_provider.dart';
import 'package:mksc/widgets/ball_pulse_indicator.dart';
import 'package:provider/provider.dart';

class PopulationDataWidget extends StatefulWidget {

  final List<String> selectedCategories;
  const PopulationDataWidget({super.key, required this.selectedCategories});

  @override
  State<PopulationDataWidget> createState() => _PopulationDataState();
}

class _PopulationDataState extends State<PopulationDataWidget> {  
  final ScrollController _scrollController = ScrollController();
  bool reLoading = false;
  double _refreshIconOffset = -100;
  bool isAtTop = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<PopulationData> populationData = Provider.of<DataProvider>(context).populationData;
    List<PopulationData> filteredPopulationData = Provider.of<DataProvider>(context).filteredPopulationData(widget.selectedCategories);

    return Stack(
      children: [
        NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollNotification) {
            if (scrollNotification is ScrollEndNotification && _scrollController.position.pixels == _scrollController.position.minScrollExtent) {
              _fetchData();
            }
            return false;
          },
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                populationData.isEmpty ? Center(
                  child: Column(
                    children: [
                      Text(
                        'No data available',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      reLoading ? const BallPulseIndicator() : 
                      IconButton(
                        onPressed: () async{
                          setState(() {
                            reLoading = true;
                          });
                          await Provider.of<DataProvider>(context, listen: false).fetchPopulationData(context);
                          setState(() {
                            reLoading = false;
                          });
                        }, 
                        icon: Icon(
                          Icons.refresh,
                          color: Theme.of(context).colorScheme.primary,
                        )
                      )
                    ],
                  )
                ):
                reLoading ? const BallPulseIndicator() :
                ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  reverse: true,
                  itemCount: filteredPopulationData.length,
                  itemBuilder: (BuildContext context, int index) {
                    var data = filteredPopulationData[index];
                    return Card(
                      elevation: 0,
                      color: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: const  BorderRadius.all(Radius.circular(8)),
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                        )
                      ),
                      child: ListTile(
                        tileColor: Colors.transparent,
                        title: Text(
                          "${data.item[0].toUpperCase()}${data.item.replaceFirst(RegExp(data.item[0]), '',)}",
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          data.month,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        trailing: Text(
                          data.total.toString(),
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: _refreshIconOffset,
          left: MediaQuery.of(context).size.width / 2 - 24,
          child: Transform.translate(
            offset: Offset(0, isAtTop ? 0 : -100), 
            child: Opacity(
              opacity: isAtTop ? 1 : 0, 
              child: const BallPulseIndicator()
            ),
          ),
        )
      ],
    );
  }
  Future<void> _fetchData() async {
    if (!reLoading) {
      setState(() {
        reLoading = true;
        _refreshIconOffset = -100;
      });

      await Provider.of<DataProvider>(context, listen: false).fetchPopulationData(context);

      setState(() {
        reLoading = false;
      });
    }
  }
  
  void _onScroll() async {
    double scrollPosition = _scrollController.position.pixels;
    double minScrollExtent = _scrollController.position.minScrollExtent;
    
    if (scrollPosition <= minScrollExtent) {
      setState(() {
        isAtTop = true;
        _refreshIconOffset = (minScrollExtent - scrollPosition) / 2;
      });
    } else {
      setState(() {
        isAtTop = false;
        _refreshIconOffset = -100;
      });
    }
  }
}