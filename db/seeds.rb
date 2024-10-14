# Clear existing data
puts "Clearing existing data..."
# Shop.destroy_all
# Industry.destroy_all

# Create industries
puts "Creating industries..."
# industries = [
#   "Technology",
#   "Fashion",
#   "Food & Beverage",
#   "Home & Garden",
#   "Sports & Outdoors"
# ].map { |name| Industry.create!(name: name) }

# Create shops
puts "Creating shops..."
shops_data = [
  { name: "葛葉ラーメン", url: "https://maps.app.goo.gl/uuVdbCPZxFDdPhSd8" },
  # { name: "FashionFrenzy", url: "https://fashionfrenzy.com", industry: industries[1] },
  # { name: "Tasty Treats", url: "https://tastytreats.com", industry: industries[2] },
  # { name: "GreenThumb", url: "https://greenthumb.com", industry: industries[3] },
  # { name: "ActiveLife", url: "https://activelife.com", industry: industries[4] },
  # { name: "Byte Bazaar", url: "https://bytebazaar.com", industry: industries[0] },
  # { name: "Chic Boutique", url: "https://chicboutique.com", industry: industries[1] },
  # { name: "Gourmet Galaxy", url: "https://gourmetgalaxy.com", industry: industries[2] },
  # { name: "Cozy Corner", url: "https://cozycorner.com", industry: industries[3] },
  # { name: "Fitness Fanatics", url: "https://fitnessfanatics.com", industry: industries[4] }
]

Shop.create!(shops_data)

puts "Seed data created successfully!"
# puts "Created #{Industry.count} industries and #{Shop.count} shops."
