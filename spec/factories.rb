Factory.define(:user) do |u|
  u.first_name "Jona"
  u.last_name "Smith"
end

Factory.define(:shipping_address) do |s|
  s.street "123 Main"
  s.city "San Francisco"
  s.state "CA"
  s.zip "94321"
  s.association :user
end

Factory.define(:order) do |o|
  o.association :user
end

Factory.define(:item) do |i|
  i.name "Box"
  i.description "A very nice, big box."
  i.price 10.02
end