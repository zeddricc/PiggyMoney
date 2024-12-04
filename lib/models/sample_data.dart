import 'package:flutter/material.dart';
import 'category.dart';

List<Category> sampleCategories = [
  Category(
    name: 'Food',
    icon: Icons.fastfood,
    color: Colors.orange,
    subcategories: [
      Subcategory(
        name: 'Groceries',
        icon: Icons.shopping_cart,
        color: Colors.orange,
      ),
      Subcategory(
        name: 'Dining Out',
        icon: Icons.restaurant,
        color: Colors.orange,
      ),
      Subcategory(
        name: 'Takeout',
        icon: Icons.takeout_dining,
        color: Colors.orange,
      ),
      Subcategory(
        name: 'Snacks',
        icon: Icons.cookie,
        color: Colors.orange,
      ),
      Subcategory(
        name: 'Beverages',
        icon: Icons.local_drink,
        color: Colors.orange,
      ),
      Subcategory(
        name: 'Desserts',
        icon: Icons.cake,
        color: Colors.orange,
      ),
      Subcategory(
        name: 'Catering',
        icon: Icons.local_pizza,
        color: Colors.orange,
      ),
      Subcategory(
        name: 'Meal Prep',
        icon: Icons.food_bank,
        color: Colors.orange,
      ),
    ],
  ),
  Category(
    name: 'Transport',
    icon: Icons.directions_car,
    color: Colors.blue,
    subcategories: [
      Subcategory(
        name: 'Fuel',
        icon: Icons.local_gas_station,
        color: Colors.blue,
      ),
      Subcategory(
        name: 'Public Transport',
        icon: Icons.train,
        color: Colors.blue,
      ),
      Subcategory(
        name: 'Taxi',
        icon: Icons.taxi_alert,
        color: Colors.blue,
      ),
      Subcategory(
        name: 'Parking',
        icon: Icons.local_parking,
        color: Colors.blue,
      ),
      Subcategory(
        name: 'Car Maintenance',
        icon: Icons.build,
        color: Colors.blue,
      ),
      Subcategory(
        name: 'Bicycle',
        icon: Icons.pedal_bike,
        color: Colors.blue,
      ),
      Subcategory(
        name: 'Ride Sharing',
        icon: Icons.car_rental,
        color: Colors.blue,
      ),
      Subcategory(
        name: 'Train Tickets',
        icon: Icons.train,
        color: Colors.blue,
      ),
    ],
  ),
  Category(
    name: 'Entertainment',
    icon: Icons.movie,
    color: Colors.purple,
    subcategories: [
      Subcategory(
        name: 'Movies',
        icon: Icons.local_movies,
        color: Colors.purple,
      ),
      Subcategory(
        name: 'Concerts',
        icon: Icons.music_note,
        color: Colors.purple,
      ),
      Subcategory(
        name: 'Games',
        icon: Icons.videogame_asset,
        color: Colors.purple,
      ),
      Subcategory(
        name: 'Streaming Services',
        icon: Icons.tv,
        color: Colors.purple,
      ),
      Subcategory(
        name: 'Books',
        icon: Icons.book,
        color: Colors.purple,
      ),
      Subcategory(
        name: 'Theater',
        icon: Icons.theater_comedy,
        color: Colors.purple,
      ),
      Subcategory(
        name: 'Sports Events',
        icon: Icons.sports,
        color: Colors.purple,
      ),
      Subcategory(
        name: 'Hobbies',
        icon: Icons.palette,
        color: Colors.purple,
      ),
    ],
  ),
  Category(
    name: 'Health',
    icon: Icons.health_and_safety,
    color: Colors.green,
    subcategories: [
      Subcategory(
        name: 'Gym',
        icon: Icons.fitness_center,
        color: Colors.green,
      ),
      Subcategory(
        name: 'Doctor',
        icon: Icons.local_hospital,
        color: Colors.green,
      ),
      Subcategory(
        name: 'Pharmacy',
        icon: Icons.local_pharmacy,
        color: Colors.green,
      ),
      Subcategory(
        name: 'Health Insurance',
        icon: Icons.health_and_safety,
        color: Colors.green,
      ),
      Subcategory(
        name: 'Wellness',
        icon: Icons.self_improvement,
        color: Colors.green,
      ),
      Subcategory(
        name: 'Nutrition',
        icon: Icons.food_bank,
        color: Colors.green,
      ),
      Subcategory(
        name: 'Fitness Classes',
        icon: Icons.group,
        color: Colors.green,
      ),
    ],
  ),
  Category(
    name: 'Shopping',
    icon: Icons.shopping_bag,
    color: Colors.pink,
    subcategories: [
      Subcategory(
        name: 'Clothes',
        icon: Icons.checkroom,
        color: Colors.pink,
      ),
      Subcategory(
        name: 'Electronics',
        icon: Icons.electrical_services,
        color: Colors.pink,
      ),
      Subcategory(
        name: 'Groceries',
        icon: Icons.shopping_cart,
        color: Colors.pink,
      ),
      Subcategory(
        name: 'Home Goods',
        icon: Icons.home,
        color: Colors.pink,
      ),
      Subcategory(
        name: 'Toys',
        icon: Icons.toys,
        color: Colors.pink,
      ),
      Subcategory(
        name: 'Books',
        icon: Icons.book,
        color: Colors.pink,
      ),
      Subcategory(
        name: 'Beauty Products',
        icon: Icons.face,
        color: Colors.pink,
      ),
      Subcategory(
        name: 'Jewelry',
        icon: Icons.accessibility,
        color: Colors.pink,
      ),
    ],
  ),
  Category(
    name: 'Utilities',
    icon: Icons.build,
    color: const Color.fromARGB(255, 142, 128, 6),
    subcategories: [
      Subcategory(
        name: 'Electricity',
        icon: Icons.electric_bolt,
        color: Colors.yellow,
      ),
      Subcategory(
        name: 'Water',
        icon: Icons.water,
        color: Colors.yellow,
      ),
      Subcategory(
        name: 'Internet',
        icon: Icons.wifi,
        color: Colors.yellow,
      ),
      Subcategory(
        name: 'Gas',
        icon: Icons.local_gas_station,
        color: Colors.yellow,
      ),
      Subcategory(
        name: 'Trash',
        icon: Icons.delete,
        color: Colors.yellow,
      ),
      Subcategory(
        name: 'Sewage',
        icon: Icons.local_laundry_service,
        color: Colors.yellow,
      ),
      Subcategory(
        name: 'Phone Bill',
        icon: Icons.phone,
        color: Colors.yellow,
      ),
      Subcategory(
        name: 'Cable',
        icon: Icons.tv,
        color: Colors.yellow,
      ),
    ],
  ),
  Category(
    name: 'Travel',
    icon: Icons.airplanemode_active,
    color: Colors.lightGreen,
    subcategories: [
      Subcategory(
        name: 'Flights',
        icon: Icons.flight,
        color: Colors.lightGreen,
      ),
      Subcategory(
        name: 'Hotels',
        icon: Icons.hotel,
        color: Colors.lightGreen,
      ),
      Subcategory(
        name: 'Car Rentals',
        icon: Icons.car_rental,
        color: Colors.lightGreen,
      ),
      Subcategory(
        name: 'Travel Insurance',
        icon: Icons.security,
        color: Colors.lightGreen,
      ),
      Subcategory(
        name: 'Activities',
        icon: Icons.explore,
        color: Colors.lightGreen,
      ),
      Subcategory(
        name: 'Souvenirs',
        icon: Icons.card_giftcard,
        color: Colors.lightGreen,
      ),
      Subcategory(
        name: 'Food & Drink',
        icon: Icons.local_dining,
        color: Colors.lightGreen,
      ),
      Subcategory(
        name: 'Transportation',
        icon: Icons.directions,
        color: Colors.lightGreen,
      ),
    ],
  ),
  Category(
    name: 'Education',
    color: const Color.fromARGB(255, 71, 34, 194),
    icon: Icons.school,
    subcategories: [
      Subcategory(
        name: 'Tuition',
        icon: Icons.monetization_on,
        color: const Color.fromARGB(255, 71, 34, 194),
      ),
      Subcategory(
        name: 'Books',
        icon: Icons.book,
        color: const Color.fromARGB(255, 71, 34, 194),
      ),
      Subcategory(
        name: 'Supplies',
        icon: Icons.edit,
        color: const Color.fromARGB(255, 71, 34, 194),
      ),
      Subcategory(
        name: 'Online Courses',
        icon: Icons.computer,
        color: const Color.fromARGB(255, 71, 34, 194),
      ),
      Subcategory(
        name: 'Workshops',
        icon: Icons.work,
        color: const Color.fromARGB(255, 71, 34, 194),
      ),
      Subcategory(
        name: 'Tutoring',
        icon: Icons.person,
        color: const Color.fromARGB(255, 71, 34, 194),
      ),
      Subcategory(
        name: 'School Fees',
        icon: Icons.school,
        color: const Color.fromARGB(255, 71, 34, 194),
      ),
      Subcategory(
        name: 'Extracurricular',
        icon: Icons.sports,
        color: const Color.fromARGB(255, 71, 34, 194),
      ),
    ],
  ),
  Category(
    name: 'Gifts',
    icon: Icons.card_giftcard,
    color: const Color.fromARGB(255, 32, 112, 198),
    subcategories: [
      Subcategory(
        name: 'Birthday',
        icon: Icons.cake,
        color: const Color.fromARGB(255, 32, 112, 198),
      ),
      Subcategory(
        name: 'Holiday',
        icon: Icons.holiday_village,
        color: const Color.fromARGB(255, 32, 112, 198),
      ),
      Subcategory(
        name: 'Anniversary',
        icon: Icons.favorite,
        color: const Color.fromARGB(255, 32, 112, 198),
      ),
      Subcategory(
        name: 'Graduation',
        icon: Icons.school,
        color: const Color.fromARGB(255, 32, 112, 198),
      ),
      Subcategory(
        name: 'Thank You',
        icon: Icons.thumb_up,
        color: const Color.fromARGB(255, 32, 112, 198),
      ),
      Subcategory(
        name: 'Just Because',
        icon: Icons.favorite_border,
        color: const Color.fromARGB(255, 32, 112, 198),
      ),
      Subcategory(
        name: 'Gift Cards',
        icon: Icons.card_giftcard,
        color: const Color.fromARGB(255, 32, 112, 198),
      ),
    ],
  ),
  Category(
    name: 'Miscellaneous',
    icon: Icons.category,
    color: const Color.fromARGB(255, 36, 59, 37),
    subcategories: [
      Subcategory(
        name: 'Charity',
        icon: Icons.favorite_border,
        color: const Color.fromARGB(255, 36, 59, 37),
      ),
      Subcategory(
        name: 'Subscriptions',
        icon: Icons.subscriptions,
        color: const Color.fromARGB(255, 36, 59, 37),
      ),
      Subcategory(
        name: 'Other',
        icon: Icons.more_horiz,
        color: const Color.fromARGB(255, 36, 59, 37),
      ),
      Subcategory(
        name: 'Pet Care',
        icon: Icons.pets,
        color: const Color.fromARGB(255, 36, 59, 37),
      ),
      Subcategory(
        name: 'Household',
        icon: Icons.home,
        color: const Color.fromARGB(255, 36, 59, 37),
      ),
      Subcategory(
        name: 'Personal Care',
        icon: Icons.face,
        color: const Color.fromARGB(255, 36, 59, 37),
      ),
      Subcategory(
        name: 'Office Supplies',
        icon: Icons.business_center,
        color: const Color.fromARGB(255, 36, 59, 37),
      ),
      Subcategory(
        name: 'Miscellaneous',
        icon: Icons.category,
        color: const Color.fromARGB(255, 36, 59, 37),
      ),
    ],
  ),
];
