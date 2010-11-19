require 'spec_helper'

describe Item do
  it 'can be created' do
    lambda {
      Item.create(:orders => [Factory(:order)], :name => "Junk", :price => 10.02)
    }.should change(Item, :count).by(1)
  end

  context "is not valid" do
    [:name, :price].each do |attr|
      it "without #{attr}" do
        subject.should_not be_valid
        subject.errors[attr].should_not be_empty
      end
    end
  end
  
  context "associations" do
    it "have many orders" do
      subject.should respond_to(:orders)
    end
  end
  
end
