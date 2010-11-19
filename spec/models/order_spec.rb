require 'spec_helper'

describe Order do
  it 'can be created' do
    lambda {
      Order.create(:user => Factory(:user))
    }.should change(Order, :count).by(1)
  end

  context "is not valid" do
    [:user].each do |attr|
      it "without #{attr}" do
        subject.should_not be_valid
        subject.errors[attr].should_not be_empty
      end
    end
  end
  
  context "associations" do
    it "belongs to a user" do
      subject.should respond_to(:user)
    end
    
    it "has one or more items" do
      subject.should respond_to(:items)
    end
  end
 end
