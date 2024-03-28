Life.create_and_start

# 開発用

cat1234 = Caterpillar.create_and_start!("1234")
Timecop.freeze(15.minute.from_now)
cat1234.finish

cat1324 = Caterpillar.create_and_start!("1324")
Timecop.freeze(5.minute.from_now)
cat1324.finish

cat1342 = Caterpillar.create_and_start!("1342")
Timecop.freeze(60.minute.from_now)
cat1342.finish
