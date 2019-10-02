import 'package:flutter/material.dart';

import './pages/category_meals_page.dart';
import './pages/meal_detail_page.dart';
import './pages/tabs_page.dart';
import './pages/filters_page.dart';
import './data/dummy_data.dart';
import './models/meal.dart';

void main() => runApp(MealApp());

class MealApp extends StatefulWidget {
  @override
  _MealAppState createState() => _MealAppState();
}

class _MealAppState extends State<MealApp> {
  Map<String, bool> _filters = {
    'gluten': false,
    'lactose': false,
    'vegan': false,
    'vegetarian': false
  };
  List<Meal> _availableMeals = DUMMY_MEALS;
  List<Meal> _favoriteMeals = [];

  void _setFilters(Map<String, bool> filterData) {
    setState(() {
      _filters = filterData;
      _availableMeals = DUMMY_MEALS.where((meal) {
        if (_filters['gluten'] && !meal.isGlutenFree) return false;
        if (_filters['lactose'] && !meal.isLactoseFree) return false;
        if (_filters['vegan'] && !meal.isVegan) return false;
        if (_filters['vegetarian'] && !meal.isVegetarian) return false;
        return true;
      }).toList();
    });
  }

  void _toggleFavorite(String mealId) {
    final existingIndex = _favoriteMeals.indexWhere((meal) => meal.id == mealId);
    if (existingIndex >= 0) setState(() => _favoriteMeals.removeAt(existingIndex));
    else setState(() => _favoriteMeals.add(DUMMY_MEALS.firstWhere((meal) => meal.id == mealId)));
  }

  bool _isMealFavorite(String id) {
    return _favoriteMeals.any((meal) => meal.id == id);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meal App',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        accentColor: Colors.amber,
        canvasColor: Color.fromRGBO(255, 254, 229, 1),
        fontFamily: 'Raleway',
        textTheme: ThemeData.light().textTheme.copyWith(
          title: TextStyle(
            fontSize: 20,
            fontFamily: 'RobotoCondensed' ,
            fontWeight: FontWeight.bold
          ),
          body1: TextStyle(
            color: Color.fromRGBO(20, 51, 51, 1)
          ),
          body2: TextStyle(
            color: Color.fromRGBO(20, 51, 51, 1)
          )
        )
      ),
      initialRoute: '/',
      routes: {
        '/': (ctx) => TabsPage(_favoriteMeals),
        CategoryMealsPage.routeName: (ctx) => CategoryMealsPage(_availableMeals),
        MealDetailPage.routeName: (ctx) => MealDetailPage(_toggleFavorite, _isMealFavorite),
        FiltersPage.routeName: (ctx) => FiltersPage(_filters, _setFilters)
      }
    );
  }
}