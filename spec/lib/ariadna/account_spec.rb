require 'spec_helper'

describe "Accounts" do
  before :each do
    @conn     = Ariadna::Analytics.new("token")
    @accounts = @conn.accounts.all
  end

  it "uses version 3 of the api" do
    Ariadna::Account::URL.should == "https://www.googleapis.com/analytics/v3/management/accounts"
  end

  context "A new account" do
    before :each do
      new_account = {
        "id"         => 43214321, 
        "name"       => "New account", 
        "selfLink"   => "www.example.com/self", 
        "childLink"  => {"href"=>"www.example.com/child/43214231"}
      }

      @account = Ariadna::Account.new(new_account)
    end

    it "should map each value into attributes" do
      @account.name.should       == "New account"
      @account.id.should         == 43214321
      @account.selfLink          == "www.example.com/self"
      @account.childLink["href"] == "www.example.com/child/43214231"
    end
  end

  context :properties do
    before :each do
      @properties = @accounts.first.properties.all
    end

    it "gets a list of properties" do
      @properties.size.should == 1
    end

    it "returns a list of WebProperty objects" do
      @properties.first.class == Ariadna::WebProperty
    end
  end

  context "can find an account by id or name" do
    it "should return an empty array if can not find anything" do
      account = Ariadna::Account.find({})
      account.size.should == 0
    end

    it "should return the requested account filtered by name" do
      account = Ariadna::Account.find(:name => "my COMpany account")
      account.id.should == 111
    end

    it "should return the requested account filtered by name" do
      account = Ariadna::Account.find(:id => 222)
      account.name.should == 'name 222'
    end
  end
end