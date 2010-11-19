require 'spec_helper'

describe User do
  it 'can be created' do
    lambda {
      User.create(:first_name => "Joe", :last_name => "Smith")
    }.should change(User, :count).by(1)
  end

  context "is not valid" do
    #  subject { User.new }  -- not strictly necessary so long we have describe User up top

    [:first_name, :last_name].each do |attr|
      it "without #{attr}" do
        subject.should_not be_valid
        subject.errors[attr].should_not be_empty
      end
    end
  end

  context "full_name" do

    it 'has the method' do
      User.new.should respond_to(:full_name)
    end

    it 'returns first_name + last_name as middle name' do
      u = User.new(:first_name => "Joe", :last_name => "Smith")
      u.full_name.should == 'Joe Smith'
    end

    it 'includes middle name when present' do
      u = User.new(:first_name => "Joe", :middle_name => "M", :last_name => "Smith")
      u.full_name.should == "Joe M Smith"
    end

  end

  context "associations --" do
    it 'has many shipping addresses' do
      subject.should respond_to(:shipping_addresses)
    end

    it 'can create a shipping address' do
      subject.attributes = {:first_name => "Joe", :last_name => "Smith"}
      subject.save!
      lambda {
        addr = subject.shipping_addresses.create(:street => "123 Main St", :city => "San Francisco", :state => "CA", :zip => "94321")
        p addr.errors.full_messages
      }.should change(ShippingAddress,:count).by(1)
    end

    it 'is valid with in-memory shipping address' do
      subject.attributes = {:first_name => "Joe", :last_name => "Smith"}
      subject.shipping_addresses.build(:street => "123 Main St", :city => "San Francisco", :state => "CA", :zip => "94321")
      subject.valid?
      subject.should be_valid
    end


    it 'has many orders' do
      subject.should respond_to(:orders)
    end
    
    it 'can create an order, with item(s)' do
      subject.attributes = {:first_name => "Joe", :last_name => "Smith"}
      subject.save!
      lambda {
        order = subject.orders.create(:items => [Factory(:item)])
        p order.errors.full_messages
      }.should change(Order,:count).by(1)
    end

  end

  describe "Custom Finders" do

    before do
      User.delete_all
      @anna = Factory(:user, :first_name => "Anna",  :last_name => "Jones")
      @peter= Factory(:user, :first_name => "Peter", :last_name => "Miller")
      @jona = Factory(:user, :first_name => "Jona",  :last_name => "Smith")
    end

    it 'has a method find_by_beginning_of_name' do
      User.should respond_to(:by_names_starting_with)
    end

    it 'finds all records whose first or last name starts with the given letters' do
      User.by_names_starting_with("Jon").all.should == [@anna, @jona]
    end

  end
  
  describe "custom finders for items"  do
    before do
      @gamer = Factory(:user, :first_name => "Mr", :last_name => "Gamer")
      @mom = Factory(:user, :first_name => "Mrs", :last_name => "Mom")
      
      @xbox = Factory(:item, :name => "X-Box", :price => 200.00)
      @kinnect = Factory(:item, :name => "Kinnect", :price => 149.00)
      @wii = Factory(:item, :name => "Wii", :price => 149.99)
      @ps3 = Factory(:item, :name => "PS3", :price => 179.99)
      
      @order1 = Factory(:order, :items => [@xbox, @kinnect], :user => @gamer)
      @order2 = Factory(:order, :items => [@ps3], :user => @gamer)
      @order3 = Factory(:order, :items => [@wii], :user => @mom)
    end
    
    it 'finds all the items bought by user' do
      @gamer.my_items.should == [@xbox, @kinnect, @ps3]

    end
    
  end
  
  
end
