# Magenthor (ALPHA)

A Rubygem wrapper for the XMLRC Magento API.

This code is inspired by, but not based on, [magentor gem](https://github.com/pstuteville/magentor)

## Installation

Since this is still in an early stage of development, I discourage the installation except for debugging (or curiosity) purposes

## Usage

Initialize the connection
```ruby
Magenthor::Base.new({
    :port => 80,
    :host => 'magentohost.tld',
    :api_user => 'apiuser',
    :api_key => 'apikey'
})
```
Get the list of customers
```ruby
Magnethor::Customer.list
```
Find a customer by ID
```ruby
Magenthor::Customer.find 1
```
Find customers by Magento attribute
```ruby
Magenthor::Customer.find_by_email "email@me.tld"
Magenthor::Customer.find_by_group_id 2
#Magenthor::Customer.find_by_[magento customer attribute]
```
Update a customer attributes
```ruby
customer = Magenthor::Customer.find 1
customer.firstname = "John"
customer.update
#=> true
```

## Contributing

1. Fork it ( https://github.com/Ryuk87/magenthor/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
