Life.create_and_start

# 開発用

# いもむし

cat1234 = Caterpillar.create_and_start! pattern: "1234"
Timecop.freeze(15.minute.from_now)
cat1234.finish

cat1324 = Caterpillar.create_and_start! pattern: "1324"
Timecop.freeze(5.minute.from_now)
cat1324.finish

cat1342 = Caterpillar.create_and_start! pattern: "1342"
Timecop.freeze(60.minute.from_now)
cat1342.finish

# ハノン
hanon1_1CM = Hanon.create_and_start! num: 1, pattern: "1:CM"
Timecop.freeze(15.minute.from_now)
hanon1_1CM.finish

hanon3_5DSharpm = Hanon.create_and_start! num: 3, pattern: "5:D#m"
Timecop.freeze(5.minute.from_now)
hanon3_5DSharpm.finish

hanon1_3Cm = Hanon.create_and_start! num: 1, pattern: "1:Cm"
Timecop.freeze(15.minute.from_now)
hanon1_3Cm.finish

# Food
potate = Food.create! name: "北海道産じゃがいも", abb_name: "じゃがいも", price: 100
onion = Food.create! name: "国産玉ねぎ", abb_name: "玉ねぎ", price: 50
meron = Food.create! name: "国産メロン", abb_name: "メロン", price: 300
carrote = Food.create! name: "国産にんじん", abb_name: "にんじん", price: 120
chicken = Food.create! name: "国産鶏もも肉", abb_name: "鶏もも肉", price: 0.8
pine = Food.create! name: "国産パイナップル", abb_name: "パイナップル", price: 200

# FoodMenu
oyakodon = FoodMenu.create! name: "親子丼"
oyakodon.add_food(potate.id, 2)
oyakodon.add_food(onion.id, 0.5)
oyakodon.add_food(carrote.id, 1)
oyakodon.add_food(chicken.id, 150)
