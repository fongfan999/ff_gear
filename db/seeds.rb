# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

unless Category.exists?(name: "Tai nghe")
  Category.create(name: "Tai nghe", color: "#0089fa")
end

unless Category.exists?(name: "Bàn phím")
  Category.create(name: "Bàn phím", color: "#ff002b")
end

unless Category.exists?(name: "Chuột")
  Category.create(name: "Chuột", color: "#ffa900")
end

unless Category.exists?(name: "Khác")
  Category.create(name: "Khác", color: "#00a753")
end

if Report.count == 0
  Report.create(name: "Sản phẩm đã bán")
  Report.create(name: "Không liên lạc được")
  Report.create(name: "Trùng lặp", public: true)
  Report.create(name: "Lừa đảo", public: true)
  Report.create(name: "Hàng hoá bị cấm lưu thông", public: true)
end
