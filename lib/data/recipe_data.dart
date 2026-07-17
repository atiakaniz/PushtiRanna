import '../models/recipe_model.dart';

class RecipeData {
  static List<RecipeModel> recipes = [

    RecipeModel(
      id: "1",
      title: "Vegetable Khichuri",
      banglaTitle: "সবজি খিচুড়ি",
      image: "assets/images/Khichuri.jpg",
      category: "Lunch",
      calories: 280,
      time: 30,
      ingredients: [
        "Rice",
        "Lentils",
        "Carrot",
        "Peas",
        "Potato",
        "Salt",
        "Turmeric"
      ],
      steps: [
        "Wash the rice thoroughly with clean water.",
        "Wash the lentils and drain excess water.",
        "Peel and cut the carrot and potato into small cubes.",
        "Heat a cooking pot and add a small amount of oil.",
        "Add turmeric and lightly stir for a few seconds.",
        "Add rice and lentils to the pot and mix well.",
        "Add all vegetables including peas and carrots.",
        "Pour enough water and add salt to taste.",
        "Cook until the rice, lentils, and vegetables become soft.",
        "Serve hot with salad, pickle, or boiled egg."
      ],
    ),

    RecipeModel(
      id: "2",
      title: "Chickpea Salad",
      banglaTitle: "ছোলা সালাদ",
      image: "assets/images/chickpea_salad.jpg",
      category: "Salad",
      calories: 220,
      time: 10,
      ingredients: [
        "Boiled chickpeas",
        "Tomato",
        "Cucumber",
        "Onion",
        "Lemon juice"
      ],
      steps: [
        "Boil chickpeas until they become soft.",
        "Allow the chickpeas to cool completely.",
        "Wash tomatoes and cucumbers thoroughly.",
        "Cut tomatoes into small cubes.",
        "Slice cucumbers into thin pieces.",
        "Finely chop the onion.",
        "Take a large bowl and add all ingredients.",
        "Pour fresh lemon juice over the mixture.",
        "Mix everything gently until well combined.",
        "Serve immediately as a healthy snack or side dish."
      ],
    ),

    RecipeModel(
      id: "3",
      title: "Vegetable Fried Rice",
      banglaTitle: "সবজি ভাত",
      image: "assets/images/fried_rice.jpg",
      category: "Lunch",
      calories: 320,
      time: 25,
      ingredients: [
        "Rice",
        "Carrot",
        "Beans",
        "Peas",
        "Soy sauce"
      ],
      steps: [
        "Cook rice and allow it to cool completely.",
        "Wash and finely chop carrots and beans.",
        "Boil peas for a few minutes until tender.",
        "Heat a non-stick pan with a small amount of oil.",
        "Add carrots and beans and stir-fry for 3 minutes.",
        "Add boiled peas and continue stirring.",
        "Add the cooked rice to the vegetables.",
        "Pour soy sauce and mix evenly.",
        "Cook for another 4 to 5 minutes on medium heat.",
        "Serve hot with salad or vegetable curry."
      ],
    ),

     RecipeModel(
     id: "4",
     title: "Spinach Dal",
     banglaTitle: "পালং ডাল",
     image: "assets/images/spinach_dal.jpg",
     category: "Lunch",
     calories: 240,
     time: 30,
     ingredients: [
     "Lentils",
     "Spinach",
     "Garlic",
     "Onion"
     ],
     steps: [
     "Wash the lentils thoroughly under running water.",
  "Boil the lentils in a pot with enough water.",
  "Add a pinch of turmeric and salt while boiling.",
  "Wash spinach leaves carefully and chop them finely.",
  "Heat a small amount of oil in a separate pan.",
  "Add chopped garlic and onion and sauté until golden.",
  "Add the chopped spinach and cook for 3 to 4 minutes.",
  "Pour the cooked lentils into the spinach mixture.",
  "Simmer everything together for 5 minutes.",
  "Serve hot with steamed rice."
  ],
     ),
  RecipeModel(
  id: "5",
  title: "Vegetable Soup",
  banglaTitle: "সবজি স্যুপ",
  image: "assets/images/veg_soup.jpg",
  category: "Dinner",
  calories: 150,
  time: 20,
  ingredients: [
  "Carrot",
  "Beans",
  "Cabbage",
  "Pepper"
  ],
  steps: [
  "Wash all vegetables thoroughly.",
  "Cut carrots, beans, and cabbage into small pieces.",
  "Heat a saucepan and add a little oil.",
  "Add vegetables and sauté for 2 minutes.",
  "Pour enough water into the saucepan.",
  "Add salt and black pepper according to taste.",
  "Boil the vegetables until they become tender.",
  "Blend a small portion for a thicker texture if desired.",
  "Simmer for another 3 minutes.",
  "Serve warm and enjoy a healthy soup."
  ],
  ),

  RecipeModel(
  id: "6",
  title: "Oats Porridge",
  banglaTitle: "ওটস পায়েস",
  image: "assets/images/oats.jpg",
  category: "Breakfast",
  calories: 200,
  time: 10,
  ingredients: [
  "Oats",
  "Milk",
  "Banana"
  ],
  steps: [
  "Pour milk into a saucepan and heat gently.",
  "Add oats to the warm milk.",
  "Stir continuously to prevent sticking.",
  "Cook on low heat for about 5 minutes.",
  "Slice a ripe banana into thin pieces.",
  "Add banana slices to the porridge.",
  "Continue stirring until creamy.",
  "Add a little honey if preferred.",
  "Cook for another minute.",
  "Serve warm as a healthy breakfast."
  ],
  ),

  RecipeModel(
  id: "7",
  title: "Vegetable Paratha",
  banglaTitle: "সবজি পরোটা",
  image: "assets/images/paratha.jpg",
  category: "Breakfast",
  calories: 300,
  time: 25,
  ingredients: [
  "Flour",
  "Potato",
  "Carrot",
  "Spices"
  ],
  steps: [
  "Mix flour with water and knead into a soft dough.",
  "Allow the dough to rest for 10 minutes.",
  "Boil potatoes and mash them well.",
  "Grate carrots and mix with mashed potatoes.",
  "Add spices and mix the stuffing thoroughly.",
  "Divide the dough into equal balls.",
  "Flatten each ball and place stuffing inside.",
  "Seal and roll gently into a flat paratha.",
  "Cook on a hot pan until both sides are golden.",
  "Serve hot with yogurt or pickle."
  ],
  ),

  RecipeModel(
  id: "8",
  title: "Corn Salad",
  banglaTitle: "ভুট্টা সালাদ",
  image: "assets/images/corn_salad.jpg",
  category: "Salad",
  calories: 180,
  time: 10,
  ingredients: [
  "Corn",
  "Tomato",
  "Onion",
  "Lemon"
  ],
  steps: [
  "Boil sweet corn until tender.",
  "Allow the corn to cool completely.",
  "Wash tomatoes and onions carefully.",
  "Chop tomatoes into small cubes.",
  "Finely slice the onions.",
  "Take a large mixing bowl.",
  "Add corn, tomatoes, and onions.",
  "Pour fresh lemon juice over the mixture.",
  "Mix gently and season with salt if desired.",
  "Serve chilled for the best taste."
  ],
  ),

  RecipeModel(
  id: "9",
  title: "Cabbage Stir Fry",
  banglaTitle: "বাঁধাকপি ভাজি",
  image: "assets/images/cabbage.jpg",
  category: "Dinner",
  calories: 140,
  time: 15,
  ingredients: [
  "Cabbage",
  "Onion",
  "Oil",
  "Salt"
  ],
  steps: [
  "Wash the cabbage thoroughly.",
  "Slice the cabbage into thin strips.",
  "Peel and finely chop the onion.",
  "Heat oil in a frying pan.",
  "Add onions and sauté until soft.",
  "Add the sliced cabbage to the pan.",
  "Stir continuously on medium heat.",
  "Add salt according to taste.",
  "Cook until the cabbage becomes tender.",
  "Serve hot as a side dish with rice."
  ],
  ),

  RecipeModel(
  id: "10",
  title: "Potato Curry",
  banglaTitle: "আলুর তরকারি",
  image: "assets/images/potato_curry.jpg",
  category: "Lunch",
  calories: 260,
  time: 25,
  ingredients: [
  "Potato",
  "Onion",
  "Turmeric",
  "Spices"
  ],
  steps: [
  "Wash, peel, and cut potatoes into cubes.",
  "Heat a small amount of oil in a cooking pot.",
  "Add chopped onions and fry until golden brown.",
  "Add turmeric and other spices.",
  "Stir well to release the aroma.",
  "Add potato cubes and mix with the spices.",
  "Pour water into the pot.",
  "Cover and cook until potatoes become soft.",
  "Adjust salt according to taste.",
  "Serve hot with rice, roti, or paratha."
  ],
  ),

  RecipeModel(
    id: "11",
    title: "Banana Smoothie",
    banglaTitle: "কলা স্মুদি",
    image: "assets/images/smoothie.jpg",
    category: "Breakfast",
    calories: 180,
    time: 5,
    ingredients: [
      "Banana",
      "Milk",
      "Honey"
    ],
  steps: [
  "Peel the ripe banana and cut it into small slices.",
  "Add the banana slices into a blender jar.",
  "Pour chilled milk into the blender.",
  "Add one tablespoon of honey for natural sweetness.",
  "Optionally add a few ice cubes for a colder smoothie.",
  "Blend all ingredients for 1-2 minutes until smooth.",
  "Check the consistency and add more milk if needed.",
  "Blend again for a few seconds.",
  "Pour the smoothie into a serving glass.",
  "Serve immediately while fresh and chilled."],
  ),

  RecipeModel(
    id: "12",
    title: "Tomato Rice",
    banglaTitle: "টমেটো ভাত",
    image: "assets/images/tomato_rice.jpg",
    category: "Lunch",
    calories: 290,
    time: 20,
    ingredients: [
      "Rice",
      "Tomato",
      "Onion",
      "Spices"
    ],
  steps: [
  "Wash the rice thoroughly and cook it separately.",
  "Allow the cooked rice to cool slightly.",
  "Heat a small amount of oil in a pan.",
  "Add chopped onions and sauté until golden.",
  "Add chopped tomatoes and cook until soft.",
  "Mix turmeric, chili powder, and salt.",
  "Cook the tomato mixture until the oil separates.",
  "Add the cooked rice and mix gently.",
  "Cook on low heat for 5 minutes.",
  "Serve hot with salad or yogurt."
  ],
  ),

  RecipeModel(
    id: "13",
    title: "Lentil Soup",
    banglaTitle: "ডাল স্যুপ",
    image: "assets/images/lentil_soup.jpg",
    category: "Dinner",
    calories: 180,
    time: 25,
    ingredients: [
      "Lentils",
      "Garlic",
      "Onion"
    ],
      steps: [
      "Wash the lentils thoroughly with clean water.",
  "Boil the lentils until soft and tender.",
  "Heat a small amount of oil in a pot.",
  "Add chopped garlic and sauté lightly.",
  "Add chopped onion and cook until translucent.",
  "Pour the boiled lentils into the pot.",
  "Add salt and black pepper to taste.",
  "Simmer the soup for 10 minutes.",
  "Stir occasionally to prevent sticking.",
  "Serve hot with fresh coriander on top."
  ],
  ),

  RecipeModel(
    id: "14",
    title: "Sprout Salad",
    banglaTitle: "অঙ্কুর সালাদ",
    image: "assets/images/sprout_salad.jpg",
    category: "Salad",
    calories: 160,
    time: 10,
    ingredients: [
      "Sprouts",
      "Onion",
      "Tomato"
    ],
  steps: [
  "Wash the sprouts thoroughly.",
  "Drain excess water completely.",
  "Chop onion into small pieces.",
  "Dice fresh tomatoes evenly.",
  "Place sprouts in a large mixing bowl.",
  "Add chopped onion and tomatoes.",
  "Season with salt and black pepper.",
  "Add fresh lemon juice for flavor.",
  "Mix all ingredients thoroughly.",
  "Serve immediately while fresh."
  ],
  ),

  RecipeModel(
    id: "15",
    title: "Sweet Potato Mash",
    banglaTitle: "মিষ্টি আলু মাখা",
    image: "assets/images/sweet_potato.jpg",
    category: "Dinner",
    calories: 190,
    time: 20,
    ingredients: [
      "Sweet potato",
      "Salt",
      "Pepper"
    ],
      steps: [
  "Wash the sweet potatoes carefully.",
  "Peel the skin using a vegetable peeler.",
  "Cut into medium-sized pieces.",
  "Boil the pieces until very soft.",
  "Drain the excess water.",
  "Transfer the potatoes to a bowl.",
  "Mash thoroughly using a fork or masher.",
  "Add salt and black pepper.",
  "Mix until smooth and creamy.",
  "Serve warm as a healthy side dish."
  ],
  ),

  RecipeModel(
    id: "16",
    title: "Vegetable Noodles",
    banglaTitle: "সবজি নুডলস",
    image: "assets/images/noodles.jpg",
    category: "Dinner",
    calories: 320,
    time: 20,
    ingredients: [
      "Noodles",
      "Carrot",
      "Cabbage"
    ],
  steps: [
  "Boil water in a large pot.",
  "Cook the noodles according to package instructions.",
  "Drain and set aside.",
  "Heat a small amount of oil in a pan.",
  "Add sliced carrots and cabbage.",
  "Stir-fry vegetables for 3-4 minutes.",
  "Add salt and pepper to taste.",
  "Mix the cooked noodles with vegetables.",
  "Toss everything well for even coating.",
  "Serve hot and enjoy."
  ],
  ),

  RecipeModel(
    id: "17",
    title: "Beetroot Salad",
    banglaTitle: "বিট সালাদ",
    image: "assets/images/beet_salad.jpg",
    category: "Salad",
    calories: 170,
    time: 10,
    ingredients: [
      "Beetroot",
      "Lemon",
      "Salt"
    ],
  steps: [
  "Wash the beetroot thoroughly.",
  "Boil the beetroot until tender.",
  "Allow it to cool completely.",
  "Peel off the outer skin.",
  "Cut into thin slices or cubes.",
  "Place the beetroot in a mixing bowl.",
  "Add a pinch of salt.",
  "Squeeze fresh lemon juice over the salad.",
  "Mix gently to combine flavors.",
  "Serve fresh and chilled."
  ],
  ),

  RecipeModel(
    id: "18",
    title: "Upma",
    banglaTitle: "উপমা",
    image: "assets/images/upma.jpg",
    category: "Breakfast",
    calories: 250,
    time: 20,
    ingredients: [
      "Semolina",
      "Vegetables",
      "Oil"
    ],
      steps: [
      "Dry roast semolina until light golden.",
  "Remove and keep aside.",
  "Heat oil in a pan.",
  "Add chopped vegetables and sauté.",
  "Cook vegetables until slightly soft.",
  "Add water and bring to a boil.",
  "Season with salt.",
  "Slowly add roasted semolina while stirring.",
  "Cook until the mixture thickens.",
  "Serve hot with fresh coriander."
  ],
  ),

  RecipeModel(
    id: "19",
    title: "Fruit Yogurt Bowl",
    banglaTitle: "ফল দই বাটি",
    image: "assets/images/yogurt.jpg",
    category: "Breakfast",
    calories: 210,
    time: 5,
    ingredients: [
      "Yogurt",
      "Banana",
      "Apple"
    ],
  steps: [
  "Wash all fruits thoroughly.",
  "Slice banana into small pieces.",
  "Dice the apple into bite-sized cubes.",
  "Take fresh yogurt in a serving bowl.",
  "Whisk the yogurt until smooth.",
  "Add banana slices to the yogurt.",
  "Add apple cubes evenly.",
  "Mix gently without crushing the fruits.",
  "Optionally drizzle a little honey.",
  "Serve immediately while chilled."
  ],
  ),

  RecipeModel(
    id: "20",
    title: "Chana Masala",
    banglaTitle: "ছোলা মসলা",
    image: "assets/images/chana.jpg",
    category: "Lunch",
    calories: 310,
    time: 30,
    ingredients: [
      "Chickpeas",
      "Onion",
      "Tomato",
      "Spices"
    ],
  steps: [
  "Soak chickpeas overnight in water.",
  "Boil the chickpeas until soft.",
  "Heat a small amount of oil in a pan.",
  "Add chopped onions and sauté until golden.",
  "Add chopped tomatoes and cook until soft.",
  "Mix turmeric, chili powder, and cumin.",
  "Cook the masala until fragrant.",
  "Add boiled chickpeas to the pan.",
  "Simmer for 10 minutes so flavors combine.",
  "Serve hot with rice or roti."
  ],
  ),

    RecipeModel(
      id: "21",
      title: "Bottle Gourd Curry",
      banglaTitle: "লাউ তরকারি",
      image: "assets/images/lau_curry.jpg",
      category: "Lunch",
      calories: 180,
      time: 35,
      ingredients: [
        "Bottle gourd",
        "Onion",
        "Garlic",
        "Turmeric",
        "Green chili",
        "Salt"
      ],
      steps: [
        "Wash the bottle gourd thoroughly.",
        "Peel and cut into cubes.",
        "Slice onions and garlic.",
        "Heat a small amount of oil.",
        "Fry onions until golden.",
        "Add garlic and chili.",
        "Add bottle gourd pieces.",
        "Mix turmeric and salt.",
        "Cook covered for 20 minutes.",
        "Serve hot with rice."
      ],
    ),

    RecipeModel(
      id: "22",
      title: "Red Spinach Bhaji",
      banglaTitle: "লাল শাক ভাজি",
      image: "assets/images/lal_shak.jpg",
      category: "Dinner",
      calories: 120,
      time: 20,
      ingredients: [
        "Red spinach",
        "Garlic",
        "Onion",
        "Salt"
      ],
      steps: [
        "Wash spinach thoroughly.",
        "Drain excess water.",
        "Chop into small pieces.",
        "Slice onion and garlic.",
        "Heat oil in pan.",
        "Saute garlic first.",
        "Add onions and fry.",
        "Add spinach leaves.",
        "Cook until water dries.",
        "Serve warm."
      ],
    ),

    RecipeModel(
      id: "23",
      title: "Pumpkin Mash",
      banglaTitle: "মিষ্টি কুমড়া ভর্তা",
      image: "assets/images/pumpkin_mash.jpg",
      category: "Lunch",
      calories: 160,
      time: 25,
      ingredients: [
        "Pumpkin",
        "Mustard oil",
        "Green chili",
        "Salt"
      ],
      steps: [
        "Cut pumpkin into cubes.",
        "Boil until soft.",
        "Drain water completely.",
        "Mash with spoon.",
        "Add salt.",
        "Add chopped chili.",
        "Add mustard oil.",
        "Mix thoroughly.",
        "Taste and adjust seasoning.",
        "Serve with rice."
      ],
    ),

    RecipeModel(
      id: "24",
      title: "Mixed Vegetable Curry",
      banglaTitle: "মিশ্র সবজি",
      image: "assets/images/mixed_veg.jpg",
      category: "Lunch",
      calories: 220,
      time: 30,
      ingredients: [
        "Carrot",
        "Beans",
        "Potato",
        "Cauliflower",
        "Salt",
        "Turmeric"
      ],
      steps: [
        "Wash all vegetables.",
        "Cut into equal pieces.",
        "Heat oil in pan.",
        "Add spices.",
        "Add potatoes first.",
        "Add remaining vegetables.",
        "Mix well.",
        "Cook covered.",
        "Add little water if needed.",
        "Serve hot."
      ],
    ),

    RecipeModel(
      id: "25",
      title: "Green Papaya Curry",
      banglaTitle: "কাঁচা পেঁপে তরকারি",
      image: "assets/images/papaya_curry.jpg",
      category: "Lunch",
      calories: 170,
      time: 35,
      ingredients: [
        "Green papaya",
        "Onion",
        "Garlic",
        "Turmeric"
      ],
      steps: [
        "Peel green papaya.",
        "Cut into cubes.",
        "Wash thoroughly.",
        "Heat oil.",
        "Fry onion and garlic.",
        "Add papaya pieces.",
        "Add turmeric.",
        "Cook covered.",
        "Stir occasionally.",
        "Serve with rice."
      ],
    ),

    RecipeModel(
      id: "26",
      title: "Moong Dal Soup",
      banglaTitle: "মুগ ডাল স্যুপ",
      image: "assets/images/moong_soup.jpg",
      category: "Dinner",
      calories: 190,
      time: 25,
      ingredients: [
        "Moong dal",
        "Garlic",
        "Pepper",
        "Salt"
      ],
      steps: [
        "Wash dal properly.",
        "Boil until soft.",
        "Mash lightly.",
        "Add water.",
        "Add garlic.",
        "Cook for 10 minutes.",
        "Add pepper.",
        "Add salt.",
        "Stir well.",
        "Serve warm."
      ],
    ),

    RecipeModel(
      id: "27",
      title: "Cucumber Yogurt Salad",
      banglaTitle: "শসা দই সালাদ",
      image: "assets/images/cucumber_yogurt.jpg",
      category: "Salad",
      calories: 140,
      time: 10,
      ingredients: [
        "Cucumber",
        "Yogurt",
        "Salt",
        "Mint"
      ],
      steps: [
        "Wash cucumber.",
        "Peel if desired.",
        "Cut into slices.",
        "Take yogurt in bowl.",
        "Whisk smoothly.",
        "Add cucumber.",
        "Add mint leaves.",
        "Add salt.",
        "Mix gently.",
        "Serve chilled."
      ],
    ),

    RecipeModel(
      id: "28",
      title: "Vegetable Semai",
      banglaTitle: "সবজি সেমাই",
      image: "assets/images/veg_semai.jpg",
      category: "Breakfast",
      calories: 250,
      time: 20,
      ingredients: [
        "Semai",
        "Carrot",
        "Beans",
        "Peas"
      ],
      steps: [
        "Roast semai lightly.",
        "Cut vegetables finely.",
        "Heat oil.",
        "Cook vegetables.",
        "Add water.",
        "Bring to boil.",
        "Add semai.",
        "Cook until soft.",
        "Mix well.",
        "Serve warm."
      ],
    ),

    RecipeModel(
      id: "29",
      title: "Banana Oats Pancake",
      banglaTitle: "কলা ওটস প্যানকেক",
      image: "assets/images/oats_pancake.jpg",
      category: "Breakfast",
      calories: 220,
      time: 15,
      ingredients: [
        "Banana",
        "Oats",
        "Milk"
      ],
      steps: [
        "Mash banana.",
        "Blend oats.",
        "Mix together.",
        "Add milk.",
        "Make batter.",
        "Heat pan.",
        "Pour batter.",
        "Cook one side.",
        "Flip carefully.",
        "Serve hot."
      ],
    ),

    RecipeModel(
      id: "30",
      title: "Vegetable Chotpoti",
      banglaTitle: "সবজি চটপটি",
      image: "assets/images/chotpoti.jpg",
      category: "Dinner",
      calories: 280,
      time: 30,
      ingredients: [
        "Peas",
        "Potato",
        "Tomato",
        "Onion"
      ],
      steps: [
        "Boil peas.",
        "Boil potatoes.",
        "Cut vegetables.",
        "Heat spices.",
        "Add peas.",
        "Add potatoes.",
        "Cook together.",
        "Add tomatoes.",
        "Mix thoroughly.",
        "Serve hot."
      ],
    ),

    RecipeModel(
      id: "31",
      title: "Data Chorchori",
      banglaTitle: "ডাটা চচ্চড়ি",
      image: "assets/images/data_chorchori.jpg",
      category: "Lunch",
      calories: 170,
      time: 30,
      ingredients: [
        "Drumsticks",
        "Potato",
        "Onion",
        "Turmeric",
        "Green chili",
        "Salt"
      ],
      steps: [
        "Wash drumsticks thoroughly.",
        "Cut into medium pieces.",
        "Peel and cut potatoes.",
        "Slice onions.",
        "Heat oil in a pan.",
        "Fry onions until soft.",
        "Add potatoes and drumsticks.",
        "Add turmeric and salt.",
        "Cook covered for 20 minutes.",
        "Serve hot with rice."
      ],
    ),

    RecipeModel(
      id: "32",
      title: "Pui Shak Vegetable",
      banglaTitle: "পুঁই শাক সবজি",
      image: "assets/images/pui_shak.jpg",
      category: "Lunch",
      calories: 160,
      time: 25,
      ingredients: [
        "Pui shak",
        "Pumpkin",
        "Potato",
        "Onion",
        "Salt"
      ],
      steps: [
        "Wash pui shak.",
        "Chop leaves and stems.",
        "Cut pumpkin and potato.",
        "Heat oil.",
        "Fry onions lightly.",
        "Add vegetables.",
        "Add salt.",
        "Cook covered.",
        "Stir occasionally.",
        "Serve warm."
      ],
    ),

    RecipeModel(
      id: "33",
      title: "Vegetarian Shukto",
      banglaTitle: "শুক্তো",
      image: "assets/images/shukto.jpg",
      category: "Lunch",
      calories: 210,
      time: 40,
      ingredients: [
        "Bitter gourd",
        "Potato",
        "Raw banana",
        "Eggplant",
        "Milk"
      ],
      steps: [
        "Wash vegetables.",
        "Cut into strips.",
        "Heat oil.",
        "Fry bitter gourd separately.",
        "Cook other vegetables.",
        "Add spices.",
        "Mix everything.",
        "Pour milk.",
        "Simmer gently.",
        "Serve hot."
      ],
    ),

    RecipeModel(
      id: "34",
      title: "Coriander Lentils",
      banglaTitle: "ধনেপাতা ডাল",
      image: "assets/images/dhonepata_dal.jpg",
      category: "Dinner",
      calories: 190,
      time: 25,
      ingredients: [
        "Lentils",
        "Coriander leaves",
        "Garlic",
        "Salt"
      ],
      steps: [
        "Wash lentils.",
        "Boil until soft.",
        "Chop coriander leaves.",
        "Heat oil.",
        "Fry garlic.",
        "Add boiled dal.",
        "Add salt.",
        "Mix coriander.",
        "Cook 5 minutes.",
        "Serve hot."
      ],
    ),

    RecipeModel(
      id: "35",
      title: "Methi Vegetable Curry",
      banglaTitle: "মেথি সবজি",
      image: "assets/images/methi_curry.jpg",
      category: "Lunch",
      calories: 220,
      time: 30,
      ingredients: [
        "Fenugreek leaves",
        "Potato",
        "Tomato",
        "Onion"
      ],
      steps: [
        "Wash methi leaves.",
        "Chop finely.",
        "Cut vegetables.",
        "Heat oil.",
        "Cook onions.",
        "Add potatoes.",
        "Add tomatoes.",
        "Add methi leaves.",
        "Cook until tender.",
        "Serve warm."
      ],
    ),

    RecipeModel(
      id: "36",
      title: "Cauliflower Roast",
      banglaTitle: "ফুলকপি রোস্ট",
      image: "assets/images/cauliflower_roast.jpg",
      category: "Dinner",
      calories: 200,
      time: 35,
      ingredients: [
        "Cauliflower",
        "Garlic",
        "Pepper",
        "Olive oil"
      ],
      steps: [
        "Wash cauliflower.",
        "Cut florets.",
        "Boil slightly.",
        "Drain water.",
        "Add oil.",
        "Add garlic.",
        "Add pepper.",
        "Bake or roast.",
        "Cook until golden.",
        "Serve hot."
      ],
    ),

    RecipeModel(
      id: "37",
      title: "Vegetable Tehari",
      banglaTitle: "সবজি তেহারি",
      image: "assets/images/tehari.jpg",
      category: "Lunch",
      calories: 330,
      time: 40,
      ingredients: [
        "Rice",
        "Carrot",
        "Potato",
        "Beans",
        "Peas"
      ],
      steps: [
        "Wash rice.",
        "Cut vegetables.",
        "Heat oil.",
        "Add spices.",
        "Add vegetables.",
        "Add rice.",
        "Mix well.",
        "Add water.",
        "Cook covered.",
        "Serve hot."
      ],
    ),

    RecipeModel(
      id: "38",
      title: "Bottle Gourd Leaves Fry",
      banglaTitle: "লাউ শাক ভাজি",
      image: "assets/images/lau_shak.jpg",
      category: "Dinner",
      calories: 110,
      time: 20,
      ingredients: [
        "Bottle gourd leaves",
        "Garlic",
        "Onion",
        "Salt"
      ],
      steps: [
        "Wash leaves.",
        "Chop finely.",
        "Slice onions.",
        "Heat oil.",
        "Add garlic.",
        "Add onions.",
        "Add leaves.",
        "Add salt.",
        "Cook until dry.",
        "Serve hot."
      ],
    ),

    RecipeModel(
      id: "39",
      title: "Okra Fry",
      banglaTitle: "ঢেঁড়স ভাজি",
      image: "assets/images/dherosh.jpg",
      category: "Lunch",
      calories: 130,
      time: 20,
      ingredients: [
        "Okra",
        "Onion",
        "Turmeric",
        "Salt"
      ],
      steps: [
        "Wash okra.",
        "Dry completely.",
        "Cut into slices.",
        "Heat oil.",
        "Add onions.",
        "Add okra.",
        "Add turmeric.",
        "Add salt.",
        "Cook until crisp.",
        "Serve warm."
      ],
    ),

    RecipeModel(
      id: "40",
      title: "Taro Leaf Fry",
      banglaTitle: "কচু শাক ভাজি",
      image: "assets/images/kachu_shak.jpg",
      category: "Lunch",
      calories: 150,
      time: 25,
      ingredients: [
        "Taro leaves",
        "Garlic",
        "Salt",
        "Green chili"
      ],
      steps: [
        "Wash leaves carefully.",
        "Chop finely.",
        "Heat oil.",
        "Add garlic.",
        "Add chili.",
        "Add leaves.",
        "Mix well.",
        "Add salt.",
        "Cook thoroughly.",
        "Serve hot."
      ],
    ),

    RecipeModel(
      id: "41",
      title: "Chicken Vegetable Soup",
      banglaTitle: "চিকেন সবজি স্যুপ",
      image: "assets/images/chicken_soup.jpg",
      category: "Healthy Non-Veg",
      calories: 220,
      time: 30,
      ingredients: [
        "Chicken breast",
        "Carrot",
        "Beans",
        "Cabbage",
        "Garlic",
        "Pepper",
        "Salt"
      ],
      steps: [
        "Wash chicken thoroughly.",
        "Cut into small cubes.",
        "Wash vegetables.",
        "Slice vegetables finely.",
        "Boil chicken in water.",
        "Remove foam from top.",
        "Add vegetables.",
        "Add garlic and pepper.",
        "Cook for 15 minutes.",
        "Serve hot."
      ],
    ),

    RecipeModel(
      id: "42",
      title: "Light Chicken Curry",
      banglaTitle: "হালকা মুরগির ঝোল",
      image: "assets/images/light_chicken.jpg",
      category: "Healthy Non-Veg",
      calories: 260,
      time: 40,
      ingredients: [
        "Chicken",
        "Potato",
        "Onion",
        "Tomato",
        "Turmeric",
        "Salt"
      ],
      steps: [
        "Wash chicken pieces.",
        "Marinate with turmeric.",
        "Slice onions.",
        "Heat little oil.",
        "Cook onions lightly.",
        "Add tomatoes.",
        "Add chicken.",
        "Add potatoes.",
        "Add water.",
        "Cook until tender."
      ],
    ),

    RecipeModel(
      id: "43",
      title: "Grilled Chicken Breast",
      banglaTitle: "গ্রিলড চিকেন ব্রেস্ট",
      image: "assets/images/grilled_chicken.jpg",
      category: "Healthy Non-Veg",
      calories: 240,
      time: 25,
      ingredients: [
        "Chicken breast",
        "Black pepper",
        "Garlic",
        "Lemon juice",
        "Salt"
      ],
      steps: [
        "Clean chicken breast.",
        "Make small cuts.",
        "Mix spices.",
        "Rub spices evenly.",
        "Marinate 30 minutes.",
        "Preheat grill.",
        "Place chicken on grill.",
        "Cook one side.",
        "Flip carefully.",
        "Serve hot."
      ],
    ),

    RecipeModel(
      id: "44",
      title: "Fish Vegetable Stew",
      banglaTitle: "মাছ সবজি স্ট্যু",
      image: "assets/images/fish_stew.jpg",
      category: "Healthy Non-Veg",
      calories: 230,
      time: 35,
      ingredients: [
        "Rui fish",
        "Carrot",
        "Beans",
        "Tomato",
        "Salt"
      ],
      steps: [
        "Wash fish carefully.",
        "Cut vegetables.",
        "Boil vegetables.",
        "Add fish pieces.",
        "Add spices.",
        "Cook gently.",
        "Avoid stirring too much.",
        "Add tomatoes.",
        "Simmer 10 minutes.",
        "Serve warm."
      ],
    ),

    RecipeModel(
      id: "45",
      title: "Steamed Fish",
      banglaTitle: "ভাপা মাছ",
      image: "assets/images/steamed_fish.jpg",
      category: "Healthy Non-Veg",
      calories: 210,
      time: 25,
      ingredients: [
        "Fish",
        "Mustard paste",
        "Green chili",
        "Salt"
      ],
      steps: [
        "Clean fish pieces.",
        "Prepare mustard paste.",
        "Mix salt.",
        "Coat fish evenly.",
        "Add green chili.",
        "Wrap in foil.",
        "Place in steamer.",
        "Steam 20 minutes.",
        "Check tenderness.",
        "Serve hot."
      ],
    ),

    RecipeModel(
      id: "46",
      title: "Egg Vegetable Bhurji",
      banglaTitle: "ডিম সবজি ভুর্জি",
      image: "assets/images/egg_bhurji.jpg",
      category: "Healthy Non-Veg",
      calories: 190,
      time: 15,
      ingredients: [
        "Egg",
        "Tomato",
        "Onion",
        "Capsicum",
        "Salt"
      ],
      steps: [
        "Beat eggs.",
        "Chop vegetables.",
        "Heat little oil.",
        "Cook onions.",
        "Add tomatoes.",
        "Add capsicum.",
        "Pour eggs.",
        "Stir continuously.",
        "Cook thoroughly.",
        "Serve hot."
      ],
    ),

    RecipeModel(
      id: "47",
      title: "Tuna Salad",
      banglaTitle: "টুনা সালাদ",
      image: "assets/images/tuna_salad.jpg",
      category: "Healthy Non-Veg",
      calories: 200,
      time: 10,
      ingredients: [
        "Tuna",
        "Cucumber",
        "Tomato",
        "Lettuce",
        "Lemon"
      ],
      steps: [
        "Wash vegetables.",
        "Slice cucumber.",
        "Slice tomatoes.",
        "Prepare lettuce.",
        "Place in bowl.",
        "Add tuna.",
        "Add lemon juice.",
        "Mix gently.",
        "Adjust seasoning.",
        "Serve fresh."
      ],
    ),

    RecipeModel(
      id: "48",
      title: "Chicken Khichuri",
      banglaTitle: "চিকেন খিচুড়ি",
      image: "assets/images/chicken_khichuri.jpg",
      category: "Healthy Non-Veg",
      calories: 340,
      time: 45,
      ingredients: [
        "Rice",
        "Lentils",
        "Chicken",
        "Carrot",
        "Peas"
      ],
      steps: [
        "Wash rice and lentils.",
        "Clean chicken.",
        "Heat oil lightly.",
        "Cook chicken briefly.",
        "Add vegetables.",
        "Add rice.",
        "Add lentils.",
        "Pour water.",
        "Cook until soft.",
        "Serve hot."
      ],
    ),

    RecipeModel(
      id: "49",
      title: "Boiled Egg Curry",
      banglaTitle: "ডিমের ঝোল",
      image: "assets/images/egg_curry.jpg",
      category: "Healthy Non-Veg",
      calories: 250,
      time: 30,
      ingredients: [
        "Egg",
        "Potato",
        "Tomato",
        "Onion",
        "Turmeric"
      ],
      steps: [
        "Boil eggs.",
        "Peel eggs.",
        "Cut potatoes.",
        "Cook onions.",
        "Add tomatoes.",
        "Add spices.",
        "Add potatoes.",
        "Add water.",
        "Add eggs.",
        "Cook thoroughly."
      ],
    ),

    RecipeModel(
      id: "50",
      title: "Bengali Chicken Stew",
      banglaTitle: "বাংলা চিকেন স্ট্যু",
      image: "assets/images/chicken_stew.jpg",
      category: "Healthy Non-Veg",
      calories: 280,
      time: 40,
      ingredients: [
        "Chicken",
        "Carrot",
        "Potato",
        "Beans",
        "Pepper"
      ],
      steps: [
        "Wash chicken.",
        "Prepare vegetables.",
        "Boil water.",
        "Add chicken.",
        "Cook 10 minutes.",
        "Add vegetables.",
        "Add pepper.",
        "Cook slowly.",
        "Check tenderness.",
        "Serve warm."
      ],
    ),

    RecipeModel(
      id: "51",
      title: "Oats Vegetable Upma",
      banglaTitle: "ওটস সবজি উপমা",
      image: "assets/images/oats_upma.jpg",
      category: "Breakfast",
      calories: 220,
      time: 20,
      ingredients: [
        "Oats",
        "Carrot",
        "Beans",
        "Peas",
        "Onion",
        "Salt",
      ],
      steps: [
        "Dry roast the oats for a few minutes.",
        "Wash and chop all vegetables finely.",
        "Heat a small amount of oil in a pan.",
        "Add onions and cook until soft.",
        "Add chopped vegetables and stir well.",
        "Cook vegetables until slightly tender.",
        "Add water and bring to a boil.",
        "Mix the roasted oats gradually.",
        "Cook until the mixture thickens.",
        "Serve hot as a healthy breakfast.",
      ],
    ),

    RecipeModel(
      id: "52",
      title: "Egg Vegetable Omelette",
      banglaTitle: "সবজি অমলেট",
      image: "assets/images/veg_omelette.jpg",
      category: "Breakfast",
      calories: 180,
      time: 15,
      ingredients: [
        "Eggs",
        "Onion",
        "Tomato",
        "Capsicum",
        "Green chili",
        "Salt",
      ],
      steps: [
        "Crack eggs into a mixing bowl.",
        "Chop vegetables into small pieces.",
        "Add vegetables to the eggs.",
        "Add salt and mix thoroughly.",
        "Heat a non-stick pan lightly.",
        "Pour the egg mixture evenly.",
        "Cook on low heat for several minutes.",
        "Flip carefully when golden brown.",
        "Cook the other side completely.",
        "Serve hot with whole wheat bread.",
      ],
    ),

    RecipeModel(
      id: "53",
      title: "Banana Peanut Smoothie",
      banglaTitle: "কলা ও বাদাম স্মুদি",
      image: "assets/images/banana_peanut_smoothie.jpg",
      category: "Breakfast",
      calories: 250,
      time: 5,
      ingredients: [
        "Banana",
        "Milk",
        "Peanut butter",
        "Honey",
      ],
      steps: [
        "Peel and slice the banana.",
        "Add banana into a blender.",
        "Pour milk into the blender.",
        "Add peanut butter.",
        "Add a small amount of honey.",
        "Blend until smooth.",
        "Check the consistency.",
        "Add more milk if needed.",
        "Blend again briefly.",
        "Serve immediately while chilled.",
      ],
    ),

    RecipeModel(
      id: "54",
      title: "Vegetable Suji Khichuri",
      banglaTitle: "সবজি সুজি খিচুড়ি",
      image: "assets/images/suji_khichuri.jpg",
      category: "Breakfast",
      calories: 240,
      time: 20,
      ingredients: [
        "Semolina",
        "Carrot",
        "Beans",
        "Peas",
        "Onion",
        "Salt",
      ],
      steps: [
        "Dry roast the semolina lightly.",
        "Chop all vegetables finely.",
        "Heat a small amount of oil.",
        "Cook onions until soft.",
        "Add vegetables and stir well.",
        "Cook vegetables for a few minutes.",
        "Add water and bring to a boil.",
        "Slowly add roasted semolina.",
        "Stir continuously to avoid lumps.",
        "Serve warm and nutritious.",
      ],
    ),

    RecipeModel(
      id: "55",
      title: "Chicken Oats Porridge",
      banglaTitle: "চিকেন ওটস পোরিজ",
      image: "assets/images/chicken_oats.jpg",
      category: "Breakfast",
      calories: 280,
      time: 25,
      ingredients: [
        "Oats",
        "Chicken breast",
        "Carrot",
        "Onion",
        "Salt",
        "Black pepper",
      ],
      steps: [
        "Boil chicken breast until tender.",
        "Shred the chicken into small pieces.",
        "Cook chopped onions in a pan.",
        "Add carrots and cook briefly.",
        "Pour water into the pan.",
        "Add oats and stir well.",
        "Mix in the shredded chicken.",
        "Cook until thick and creamy.",
        "Season with salt and pepper.",
        "Serve hot as a protein-rich breakfast.",
      ],
    ),

    RecipeModel(
      id: "56",
      title: "Spinach Corn Soup",
      banglaTitle: "পালং ও ভুট্টা স্যুপ",
      image: "assets/images/spinach_corn_soup.jpg",
      category: "Soup",
      calories: 170,
      time: 20,
      ingredients: [
        "Spinach",
        "Sweet corn",
        "Garlic",
        "Onion",
        "Salt",
        "Black pepper",
      ],
      steps: [
        "Wash spinach leaves carefully.",
        "Boil spinach for a few minutes.",
        "Blend spinach into a smooth paste.",
        "Cook garlic and onion lightly.",
        "Add corn and stir.",
        "Pour spinach puree into the pot.",
        "Add water and seasonings.",
        "Cook for several minutes.",
        "Stir until smooth.",
        "Serve hot and fresh.",
      ],
    ),

    RecipeModel(
      id: "57",
      title: "Apple Carrot Salad",
      banglaTitle: "আপেল গাজর সালাদ",
      image: "assets/images/apple_carrot_salad.jpg",
      category: "Salad",
      calories: 150,
      time: 10,
      ingredients: [
        "Apple",
        "Carrot",
        "Lemon juice",
        "Honey",
        "Raisins",
      ],
      steps: [
        "Wash the apple and carrot.",
        "Peel and grate the carrot.",
        "Cut the apple into small cubes.",
        "Combine both in a bowl.",
        "Add raisins for sweetness.",
        "Drizzle lemon juice.",
        "Add a small amount of honey.",
        "Mix thoroughly.",
        "Chill briefly if desired.",
        "Serve as a healthy snack.",
      ],
    ),

    RecipeModel(
      id: "58",
      title: "Thai Vegetable Soup",
      banglaTitle: "থাই সবজি স্যুপ",
      image: "assets/images/thai_soup.jpg",
      category: "Soup",
      calories: 180,
      time: 25,
      ingredients: [
        "Carrot",
        "Mushroom",
        "Capsicum",
        "Baby corn",
        "Garlic",
        "Ginger",
        "Lemon juice",
        "Soy sauce",
        "Salt",
      ],
      steps: [
        "Wash and slice all vegetables into thin strips.",
        "Heat a pot and add a small amount of oil.",
        "Saute garlic and ginger until fragrant.",
        "Add carrots and baby corn first.",
        "Cook for two to three minutes.",
        "Add mushrooms and capsicum.",
        "Pour water or vegetable stock into the pot.",
        "Add soy sauce and a little salt.",
        "Simmer for ten minutes until vegetables are tender.",
        "Add lemon juice before serving and enjoy hot.",
      ],
    ),

    RecipeModel(
      id: "59",
      title: "Sweet Corn Soup",
      banglaTitle: "সুইট কর্ন স্যুপ",
      image: "assets/images/sweet_corn_soup.jpg",
      category: "Soup",
      calories: 170,
      time: 20,
      ingredients: [
        "Sweet corn",
        "Carrot",
        "Spring onion",
        "Garlic",
        "Corn flour",
        "Salt",
        "Black pepper",
      ],
      steps: [
        "Boil sweet corn until soft and tender.",
        "Blend half of the corn into a smooth paste.",
        "Keep the remaining corn kernels aside.",
        "Heat water or vegetable stock in a pot.",
        "Add blended corn and whole kernels.",
        "Add finely chopped carrots and garlic.",
        "Cook for five to seven minutes.",
        "Mix corn flour with water and add slowly.",
        "Stir continuously until the soup thickens.",
        "Season with salt and black pepper before serving.",
      ],
    ),

    RecipeModel(
      id: "60",
      title: "Chicken Sweet Corn Soup",
      banglaTitle: "চিকেন সুইট কর্ন স্যুপ",
      image: "assets/images/chicken_corn_soup.jpg",
      category: "Soup",
      calories: 220,
      time: 25,
      ingredients: [
        "Chicken breast",
        "Sweet corn",
        "Egg",
        "Garlic",
        "Corn flour",
        "Salt",
        "Black pepper",
      ],
      steps: [
        "Boil chicken breast until fully cooked.",
        "Shred the chicken into small pieces.",
        "Blend half of the sweet corn.",
        "Heat chicken stock in a pot.",
        "Add blended corn and whole corn kernels.",
        "Add shredded chicken and cook well.",
        "Mix corn flour with water and stir into the soup.",
        "Slowly pour beaten egg while stirring continuously.",
        "Season with salt and black pepper.",
        "Serve hot as a nutritious meal.",
      ],
    ),

  ];
}
