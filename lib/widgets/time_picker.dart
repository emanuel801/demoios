import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dart_date/dart_date.dart';
import 'package:provider/provider.dart';
import 'package:tv_streaming/models/category.dart';
import 'package:tv_streaming/models/channel.dart';
import 'package:tv_streaming/providers/programming_provider.dart';
import 'package:tv_streaming/widgets/popup_menu.dart';

class TimePicker extends StatefulWidget {
  final void Function(DateTimeRange) onTimeRangeChanged;
  final List<DateTime> times;
  final int initialPage;
  final Channel selectedChannel;
  TimePicker({
    this.onTimeRangeChanged,
    this.times,
    this.initialPage,
    this.selectedChannel,
    Key key,
  }) : super(key: key);

  @override
  _TimePickerState createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  DateTime currentDay;

  final _controller = ScrollController();

  ScrollPhysics _physics;

  int currentPage;

  bool scrollControllerLoaded = false;

  final double currentDayContainerWidth = 90.0;

  double getCarouselSize(screenWidth) {
    return (screenWidth - currentDayContainerWidth);
  }

  @override
  void initState() {
    super.initState();
    currentPage = widget.initialPage;
    currentDay = widget.times[currentPage];

    _controller.addListener(() {
      if (_controller.position.haveDimensions && _physics == null) {
        final size = MediaQuery.of(context).size;
        final carouselSize = getCarouselSize(size.width);
        setState(() {
          scrollControllerLoaded = true;
          var dimension = carouselSize / 4;
          _physics = CustomScrollPhysics(
              itemDimension: dimension, onPageChanged: handlePageChange);
          _controller.jumpTo(dimension * currentPage);
        });
      }
    });
  }

  void handlePageChange(int page) {
    final selectedIndex = page > currentPage ? page + 1 : page;
    widget.onTimeRangeChanged(
      DateTimeRange(
          start: widget.times[selectedIndex],
          end: widget.times[selectedIndex + 4]),
    );
    currentPage = page;

    if (widget.times[currentPage].day != currentDay.day) {
      setState(() {
        currentDay = widget.times[currentPage];
      });
    }
  }

  void handlePreviousPage(double carouselSize) {
    final itemDimension = carouselSize / 4;
    final page = _controller.position.pixels ~/ itemDimension;
    final selectedIndex = page - 1;
    widget.onTimeRangeChanged(
      DateTimeRange(
        start: widget.times[selectedIndex],
        end: widget.times[selectedIndex + 4],
      ),
    );
    if (page >= 0) {
      currentPage -= 1;
      _controller.animateTo(
        carouselSize / 4 * (page - 1),
        curve: Curves.easeOut,
        duration: Duration(milliseconds: 300),
      );
      if (widget.times[currentPage].day != currentDay.day) {
        setState(() {
          currentDay = widget.times[currentPage];
        });
      }
    }
  }

