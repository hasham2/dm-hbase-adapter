require File.dirname(__FILE__) + '/spec_helper'
#require 'dm-core/spec/shared/adapter_spec'

describe DataMapper::Adapters::HbaseAdapter do
  
  before :all do
    attrs = {:id => "#{Time.now.to_s}", :name => "Hasham", :age => 32}
    @person = Person.new(attrs)
  end

  #it_should_behave_like 'An Adapter'

  it 'should create a record' do
    @person.age.should == 32
    @person.save.should be_true
  end

#  #describe 'with a saved record ' do
#    before(:each) { @person.save }
#    after(:each) { @person.destroy }
#    it 'should get a record' do
#      person.get!(@person.id, @person.name)
#      person.should_not be_nil
#      person.age.should == @person.age
#    end  
#  #end

end
