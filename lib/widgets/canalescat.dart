import 'package:dart_date/src/dart_date.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tv_streaming/constants.dart';
import 'package:tv_streaming/models/channel.dart';
import 'package:tv_streaming/models/program.dart';
import 'package:tv_streaming/providers/programming_provider.dart';
import 'package:tv_streaming/widgets/loader_modal.dart';
import 'package:tv_streaming/widgets/popup_menu.dart';

class Canalescat extends StatelessWidget {
  final List<Channel> channels;
  final DateTimeRange selectedRange;
  final void Function(Channel) onChannelChanged;
  final bool isLoading;

  const Canalescat({
    this.isLoading = false,
    this.channels,
    this.selectedRange,
    this.onChannelChanged,
    Key key,
  }) : super(key: key);

  final double channelNumberWidth = 70.0;

  double getCarouselSize(screenWidth) {
    return (screenWidth - channelNumberWidth);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final carouselSize = getCarouselSize(size.width);
    final theme = Theme.of(context);
    final programmingProvider = Provider.of<ProgrammingProvider>(context);

    return Stack(
      children: [
        Consumer<ProgrammingProvider>(
          builder: (context, programmingProvider, child) {
            return Container(
              width: size.width,
              child: ListView.builder(
                itemCount: programmingProvider.categories != null ? programmingProvider.categories.length : 0,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  programmingProvider.categories.sort((a, b) => a.order.compareTo(b.order));

                  return Row(
                    children: [

                      Padding(
                        padding: const EdgeInsets.only(left: 7.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: epgColor,
                              border: Border.all(
                                color: Colors.white54,
                              ),
                              gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end:Alignment.bottomCenter,
                                  colors: [
                                    startcolor,
                                    epgColor

                                  ]
                              )
                          ),
                          width: 70,
                          height: 70,
                          child: FlatButton(
                            padding: EdgeInsets.all(0),
                            onPressed: () {
                              if(programmingProvider.categories[index].name=="Todos"){
                                programmingProvider.getChannelsByCategory(
                                    context, "0");
                              }else{
                              programmingProvider.getChannelsByCategory(
                                  context, programmingProvider.categories[index].id.toString());
                            }
                              },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Center(
                                  child: Text(
                                    programmingProvider.categories[index].name.toString(),
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 10.0),
                                  ),
                                ),
                                (programmingProvider.categories[index].image != null)
                                    ? Image.network(
                                  programmingProvider.categories[index].image,
                                  height: 30.0,
                                  fit: BoxFit.contain,
                                )
                                    : Container(),
                              ],
                            ),
                          ),
                        ),
                      ),
                      /*
                  Container(
                    width: carouselSize,
                    height: 60,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: filteredPrograms.length,
                      itemBuilder: (context, i) {
                        final rangeDuration = selectedRange.end
                            .differenceInSeconds(selectedRange.start);
                        final startsOut = filteredPrograms[i]
                            .dateStart
                            .isBefore(selectedRange.start);
                        final endsOut = filteredPrograms[i]
                            .dateEnd
                            .isAfter(selectedRange.end);

                        int minutesInRange = 10;
                        if (startsOut && endsOut) {
                          minutesInRange = rangeDuration;
                        } else if (startsOut) {
                          minutesInRange = filteredPrograms[i]
                              .dateEnd
                              .differenceInSeconds(selectedRange.start);
                        } else if (endsOut) {
                          minutesInRange = selectedRange.end
                              .differenceInSeconds(
                                  filteredPrograms[i].dateStart);
                        } else {
                          minutesInRange = filteredPrograms[i]
                              .dateEnd
                              .differenceInSeconds(
                                  filteredPrograms[i].dateStart);
                        }
                        final itemWidth =
                            carouselSize * (minutesInRange / rangeDuration);
                        return Container(
                          height: 40,
                          width: itemWidth,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: detalleColor,
                            border: Border.all(
                              color: Colors.white24,
                            ),
                          ),
                          child: FlatButton(
                            onPressed: () {},
                            child: Center(
                              child: Text(
                                filteredPrograms[i].title,
                                style: TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )

                   */
                    ],
                  );
                },
              ),
            );
          },
        ),

        isLoading ? LoaderModal() : Container()
      ],
    );
  }
}
