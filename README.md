**Sequel::Factory** is a little [RubyGem](http://rubygems.org) that lets you
easily specify factories for your [Sequel](http://sequel.rubyforge.org/) models.
A factory is an object that knows how to generate an instance of a model. They
are very useful in testing and development scenarios when you need to simulate
the existence of real data in your system.

Sequel::Factory supports the following features:

  * Multiple factories per model, with different attributes
  * Inclusion of the attributes of one factory into another
  * Ability to configure the `Sequel::Model` method used by a factory to
    generate instances (defaults to `create`)
  * Ability to override factory-generated values on instance creation
  * Sequential attributes (e.g. auto-incrementing ids)

Also, the actual code is only ~100 lines of Ruby, so it should be fairly
straightforward for you to understand.

## Installation

Using [RubyGems](http://rubygems.org/):

    $ sudo gem install sequel-factory

From a local copy:

    $ git clone git://github.com/mjijackson/sequel-factory.git
    $ cd sequel-factory
    $ rake package && sudo rake install

## Usage

Sequel::Factory adds a `factory` method to `Sequel::Model`. You use this
method to define your factories by passing a block and (optionally) a name. When
you pass a block a new instance of `Sequel::Factory` is created.

You call a factory using `Sequel::Model.make`. Each time the factory is called
its block is `instance_eval`'d in the context of the factory. The factory uses
`method_missing` to catch all unknown method calls and their arguments, which
should correspond to the names and values of attributes to use for the model.

This may sound a bit complex, but it works out to be very simple in practice.

```ruby
User.factory do
  # self is User.factory (or User.factories[:default])
  name Randgen.name
end

User.factory(:with_email) do
  # self is User.factory(:with_email)
  include_factory User.factory
  email Randgen.email
end

user1 = User.make               # Has a "name" attribute
user2 = User.make(:with_email)  # Has both "name" and "email" attributes
```

The above example defines two factories on the `User` model: a "default" factory
and another factory named `:with_email`. The `:with_email` factory _includes_
the default factory (using `Sequel::Factory#include_factory`), which just means
that all attributes defined in the default factory will also be set on instances
that are generated with the `:with_email` factory in addition to any attributes
it defines itself.

In the example above I'm using the helpful [randexp gem](http://rubygems.org/gems/randexp)
to generate my factory values, but you can generate them however you like.

If you need to generate unique sequential values you can pass a block to the
attribute name when you call it in the factory. Each time this block is called
it takes an incrementing integer value as its argument. The return value of the
block is used as the value of the attribute.

The following example defines a factory on the `User` model that is able to
generate a new `User` object with unique `id` and `handle` attributes.

```ruby
User.factory do
  id {|n| n }
  handle "user#{id}"
end
```

## License

Copyright 2012 Michael Jackson

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

The software is provided "as is", without warranty of any kind, express or
implied, including but not limited to the warranties of merchantability,
fitness for a particular purpose and non-infringement. In no event shall the
authors or copyright holders be liable for any claim, damages or other
liability, whether in an action of contract, tort or otherwise, arising from,
out of or in connection with the software or the use or other dealings in
the software.
