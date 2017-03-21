# Copyright (C) 2017 Kouhei Sutou <kou@clear-code.com>
# Copyright (C) 1993-2013 Yukihiro Matsumoto <matz@netlab.jp>

# This file is based on test/test_tsort.rb in CRuby.

class TSortHash < Hash
  include TSort
  alias tsort_each_node each_key
  def tsort_each_child(node, &block)
    fetch(node).each(&block)
  end
end

class TSortArray < Array
  include TSort
  alias tsort_each_node each_index
  def tsort_each_child(node, &block)
    fetch(node).each(&block)
  end
end

assert("tsort - dag") do
  h = TSortHash[{1=>[2, 3], 2=>[3], 3=>[]}]
  assert_equal([3, 2, 1], h.tsort)
  assert_equal([[3], [2], [1]], h.strongly_connected_components)
end

assert("tsort - cycle") do
  h = TSortHash[{1=>[2], 2=>[3, 4], 3=>[2], 4=>[]}]
  assert_equal([[4], [2, 3], [1]],
               h.strongly_connected_components.map {|nodes| nodes.sort})
  assert_raise(TSort::Cyclic) { h.tsort }
end

assert("tsort - array") do
  # TODO
  # a = TSortArray[[1], [0], [0], [2]]
  a = TSortArray.new.concat([[1], [0], [0], [2]])
  assert_equal([[0, 1], [2], [3]],
               a.strongly_connected_components.map {|nodes| nodes.sort})

  # TODO
  # a = TSortArray[[], [0]]
  a = TSortArray.new.concat([[], [0]])
  assert_equal([[0], [1]],
               a.strongly_connected_components.map {|nodes| nodes.sort})
end

assert("tsort - TSort.tsort") do
  g = {1=>[2, 3], 2=>[4], 3=>[2, 4], 4=>[]}
  each_node = lambda {|&b| g.each_key(&b) }
  each_child = lambda {|n, &b| g[n].each(&b) }
  assert_equal([4, 2, 3, 1], TSort.tsort(each_node, each_child))
  g = {1=>[2], 2=>[3, 4], 3=>[2], 4=>[]}
  assert_raise(TSort::Cyclic) { TSort.tsort(each_node, each_child) }
end

assert("tsort - TSort.tsort_each") do
  g = {1=>[2, 3], 2=>[4], 3=>[2, 4], 4=>[]}
  each_node = lambda {|&b| g.each_key(&b) }
  each_child = lambda {|n, &b| g[n].each(&b) }
  r = []
  TSort.tsort_each(each_node, each_child) {|n| r << n }
  assert_equal([4, 2, 3, 1], r)

  r = TSort.tsort_each(each_node, each_child).map {|n| n.to_s }
  assert_equal(['4', '2', '3', '1'], r)
end

assert("tsort - TSort.strongly_connected_components") do
  g = {1=>[2, 3], 2=>[4], 3=>[2, 4], 4=>[]}
  each_node = lambda {|&b| g.each_key(&b) }
  each_child = lambda {|n, &b| g[n].each(&b) }
  assert_equal([[4], [2], [3], [1]],
               TSort.strongly_connected_components(each_node, each_child))
  g = {1=>[2], 2=>[3, 4], 3=>[2], 4=>[]}
  assert_equal([[4], [2, 3], [1]],
               TSort.strongly_connected_components(each_node, each_child))
end

assert("tsort - TSort.each_strongly_connected_component") do
  g = {1=>[2, 3], 2=>[4], 3=>[2, 4], 4=>[]}
  each_node = lambda {|&b| g.each_key(&b) }
  each_child = lambda {|n, &b| g[n].each(&b) }
  r = []
  TSort.each_strongly_connected_component(each_node, each_child) {|scc|
    r << scc
  }
  assert_equal([[4], [2], [3], [1]], r)
  g = {1=>[2], 2=>[3, 4], 3=>[2], 4=>[]}
  r = []
  TSort.each_strongly_connected_component(each_node, each_child) {|scc|
    r << scc
  }
  assert_equal([[4], [2, 3], [1]], r)

  r = TSort.each_strongly_connected_component(each_node, each_child).map {|scc|
    scc.map {|element| element.to_s}
  }
  assert_equal([['4'], ['2', '3'], ['1']], r)
end

assert("tsort - TSort.each_strongly_connected_component_from") do
  g = {1=>[2], 2=>[3, 4], 3=>[2], 4=>[]}
  each_child = lambda {|n, &b| g[n].each(&b) }
  r = []
  TSort.each_strongly_connected_component_from(1, each_child) {|scc|
    r << scc
  }
  assert_equal([[4], [2, 3], [1]], r)

  r = TSort.each_strongly_connected_component_from(1, each_child).map {|scc|
    scc.map {|element| element.to_s}
  }
  assert_equal([['4'], ['2', '3'], ['1']], r)
end
