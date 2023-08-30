import 'package:delivery_app/models/product.dart';
import 'package:delivery_app/screens_user/details_screen.dart';
import 'package:flutter/material.dart';

class ListViewProduct extends StatelessWidget {
  final List<Product> products;
  ListViewProduct({required this.products});
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    bool isPortraitMode =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: products.length,
        itemBuilder: (ctx, index) {
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, DetailsScreen.id,
                  arguments: products[index]);
            },
            child: Card(
              elevation: 0.1,
              color: index.isOdd
                  ? Theme.of(context).canvasColor
                  : Theme.of(context).colorScheme.secondary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Stack(
                    children: [
                      Hero(
                        tag: products[index].id!,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: FadeInImage(
                            placeholder: AssetImage('assets/images/item.png'),
                            image: NetworkImage(products[index].image),
                            fit: BoxFit.fill,
                            height:
                                isPortraitMode ? height * 0.15 : height * 0.25,
                            width: width * 0.35,
                          ),
                        ),
                      ),
                      Positioned(
                        child: Icon(
                          products[index].favorite!.val
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: Colors.red,
                        ),
                        right: 2,
                        top: 2,
                      ),
                    ],
                  ),
                  SizedBox(width: width * 0.02),
                  products[index].location != null
                      ? Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              size: 22,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              products[index].location!,
                              style: Theme.of(context).textTheme.headline6,
                            ),
                          ],
                        )
                      : const SizedBox(),
                  const Spacer(),
                  Container(
                    height: isPortraitMode ? height * 0.15 : height * 0.25,
                    padding: const EdgeInsets.all(5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          products[index].name,
                          style:
                              Theme.of(context).textTheme.headline5!.copyWith(
                                    color: Colors.green[600],
                                  ),
                        ),
                        Text(
                          ' \$${products[index].price}',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
