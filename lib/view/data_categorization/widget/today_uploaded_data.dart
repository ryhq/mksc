import 'package:flutter/material.dart';
import 'package:mksc/model/data.dart';
import 'package:mksc/provider/data_provider.dart';
import 'package:mksc/widgets/ball_pulse_indicator.dart';
import 'package:provider/provider.dart';

class TodayUploadedData extends StatefulWidget {
  final List<String> selectedCategories;
  final bool isLoadingTodayData;
  const TodayUploadedData({
    super.key, 
    required this.selectedCategories, 
    required this.isLoadingTodayData
  });

  @override
  State<TodayUploadedData> createState() => _TodayUploadedDataState();
}

class _TodayUploadedDataState extends State<TodayUploadedData> {
  final ScrollController _scrollController = ScrollController();
  bool reLoading = false;
  double _refreshIconOffset = -100;
  bool isAtTop = false;

  @override
  void initState() {
    // fetchTodayData();
    super.initState();
    // Add listener to the scroll controller
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Data> filteredTodayData =  Provider.of<DataProvider>(context).filteredData(widget.selectedCategories);
    List<Data> data =  Provider.of<DataProvider>(context).dataList;
    
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // widget.isLoadingTodayData ? const SizedBox() :
                
                // Text(
                //   "Today Uploaded Data (${filteredTodayData.length})",
                //   style: Theme.of(context).textTheme.bodyLarge,
                // ),
                
                widget.isLoadingTodayData ? const BallPulseIndicator() :
                data.isEmpty ? 
                Center(
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
                          await Provider.of<DataProvider>(context, listen: false).fetchTodayData(context);
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
                  itemCount: filteredTodayData.length,
                  itemBuilder: (BuildContext context, int index) {
                    var dat = filteredTodayData[index];
                    return Card(
                      elevation: 3,
                      shape: const  RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))
                      ),
                      child: ListTile(
                        title: Text(
                          dat.item,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          dat.id.toString(),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        trailing: Text(
                          dat.number,
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
            offset: Offset(0, isAtTop ? 0 : -100), // Move it out of the screen when not needed
            child: Opacity(
              opacity: isAtTop ? 1 : 0, // Fade in the refresh icon when at the top
              child: const BallPulseIndicator()
            ),
          ),
        )
      ],
    );
  }

  Future<void> fetchTodayData()async{
    await Provider.of<DataProvider>(context, listen: false).fetchTodayData(context);
    setState(() {
      // _isLoading = false;
    });
  }

  // Fetch data method to trigger data refresh
  Future<void> _fetchData() async {
    if (!reLoading) {
      setState(() {
        reLoading = true;
        _refreshIconOffset = -100;
      });

      await Provider.of<DataProvider>(context, listen: false).fetchTodayData(context);

      setState(() {
        reLoading = false;
      });
    }
  }
  
  void _onScroll() async {
    double scrollPosition = _scrollController.position.pixels;
    double minScrollExtent = _scrollController.position.minScrollExtent;

    // Check if at the top and adjust the offset and appearance of the refresh icon
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