# frozen_string_literal: true

require 'rubocop'

module Ducalis
  class BlackListSuffix < RuboCop::Cop::Cop
    OFFENSE = <<-MESSAGE.gsub(/^ +\|\s/, '').strip
      | Please, avoid using of class suffixes like `Meneger`, `Client` and so on. If it has no parts, change the name of the class to what each object is managing.

      | It's ok to use Manager as subclass of Person, which is there to refine a type of personal that has management behavior to it.
    MESSAGE

    DETAILS = <<-MESSAGE.gsub(/^ +\|\s/, '').strip
      | Related [article](<http://www.carlopescio.com/2011/04/your-coding-conventions-are-hurting-you.html>)
    MESSAGE

    def on_class(node)
      classdef_node, _superclass, _body = *node
      return unless with_blacklisted_suffix?(classdef_node.source)
      add_offense(node, :expression, OFFENSE)
    end

    private

    def with_blacklisted_suffix?(name)
      return if cop_config['BlackList'].to_a.empty?
      cop_config['BlackList'].any? { |suffix| name =~ /#{suffix}\Z/ }
    end
  end
end
