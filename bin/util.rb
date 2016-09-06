def system!(*args)
  system(*args) || abort("\n== Command #{args} failed ==")
end
