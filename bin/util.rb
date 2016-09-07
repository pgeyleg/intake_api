# frozen_string_literal: true

def system!(*args)
  system(*args) || abort("\n== Command #{args} failed ==")
end
