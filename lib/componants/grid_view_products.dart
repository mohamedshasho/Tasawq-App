import 'package:delivery_app/models/product.dart';
import 'package:delivery_app/screens_user/details_screen.dart';
import 'package:flutter/material.dart';

class GridViewProducts extends StatelessWidget {
  const GridViewProducts({
    required this.products,
  });
  final List<Product> products;
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      itemCount: products.length,
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: width > 400 ? 3 : 2,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
      ),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, DetailsScreen.id,
                arguments: products[index]);
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            decoration: BoxDecoration(
              color: index.isOdd
                  ? Theme.of(context).canvasColor
                  : Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).shadowColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      )),
                  margin: EdgeInsets.only(left: 30, right: 30, top: 30),
                ),
                Positioned(
                  bottom: 60,
                  left: 0,
                  right: 0,
                  top: 0,
                  child: Hero(
                      tag: products[index].id!,
                      child: ClipRRect(
                        child: FadeInImage(
                          image: NetworkImage(products[index].image),
                          placeholder: AssetImage('assets/images/item.png'),
                          fit: BoxFit.fill,
                          width: width,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      )),
                ),
                Positioned(
                  child: Text(
                    products[index].name,
                    style: Theme.of(context)
                        .textTheme
                        .headline5!
                        .copyWith(color: Colors.green.shade900),
                    textAlign: TextAlign.center,
                  ),
                  bottom: 40,
                  left: 0,
                  right: 0,
                ),
                Positioned(
                  child: Text(
                    ' \$${products[index].price}',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  bottom: 2,
                  left: 0,
                  right: 0,
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
                products[index].location != null
                    ? Positioned(
                        child: Column(
                          children: [
                            Text(
                              products[index].location!,
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            const Icon(
                              Icons.location_on_outlined,
                              size: 22,
                            ),
                          ],
                        ),
                        bottom: 2,
                        left: 2,
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        );
      },
    );
  }
}
