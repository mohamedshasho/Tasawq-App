import 'package:delivery_app/bloc/Products/bloc_product.dart';
import 'package:delivery_app/bloc/controlApp/ControlAppBloc.dart';
import 'package:delivery_app/componants/appbar_custom.dart';
import 'package:delivery_app/componants/no_internet.dart';
import 'package:delivery_app/helper/Session.dart';
import 'package:delivery_app/models/product.dart';
import 'package:delivery_app/models/store.dart';
import 'package:delivery_app/screens_user/details_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoriteScreen extends StatelessWidget {
  static const String id = 'FavoriteScreen';

  @override
  Widget build(BuildContext context) {
    BlocProduct bloc = BlocProduct.get(context);
    var height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              BuildAppbar(
                title: getTranslated(context, 'Favorite'),
                onTap: () => Navigator.pop(context),
              ),
              SizedBox(height: height * 0.02),
              Container(
                height: height * 0.1,
                alignment: context.read<ControlAppBloc>().direction == 'ar'
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Text(getTranslated(context, 'Favorite List'),
                    style: Theme.of(context).textTheme.headline3),
              ),
              SizedBox(height: height * 0.02),
              BlocBuilder<BlocProduct, DataState>(
                builder: (context, state) {
                  if (state is NoNetworkAvail) {
                    return noInternet(context);
                  }
                  if (state is DataLoaded) {
                    List<Product> favorite = [];
                    for (Person store in bloc.usersStore!) {
                      store.value.storeData!.products!.forEach((e) {
                        if (e.favorite!.val) {
                          favorite.add(e);
                        }
                      });
                    }
                    return ListView.builder(
                      itemCount: favorite.length,
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemBuilder: (ctx, index) {
                        return ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 5.0),
                          onTap: () {
                            Navigator.pushNamed(context, DetailsScreen.id,
                                arguments: favorite[index]);
                          },
                          shape: Border(bottom: BorderSide(width: 0.3)),
                          leading: Hero(
                            tag: favorite[index].id!,
                            child: Image.network(
                              favorite[index].image,
                              fit: BoxFit.fill,
                            ),
                          ),
                          title: Text(
                            favorite[index].name,
                            style: Theme.of(context).textTheme.headline5,
                          ),
                          subtitle: Text(
                            '\$${favorite[index].price}',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          trailing: TextButton(
                            onPressed: () {
                              bloc.add(DeleteToFavorite(favorite[index]));
                            },
                            child: Icon(
                              Icons.remove,
                              color: Theme.of(context).accentColor,
                            ),
                          ),
                        );
                      },
                    );
                  }
                  return getProgress();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
