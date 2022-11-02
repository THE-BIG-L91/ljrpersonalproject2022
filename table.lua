tble = {}

function tble.find(t, s, o)
  o = o or 1
  assert(s ~= nil, "second argument cannot be nil")
  for i = o, #t do
    if t[i] == s then
      return i
    end
  end
end

return tble
