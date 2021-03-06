#!/usr/bin/env ruby

require 'ffi'

module Nim
  extend FFI::Library
  ffi_lib "./libpartitions.so"
  attach_function :partitions, [ :pointer, :long_long ], :long_long
end

deck = ([4]*9)
deck << 16

d = 0

for i in 0..9
  # Dealer showing
  deck[i] -= 1
  p = 0
  for j in 0..9
    deck[j] -= 1
    pointer = FFI::MemoryPointer.new :long_long, deck.size
    pointer.put_array_of_long_long 0, deck
    n = Nim.partitions(pointer, j+1)
    deck[j] += 1
    p += n
  end
  print("Dealer showing #{i} partitions = #{p}\n")
  d += p
  deck[i] += 1
end

print("Total partitions = #{d}\n")
