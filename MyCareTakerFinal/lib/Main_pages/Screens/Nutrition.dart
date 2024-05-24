import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class NutritionPage extends StatefulWidget {
  const NutritionPage({super.key});
  @override
  _NutritionPageState createState() => _NutritionPageState();
}

class _NutritionPageState extends State<NutritionPage> {
  late DateTime selectedDate; // Selected date
  late List<DateTime> dates; // List of dates for previous 7 days
  int currentIndex = 0; // Index of selected date
  bool isAddMealTabSelected = false; // Track if "Add Meal" tab is selected

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    dates =
        _generateDates(DateTime.now(), 7); // Generate dates for previous 7 days
  }

  List<DateTime> _generateDates(DateTime baseDate, int count) {
    List<DateTime> dates = [];
    for (int i = count - 1; i >= 0; i--) {
      dates.add(baseDate.subtract(Duration(days: i)));
    }
    return dates;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Changed length to 2
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Nutrition'),
        ),
        body: Column(
          children: [
            Container(
              constraints:
                  BoxConstraints.expand(height: isAddMealTabSelected ? 0 : 50),
              child: TabBar(
                onTap: (index) {
                  setState(() {
                    isAddMealTabSelected = index ==
                        2; // Set isAddMealTabSelected based on tab index
                  });
                },
                tabs: const [
                  Tab(text: 'Nutrients'),
                  Tab(text: 'Calories'),
                ],
              ),
            ),
            // Add row of dates
            if (!isAddMealTabSelected)
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: dates.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          selectedDate = dates[index];
                          currentIndex = index;
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        color: index == currentIndex
                            ? Colors.grey
                            : Colors.transparent,
                        child: Text(
                          _formatDate(dates[index]),
                          style: TextStyle(
                            color: index == currentIndex
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            Expanded(
              child: TabBarView(
                children: [
                  NutrientsTab(selectedDate: selectedDate),
                  CaloriesTab(selectedDate: selectedDate),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    if (date.year == DateTime.now().year &&
        date.month == DateTime.now().month &&
        date.day == DateTime.now().day) {
      return 'Today';
    } else if (date.year ==
            DateTime.now().subtract(const Duration(days: 1)).year &&
        date.month == DateTime.now().subtract(const Duration(days: 1)).month &&
        date.day == DateTime.now().subtract(const Duration(days: 1)).day) {
      return 'Yesterday';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

class NutrientsTab extends StatelessWidget {
  final DateTime selectedDate;
  const NutrientsTab({super.key, required this.selectedDate});

  // You can update this method to fetch nutrients data for the selected date from your database or any other source
  Map<String, int> getNutrientsData(DateTime selectedDate) {
    // Mock data for nutrients of each day
    // You should replace this with your actual data retrieval logic
    return {
      'Protein (g)': 50,
      'Carbohydrates (g)': 130,
      'Fat (g)': 70,
      'Vitamin A (%)': 100,
      'Vitamin C (%)': 50,
      'Minerals (%)': 80,
      'Fiber (g)': 25,
      'Calcium (%)': 20,
      'Iron (%)': 15,
      'Potassium (mg)': 300,
      // Add more nutrients as needed
    };
  }

  @override
  Widget build(BuildContext context) {
    Map<String, int> nutrientsData = getNutrientsData(selectedDate);
    return ListView.builder(
      itemCount: nutrientsData.length,
      itemBuilder: (context, index) {
        String nutrient = nutrientsData.keys.elementAt(index);
        int amount = nutrientsData.values.elementAt(index);
        return ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(nutrient),
              Text('$amount'),
            ],
          ),
        );
      },
    );
  }
}

class CaloriesTab extends StatelessWidget {
  final DateTime selectedDate;
  CaloriesTab({super.key, required this.selectedDate});

  // Mock data for total calories of each day
  final Map<String, double> mealCategories = {
    'Breakfast': 400,
    'Lunch': 600,
    'Dinner': 800,
    'Snack': 200,
  };

  // Define custom colors for each category
  final List<Color> categoryColors = [
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.red,
  ];

  // Mock data for goals
  final Map<String, double> goals = {
    'Breakfast': 500,
    'Lunch': 700,
    'Dinner': 1000,
    'Snack': 300,
  };

  @override
  Widget build(BuildContext context) {
    // Calculate total calories and total goal
    double totalCalories = mealCategories.values.fold(0, (a, b) => a + b);
    double totalGoal = goals.values.fold(0, (a, b) => a + b);

    // Calculate total percentage of calories
    double totalPercentage = totalCalories / totalGoal * 100;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: PieChart(
            dataMap: mealCategories,
            chartType: ChartType.disc,
            chartRadius: MediaQuery.of(context).size.width / 2,
            legendOptions: const LegendOptions(
              legendPosition: LegendPosition.bottom,
              showLegends: false, // Hiding legends
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (var i = 0; i < 2; i++)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                color: categoryColors[i],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                  '${mealCategories.keys.elementAt(i)} (${((mealCategories.values.elementAt(i) / totalCalories) * 100).toStringAsFixed(1)}%)'),
                            ],
                          ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (var i = 2; i < 4; i++)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                color: categoryColors[i],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                  '${mealCategories.keys.elementAt(i)} (${((mealCategories.values.elementAt(i) / totalCalories) * 100).toStringAsFixed(1)}%)'),
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 35),
              const Divider(
                height: 5,
                thickness: 0.5,
                indent: 0,
                endIndent: 0,
                color: Colors.black,
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total'),
                  const SizedBox(width: 8),
                  Text(
                      '${totalCalories.toStringAsFixed(1)} (${totalPercentage.toStringAsFixed(1)}%)'),
                ],
              ),
              const SizedBox(height: 15),
              const Divider(
                height: 5,
                thickness: 0.5,
                indent: 0,
                endIndent: 0,
                color: Colors.black54,
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Goal'),
                  const SizedBox(width: 8),
                  Text('$totalGoal'),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Placeholder for the Add Meal tab
