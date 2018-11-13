# frozen_string_literal: true

module TypeResolving
  MODELS_CLASS_NAMES = %w[
    ApplicationRecord
    ActiveRecord::Base
  ].freeze

  WORKERS_SUFFIXES = %w[
    Worker
    Job
  ].freeze

  CONTROLLER_SUFFIXES = %w[
    Controller
  ].freeze

  SERVICES_PATH = File.join('app', 'services')

  def on_class(node)
    classdef_node, superclass, _body = *node
    @node = node
    @class_name = classdef_node.loc.expression.source
    @superclass_name = superclass.loc.expression.source unless superclass.nil?
    super if defined?(super)
  end

  def on_module(node)
    @node = node
    super if defined?(super)
  end

  private

  def in_service?
    path = @node.location.expression.source_buffer.name
    services_path = cop_config.fetch('ServicePath') { SERVICES_PATH }
    path.include?(services_path)
  end

  def in_controller?
    return false if @superclass_name.nil?

    @superclass_name.end_with?(*CONTROLLER_SUFFIXES)
  end

  def in_model?
    MODELS_CLASS_NAMES.include?(@superclass_name)
  end

  def in_worker?
    @class_name.end_with?(*WORKERS_SUFFIXES)
  end
end
