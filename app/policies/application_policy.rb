# frozen_string_literal: true

class ApplicationPolicy
  attr_reader :record

  def initialize(record)
    @record = record
  end

  def index?
    false
  end

  def show?
    false
  end

  def create?
    false
  end

  class Scope
    def initialize(scope)
      @scope = scope
    end

    def resolve
      raise NotImplementedError, "You must define #resolve in #{self.class}"
    end

    private

    attr_reader :scope
  end
end
