import 'package:delivery_app/bloc/Products/bloc_product.dart';
import 'package:delivery_app/helper/Session.dart';
import 'package:delivery_app/models/categories.dart';
import 'package:delivery_app/screens_delivery/new_category.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategoriesView extends StatelessWidget {
  const CategoriesView({
    required this.height,
    required this.categories,
    required this.axis,
  });

  final double height;
  final List<Category> categories;
  final Axis axis;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    BlocProduct bloc = BlocProduct.get(context);
    return Container(
      height: height,
      child: GridView.builder(
        itemCount: axis == Axis.vertical
            ? categories.length
            : categories.length > 6
                ? 6
                : categories.length,
        scrollDirection: axis,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: width > 400 ? 3 : 2,
          mainAxisSpacing: 5,
        ),
        itemBuilder: (ctx, index) {
          return LayoutBuilder(
            builder: (ctx, constraint) => Card(
              color: Theme.of(context).cardColor,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: EdgeInsets.all(constraint.maxHeight * 0.08),
                child: Column(
                  children: [
                    Flexible(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Hero(
                          tag: categories[index].id!,
                          child: Image.network(
                            categories[index].image,
                            height: constraint.maxHeight * 0.6,
                          ),
                        ),
                      ),
                    ),
                    axis == Axis.horizontal
                        ? Text(
                            categories[index].name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.headline5,
                          )
                        : Text(
                            categories[index].name,
                            style: Theme.of(context).textTheme.headline5,
                          ),
                    axis == Axis.vertical
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                child: Icon(Icons.delete),
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: Text(
                                        getTranslated(
                                            context, 'Are you sure to delete?'),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline3,
                                      ),
                                      content: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          InkWell(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                getTranslated(context, 'No'),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline4,
                                              ),
                                            ),
                                            onTap: () {
                                              Navigator.pop(ctx);
                                            },
                                          ),
                                          const SizedBox(width: 10),
                                          InkWell(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                getTranslated(context, "Yes"),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline4!
                                                    .copyWith(
                                                        color:
                                                            Colors.redAccent),
                                              ),
                                            ),
                                            onTap: () {
                                              bloc.add(RemoveCategory(
                                                  categories[index]));
                                              Navigator.pop(ctx);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(width: 10),
                              InkWell(
                                child: Icon(Icons.edit),
                                onTap: () {
                                  Navigator.pushNamed(context, NewCategory.id,
                                      arguments: categories[index]);
                                },
                              ),
                            ],
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
