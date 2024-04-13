import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tv_streaming/models/channel.dart';
import 'package:dart_date/dart_date.dart';
import 'package:tv_streaming/models/program.dart';
import 'package:tv_streaming/widgets/loader_modal.dart';

class ProgrammingGuide extends StatelessWidget {
  final List<Channel> channels;
  final DateTimeRange selectedRange;
  final void Function(Channel) onChannelChanged;
  final bool isLoading;

  const ProgrammingGuide({
    this.isLoading=false,
    this.channels,
    this.selectedRange,
    this.onChannelChanged,
    Key key,
  }) : super(key: key);

  final double channelNumberWidth = 50.0;

  double getCarouselSize(screenWidth) {
    return (screenWidth - channelNumberWidth);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final carouselSize = getCarouselSize(size.width);
    final theme = Theme.of(context);

    return Stack(
      children: [
        Container(
          width: size.width,
          child: ListView.builder(
            itemCount: channels != null ? channels.length : 0,
            itemBuilder: (context, index) {
              List<Program> filteredPrograms = channels[index].programs != null
                  ?
                  channels[index].programs.where((item) =>
                          item.dateStart.isBefore(selectedRange.end) &&
                          item.dateEnd.isAfter(selectedRange.start) )
                      .toList()
                  : [];

              return Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: theme.primaryColor,
                      border: Border.all(
                        color: Colors.white24,
                      ),
                    ),
                    width: channelNumberWidth,
                    height: 40,
                    child: FlatButton(
                      padding: EdgeInsets.all(0),
                      onPressed: () {
                        onChannelChanged(channels[index]);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            channels[index].number,
                            style: TextStyle(color: Colors.white, fontSize: 10.0),
                          ),
                          (channels[index].image!=null)?Image.network(
                            channels[index].image,
                            height: 15.0,
                          ):Container(),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: carouselSize,
                    height: 40,
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
                        final itemWidth = carouselSize * (minutesInRange / rangeDuration);
                        return Container(
                          height: 40,
                          width: itemWidth,
                          decoration: BoxDecoration(
                            color: theme.primaryColor,
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
                ],
              );
            },
          ),
        ),
        isLoading ? LoaderModal() : Container()
      ],
    );
  }
}
