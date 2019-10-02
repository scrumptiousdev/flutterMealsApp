import 'package:flutter/material.dart';

import '../data/dummy_data.dart';

class MealDetailPage extends StatelessWidget {
  static const routeName = '/meal-detail';

  final Function toggleFavorite;
  final Function isFavorite;

  MealDetailPage(this.toggleFavorite, this.isFavorite);

  @override
  Widget build(BuildContext context) {
    final mealId = ModalRoute.of(context).settings.arguments as String;
    final meal = DUMMY_MEALS.firstWhere((meal) => meal.id == mealId);

    Widget buildSectionTitle(BuildContext context, String text) {
      return Container(
        margin: EdgeInsets.symmetric(
          vertical: 10
        ),
        child: Text(
          text,
          style: Theme.of(context).textTheme.title
        )
      );
    }

    Widget buildContainer(Widget child) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.grey
          ),
          borderRadius: BorderRadius.circular(10)
        ),
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        height: 150,
        width: 300,
        child: child
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(meal.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              isFavorite(mealId) ? Icons.favorite : Icons.favorite_border
            ),
            onPressed: () => toggleFavorite(mealId)
          )
        ]
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 300,
              width: double.infinity,
              child: Image.network(
                meal.imageUrl,
                fit: BoxFit.cover
              )
            ),
            buildSectionTitle(context, 'Ingredients'),
            buildContainer(
              ListView.builder(
                itemBuilder: (ctx, index) => Card(
                  color: Theme.of(context).accentColor,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 10
                    ),
                    child: Text(meal.ingredients[index]),
                  )
                ),
                itemCount: meal.ingredients.length
              )
            ),
            buildSectionTitle(context, 'Steps'),
            buildContainer(
              ListView.builder(
                itemBuilder: (ctx, index) => Column(
                  children: <Widget>[
                    ListTile(
                      leading: CircleAvatar(
                        child: Text('#${(index + 1)}')
                      ),
                      title: Text(meal.steps[index])
                    ),
                    Divider()
                  ]
                ),
                itemCount: meal.steps.length,
              )
            )
          ]
        )
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.delete),
        onPressed: () {
          Navigator.of(context).pop(mealId);
        }
      )
    );
  }
}