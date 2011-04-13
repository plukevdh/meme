# -*- ruby -*-

require 'rubygems'
require 'hoe'
require 'bundler'
Bundler::GemHelper.install_tasks

Hoe.plugin :git

Hoe.spec 'meme_generator' do
  developer 'Eric Hodel', 'drbrain@segment7.net'

  rdoc_locations <<
  'docs.seattlerb.org:/data/www/docs.seattlerb.org/meme_generator/'

  extra_deps << ['nokogiri', '~> 1.4']
end

# vim: syntax=ruby
