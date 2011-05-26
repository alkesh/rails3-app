Rails 3 Template
================

This template includes:

* Cucumber
* Factory Girl
* Flutie
* Formtastic
* JQuery
* RSpec
* Shoulda

Download the app.rb file, and then easily generate a Rails 3 application with the above in one line:

    % rails new my_app -J -T -m app.rb

Once this has completed - cd to your new application's directory,
and run the following:

    % bundle install

(Due to [a bug](https://rails.lighthouseapp.com/projects/8994/tickets/5926) in rails, it is not currently possible to do the following:

    % rails new my_app -J -T -m \
    https://github.com/alkesh/rails3-app/raw/master/app.rb

This will be fixed in rails 3.0.5

rvm
---

The application has an `.rvmrc` generated to specify a gemset.

Generators
----------

This also gives you the Factory Girl generators &mdash; the
generators for RSpec are in the RSpec gem &mdash; so that your factories
are generated using Factory Girl , and that all your generated
tests are specs. These generators are from the
[factory_girl_generator](http://github.com/leshill/factory_girl_generator) gems.

JavaScript Includes
-------------------

Since the Rails helper `javascript_include_tag :defaults` is looking for
Prototype, we change the default JavaScript includes to be jQuery.

git
---

We love `git`, so the application has a git repo initialized with all the initial changes staged.
