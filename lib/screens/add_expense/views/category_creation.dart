import 'package:flutter/cupertino.dart';
import 'package:expense_repository/expense_repository.dart';
import 'package:expense_tracker_app/screens/add_expense/blocs/create_categorybloc/create_category_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:uuid/uuid.dart';

Future<Category?> getCategoryCreation(BuildContext context) async {
  List<String> myCategoriesIcons = [
    'entertainment',
    'food',
    'home',
    'pet',
    'travel',
    'shopping',
    'tech'
  ];

  return showDialog<Category>(
      context: context,
      builder: (ctx) {
        bool isExpandable = false;
        String iconSelected = '';
        Color categoryColor = Colors.white;
        TextEditingController categoryNameController = TextEditingController();
        TextEditingController categoryIconController = TextEditingController();
        TextEditingController categoryColorController = TextEditingController();
        bool isLoading = false;
        Category category = Category.empty;
        return StatefulBuilder(builder: (ctx, setState) {
          return BlocProvider.value(
            value: context.read<CreateCategoryBloc>(),
            child: BlocListener<CreateCategoryBloc, CreateCategoryState>(
              listener: (context, state) {
                if (state is CreateCategorySuccess) {
                  Navigator.pop(ctx, category);
                } else if (state is CreateCategoryLoading) {
                  setState(() {
                    isLoading = true;
                  });
                } else if (state is CreateCategoryfailure) {
                  print('Failed to create category');
                }
              },
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                title: Text("Create a Category"),
                backgroundColor: Colors.blue[100],
                content: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: categoryNameController,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "Name",
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(15))),
                      ),
                      SizedBox(
                        height: 18,
                      ),
                      TextFormField(
                        controller: categoryIconController,
                        onTap: () {
                          setState(() {
                            isExpandable = !isExpandable;
                          });
                        },
                        readOnly: true,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                            suffixIcon: Icon(
                              CupertinoIcons.chevron_down,
                              color: Colors.black,
                              size: 12,
                            ),
                            isDense: true,
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "Icon",
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: isExpandable
                                    ? BorderRadius.vertical(
                                        top: Radius.circular(12))
                                    : BorderRadius.circular(12))),
                      ),
                      isExpandable
                          ? Container(
                              width: MediaQuery.of(context).size.width,
                              height: 200,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.vertical(
                                      bottom: Radius.circular(12))),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GridView.builder(
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3,
                                            mainAxisSpacing: 5,
                                            crossAxisSpacing: 5),
                                    itemCount: myCategoriesIcons.length,
                                    itemBuilder: (context, int i) {
                                      return GestureDetector(
                                        onTap: () {
                                          setState(
                                            () {
                                              iconSelected =
                                                  myCategoriesIcons[i];
                                            },
                                          );
                                        },
                                        child: Container(
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 3,
                                                  color: iconSelected ==
                                                          myCategoriesIcons[i]
                                                      ? Colors.green
                                                      : Colors.grey),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                      'assets/${myCategoriesIcons[i]}.png'))),
                                        ),
                                      );
                                    }),
                              ),
                            )
                          : Container(),
                      SizedBox(
                        height: 18,
                      ),
                      TextFormField(
                        controller: categoryColorController,
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (ctx2) {
                                return AlertDialog(
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ColorPicker(
                                          pickerColor: Colors.white,
                                          onColorChanged: (value) {
                                            setState(
                                              () {
                                                categoryColor = value;
                                              },
                                            );
                                          }),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pop(ctx2);
                                        },
                                        child: Container(
                                            alignment: Alignment.center,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.5,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.07,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                color: Colors.black),
                                            child: Text(
                                              "Save Color",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                      )
                                    ],
                                  ),
                                );
                              });
                        },
                        readOnly: true,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            fillColor: categoryColor,
                            hintText: "Color",
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(15))),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(
                            () {
                              category.categoryId = Uuid().v1();
                              category.name = categoryNameController.text;
                              category.icon = iconSelected;
                              category.color = categoryColor.value;
                            },
                          );

                          context
                              .read<CreateCategoryBloc>()
                              .add(CreateCategory(category));
                          Navigator.pop(context);
                        },
                        child: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width * 0.5,
                            height: MediaQuery.of(context).size.height * 0.07,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.black),
                            child: isLoading == true
                                ? Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : Text(
                                    "Save",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  )),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
      });
  // print("print gesture");
}
