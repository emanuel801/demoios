import 'package:dart_date/src/dart_date.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tv_streaming/constants.dart';
import 'package:tv_streaming/models/channel.dart';
import 'package:tv_streaming/models/program.dart';
import 'package:tv_streaming/providers/programming_provider.dart';
import 'package:tv_streaming/widgets/loader_modal.dart';
import 'package:tv_streaming/widgets/popup_menu.dart';

class Canalesmat extends StatelessWidget {
  final List<Channel> channels;
  final DateTimeRange selectedRange;
  final void Function(Channel) onChannelChanged;
  final bool isLoading;

  const Canalesmat({
    this.isLoading = false,
    this.channels,
    this.selectedRange,
    this.onChannelChanged,
    Key key,
  }) : super(key: key);

  final double channelNumberWidth = 90.0;

  double getCarouselSize(screenWidth) {
    return (screenWidth - channelNumberWidth);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final carouselSize = getCarouselSize(size.width);
    final theme = Theme.of(context);
    final programmingProvider = Provider.of<ProgrammingProvider>(context);

    var canales = programmingProvider.programmingGuide;
    String primeraCategoria = canales.isNotEmpty ? canales.first.categoryName.toString() : "";

    if(canales.every((canal) => canal.categoryName.toString() == primeraCategoria)==true)
    {
      return Stack(
        children: [

          Consumer<ProgrammingProvider>(
            builder: (context, programmingProvider, child) {
              final listadecanales = programmingProvider.programmingGuide;
              print("salida");
              print(listadecanales);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.only(left: 7.0),
                    child: Container(
                     height: 19,
                      child: Text(primeraCategoria.toString(),
                          style: TextStyle(
                          color: Colors.white)
                      ),
                    ),
                  ),
                  SizedBox(height: 5),

                  Padding(
                    padding: const EdgeInsets.only(left: 7.0),
                    child: Container(
                      height: size.height - 417,
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3, // 3 elementos por fila
                          crossAxisSpacing: 10.0, // Espaciado horizontal entre elementos
                          mainAxisSpacing: 10.0, // Espaciado vertical entre elementos
                        ),
                        itemCount: listadecanales.length,
                        itemBuilder: (context, index) {
                          return Container(
                            height: (size.height) / 7,
                            width: ((size.width) - 20) / 3,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: epgColor,
                              border: Border.all(
                                color: epgColor,
                              ),
                            ),
                            child: FlatButton(
                              padding: EdgeInsets.all(0),
                              onPressed: () {
                                onChannelChanged(listadecanales[index]);
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  if (listadecanales[index].image != null)
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: Image.network(
                                        listadecanales[index].image,
                                        height: (size.height) / 7,
                                        fit: BoxFit.contain,
                                      ),
                                    )
                                  else
                                    Container(),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          isLoading ? LoaderModal() : Container(),
        ],
      );




    }else{
      return Stack(
        children: [
          Consumer<ProgrammingProvider>(
            builder: (context, programmingProvider, child) {

              return Container(
                width: size.width,
                child: ListView.builder(
                  itemCount: programmingProvider.categories != null ? ((programmingProvider.categories.length)) : 0,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    final currentCategory = programmingProvider.categories[index];
                    final currentCanal = programmingProvider.programmingGuide;


                    if(currentCategory.name=="Todos")
                    {
                      return Container();
                    }else

                    {
                      var canaltamano=programmingProvider.programmingGuide.where((canal) => canal.categoryName.toString() == currentCategory.name.toString()).toList();
                      if(canaltamano.length<1){
                        return Container();
                      }else
                      {
                        return Padding(
                          padding: const EdgeInsets.only(left: 7.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 5),
                              Text(currentCategory.name.toString(),
                                  style: TextStyle(
                                      color: Colors.white)
                              ),
                              SizedBox(height: 5),
                              Container(

                                height: 130,
                                child: ListView.separated(

                                  separatorBuilder: (context, index) => SizedBox(width: 5), // Ajusta el espacio entre elementos
                                  scrollDirection: Axis.horizontal,
                                  itemCount:programmingProvider.programmingGuide.where((canal) => canal.categoryName.toString() == currentCategory.name.toString()).toList().length ,
                                  itemBuilder: (context, index) {

                                    var canalcat=programmingProvider.programmingGuide.where((canal) => canal.categoryName.toString() == currentCategory.name.toString()).toList();


                                    return Container(
                                        height: (size.height)/7,
                                        width: ((size.width)-20)/3,

                                        child:
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            color: epgColor,
                                            border: Border.all(
                                              color: epgColor,
                                            ),
                                          ),
                                          width: channelNumberWidth,
                                          height: (size.height)/7,
                                          child: FlatButton(
                                            padding: EdgeInsets.all(0),
                                            onPressed: () {
                                              onChannelChanged(canalcat[index]);
                                            },
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [

                                                (canalcat[index].image != null)
                                                    ? ClipRRect(
                                                  borderRadius: BorderRadius.circular(10.0),
                                                  child: Image.network(

                                                    canalcat[index].image,
                                                    height: (size.height)/7,
                                                    fit: BoxFit.contain,
                                                  ),
                                                )
                                                    : Container(),
                                              ],
                                            ),
                                          ),
                                        )

                                    );
                                  },
                                ),
                              ),

                            ],
                          ),
                        );


                      }

                    }


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
}
