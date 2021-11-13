import 'package:delivery_app/helper/Session.dart';
import 'package:delivery_app/models/store.dart';
import 'package:delivery_app/screens_delivery/store_details.dart';
import 'package:flutter/material.dart';

class GridViewStores extends StatelessWidget {
  const GridViewStores({
    required this.stores,
  });

  final List<Person> stores;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: width > 400 ? 3 : 2,
        crossAxisSpacing: 5,
      ),
      itemCount: stores.length,
      itemBuilder: (ctx, index) {
        return LayoutBuilder(
          builder: (ctx, constraints) => GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, StoreDetails.id,
                  arguments: stores[index]);
            },
            child: Card(
              color: Theme.of(context).backgroundColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  stores[index].value.image == null
                      ? Image.asset(
                          'assets/images/store.png',
                          height: constraints.maxHeight * 0.8,
                          fit: BoxFit.fill,
                          width: constraints.maxWidth,
                        )
                      : Stack(
                          children: [
                            Hero(
                              tag: stores[index].id,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: FadeInImage(
                                  placeholder:
                                      AssetImage('assets/images/store.png'),
                                  image:
                                      NetworkImage(stores[index].value.image!),
                                  height: constraints.maxHeight * 0.8,
                                  fit: BoxFit.fill,
                                  width: constraints.maxWidth,
                                ),
                              ),
                            ),
                            Positioned(
                              child: Container(
                                child: Row(
                                  children: [
                                    Text(
                                        '${stores[index].value.storeData!.rate}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5!),
                                    const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                  ],
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              right: 0,
                            ),
                            stores[index].value.locationUser!.locality == null
                                ? const SizedBox()
                                : Directionality(
                                    textDirection: TextDirection.ltr,
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.location_on_rounded,
                                          color: Colors.lightGreenAccent,
                                        ),
                                        Text(
                                          stores[index]
                                              .value
                                              .locationUser!
                                              .locality!,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5!
                                              .copyWith(
                                                  color:
                                                      Colors.lightGreenAccent),
                                        ),
                                      ],
                                    ),
                                  ),
                            Positioned(
                              child: Container(
                                width: constraints.maxWidth,
                                alignment: Alignment.center,
                                child: Text(
                                  stores[index].value.username!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline5!
                                      .copyWith(color: Colors.white),
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black54.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              bottom: 0,
                            ),
                          ],
                        ),
                  stores[index].value.category == null
                      ? const SizedBox()
                      : Text(
                          getTranslated(context, stores[index].value.category!),
                          style: Theme.of(context).textTheme.headline6,
                        ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