  void handleNextPage(double carouselSize) {
    final itemDimension = carouselSize / 4;
    final page = _controller.position.pixels ~/ itemDimension;
    final selectedIndex = page + 1;
    if (currentPage < widget.times.length - 1) {
      widget.onTimeRangeChanged(
        DateTimeRange(
            start: widget.times[selectedIndex],
            end: widget.times[selectedIndex + 4]),
      );
      currentPage += 1;
      _controller.animateTo(
        _controller.position.pixels + itemDimension,
        curve: Curves.easeOut,
        duration: Duration(milliseconds: 300),
      );
      if (widget.times[currentPage].day != currentDay.day) {
        setState(() {
          currentDay = widget.times[currentPage];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final carouselSize = getCarouselSize(size.width);
    final theme = Theme.of(context);

    return Stack(
      children: [
        Column(
          children: [
            Container(
              color: theme.primaryColorDark,
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  widget.selectedChannel != null
                      ? Text(
                          '${widget.selectedChannel.number} | ${widget.selectedChannel.name}',
                          style: TextStyle(color: Colors.white),
                        )
                      : Container(),
                  Row(
                    children: [
                      Consumer<ProgrammingProvider>(
                        builder: (context, programmingProvider, child) {
                          return PopupMenu(
                            onSelected: (id) {
                              // if(id==0){ id=null; }
                              // final Category selectedCategory =
                              //     programmingProvider.categories.firstWhere(
                              //         (element) => element.order == orden,
                              //         orElse: () => null);

                              programmingProvider.getChannelsByCategory(
                                  context, id.toString());
                            },
                            options: [
                              OptionMenu(
                                label: 'Todos',
                                value: 0,
                              ),
                              ...programmingProvider.categories
                                  .map((category) => OptionMenu(
                                        label: category.name,
                                        value: category.id,
                                      ))
                                  .toList()
                            ],
                          );
                        },
                      ),
                      SizedBox(
                        height: 18.0,
                        width: 26.0,
                        child: IconButton(
                          padding: EdgeInsets.all(0.0),
                          icon: Icon(
                            Icons.arrow_back_ios,
                            size: 18.0,
                            color: Colors.white,
                          ),
                          onPressed: () => handlePreviousPage(carouselSize),
                        ),
                      ),
                      SizedBox(
                        height: 18.0,
                        width: 26.0,
                        child: IconButton(
                          padding: EdgeInsets.all(0.0),
                          icon: Icon(
                            Icons.arrow_forward_ios,
                            size: 18.0,
                            color: Colors.white,
                          ),
                          onPressed: () => handleNextPage(carouselSize),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: theme.primaryColor,
                    border: Border.all(
                      color: Colors.white,
                    ),
                  ),
                  width: currentDayContainerWidth,
                  height: 40,
                  child: Center(
                    child: Text(
                      currentDay?.format("dd/MM"),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Container(
                  width: carouselSize,
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    controller: _controller,
                    physics: _physics,
                    itemCount: widget.times.length,
                    itemBuilder: (context, index) => Container(
                      height: 40,
                      width: carouselSize / 4,
                      decoration: BoxDecoration(
                        color: theme.primaryColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.white,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          widget.times[index]?.format("h:mm a"),
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class CustomScrollPhysics extends ScrollPhysics {
  final double itemDimension;
  final void Function(int) onPageChanged;

  CustomScrollPhysics(
      {this.itemDimension, this.onPageChanged, ScrollPhysics parent})
      : super(parent: parent);

  @override
  CustomScrollPhysics applyTo(ScrollPhysics ancestor) {
    return CustomScrollPhysics(
        itemDimension: itemDimension,
        parent: buildParent(ancestor),
        onPageChanged: onPageChanged);
  }

  double _getPage(ScrollPosition position) {
    return position.pixels / itemDimension;
  }

  double _getPixels(double page) {
    return page * itemDimension;
  }

  double _getTargetPixels(
      ScrollPosition position, Tolerance tolerance, double velocity) {
    double page = _getPage(position);
    if (velocity < -tolerance.velocity) {
      page -= 0.5;
    } else if (velocity > tolerance.velocity) {
      page += 0.5;
    }
    return _getPixels(page.roundToDouble());
  }

  @override
  Simulation createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    // If we're out of range and not headed back in range, defer to the parent
    // ballistics, which should put us back in range at a page boundary.
    if ((velocity <= 0.0 && position.pixels <= position.minScrollExtent) ||
        (velocity >= 0.0 && position.pixels >= position.maxScrollExtent)) {
      return super.createBallisticSimulation(position, velocity);
    }
    final Tolerance tolerance = this.tolerance;
    final double target = _getTargetPixels(position, tolerance, velocity);

    if (target != position.pixels) {
      onPageChanged(_getPage(position).toInt());
      return ScrollSpringSimulation(spring, position.pixels, target, velocity,
          tolerance: tolerance);
    }
    return null;
  }

  @override
  bool get allowImplicitScrolling => false;
}
