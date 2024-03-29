Life.create_and_start

# 開発用

# いもむし

cat1234 = Caterpillar.create_and_start!("1234")
Timecop.freeze(15.minute.from_now)
cat1234.finish

cat1324 = Caterpillar.create_and_start!("1324")
Timecop.freeze(5.minute.from_now)
cat1324.finish

cat1342 = Caterpillar.create_and_start!("1342")
Timecop.freeze(60.minute.from_now)
cat1342.finish

# ハノン
hanon1_1CM = Hanon.create_and_start!(1, "1:CM")
Timecop.freeze(15.minute.from_now)
hanon1_1CM.finish

hanon3_5DSharpm = Hanon.create_and_start!(3, "5:D#m")
Timecop.freeze(5.minute.from_now)
hanon3_5DSharpm.finish

hanon1_3Cm = Hanon.create_and_start!(1, "1:Cm")
Timecop.freeze(15.minute.from_now)
hanon1_3Cm.finish
