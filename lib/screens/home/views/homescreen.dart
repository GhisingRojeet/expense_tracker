import 'dart:math';

import 'package:expense_repository/expense_repository.dart';
import 'package:expense_tracker_app/screens/add_expense/blocs/create_categorybloc/create_category_bloc.dart';
import 'package:expense_tracker_app/screens/add_expense/blocs/create_expensebloc/create_expense_bloc.dart';
import 'package:expense_tracker_app/screens/add_expense/blocs/get_categoriesbloc/get_categories_bloc.dart';
import 'package:expense_tracker_app/screens/add_expense/views/add_expense.dart';
import 'package:expense_tracker_app/screens/home/blocs/get_expensesbloc/get_expenses_bloc.dart';
import 'package:expense_tracker_app/screens/home/views/main_screen.dart';
import 'package:expense_tracker_app/screens/stats/stats.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;
  Color selectedItemColor = Colors.blue;
  Color unSelectedItemColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetExpensesBloc, GetExpensesState>(
        builder: (context, state) {
      if (state is GetExpensesSuccess) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          bottomNavigationBar: ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            child: BottomNavigationBar(
                onTap: (value) {
                  setState(() {
                    index = value;
                  });
                },
                elevation: 7,
                // backgroundColor: Colors.white,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                items: [
                  BottomNavigationBarItem(
                      icon: Icon(
                        CupertinoIcons.home,
                        color: index == 0
                            ? selectedItemColor
                            : unSelectedItemColor,
                      ),
                      label: 'home'),
                  BottomNavigationBarItem(
                      icon: Icon(
                        CupertinoIcons.graph_square,
                        color: index == 1
                            ? selectedItemColor
                            : unSelectedItemColor,
                      ),
                      label: 'graph'),
                ]),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
            shape: CircleBorder(),
            onPressed: () async {
              var newExpense = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MultiBlocProvider(
                            providers: [
                              BlocProvider(
                                create: (context) =>
                                    CreateCategoryBloc(FirebaseExpenseRepo()),
                              ),
                              BlocProvider(
                                create: (context) =>
                                    GetCategoriesBloc(FirebaseExpenseRepo())
                                      ..add(GetCategories()),
                              ),
                              BlocProvider(
                                create: (context) =>
                                    CreateExpenseBloc(FirebaseExpenseRepo()),
                              ),
                            ],
                            child: AddExpense(),
                          )));
              if (newExpense != null) {
                setState(() {
                  state.expenses.add(newExpense);
                });
              }
            },
            child: Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                        transform: GradientRotation(pi / 3),
                        colors: [
                          Theme.of(context).colorScheme.tertiary,
                          Theme.of(context).colorScheme.secondary,
                          Theme.of(context).colorScheme.primary,
                        ])),
                child: Icon(CupertinoIcons.add)),
          ),
          body: index == 0 ? MainScreen(state.expenses) : StatsScreen(),
        );
      } else {
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
    });
  }
}
