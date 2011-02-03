require File.dirname(__FILE__) + '/spec_helper'
#require 'dm-core/spec/shared/adapter_spec'

describe DataMapper::Adapters::HbaseAdapter do
  
  before :all do
    attrs = {:name => "Hasham", :age => 32}
    @person = Person.new(attrs)
  end

  #it_should_behave_like 'An Adapter'

  it 'should create a record' do
    @person.age.should == 32
    @person.save.should be_true
  end

  describe 'with a saved record ' do
    before(:each) { @person.save }
    after(:each) { @person.destroy }
    it 'should get all records in collection of objects with properties saved' do
      Person.all.length.should == 2
      Person.all.first.class.should == Person
      Person.all.first.age.should == 32
      Person.all.last.name.should == "Hasham"
    end
  end

#  describe 'with a saved object check query interface' do
#    before(:each) { @person.save }
#    after(:each) { @person.destroy }
#  end

end
