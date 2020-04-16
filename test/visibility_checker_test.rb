ENV['MT_NO_PLUGINS'] = '1' # Work around stupid autoloading of plugins
require 'minitest/global_expectations/autorun'
require_relative '../lib/visibility_checker'

describe "VisibilityChecker.visibility_changes" do
  it 'should return an array of visibility changes' do
    c = Class.new{def a; end}
    VisibilityChecker.visibility_changes(c).must_equal []

    m = Module.new
    c.send(:include, m)
    VisibilityChecker.visibility_changes(c).must_equal []

    m.send(:define_method, :a){}
    VisibilityChecker.visibility_changes(c).must_equal []

    m.send(:private, :a)
    changes = VisibilityChecker.visibility_changes(c)
    changes.size.must_equal 1
    change = changes.first
    change.method.must_equal :a
    change.defined_in.must_equal m
    change.overridden_by.must_equal c
    change.original_visibility.must_equal :private
    change.new_visibility.must_equal :public

    c.send(:private, :a)
    VisibilityChecker.visibility_changes(c).must_equal []

    m2 = Module.new
    c.send(:include, m2)
    m2.send(:define_method, :a){}
    m2.send(:private, :a)
    m.send(:protected, :a)
    changes = VisibilityChecker.visibility_changes(c)
    changes.size.must_equal 1
    change = changes.first
    change.method.must_equal :a
    change.defined_in.must_equal m
    change.overridden_by.must_equal m2
    change.original_visibility.must_equal :protected
    change.new_visibility.must_equal :private

    m2.send(:public, :a)
    changes = VisibilityChecker.visibility_changes(c)
    changes.size.must_equal 2
    change = changes.first
    change.method.must_equal :a
    change.defined_in.must_equal m2
    change.overridden_by.must_equal c
    change.original_visibility.must_equal :public
    change.new_visibility.must_equal :private
    change = changes.last
    change.method.must_equal :a
    change.defined_in.must_equal m
    change.overridden_by.must_equal m2
    change.original_visibility.must_equal :protected
    change.new_visibility.must_equal :public

    m2.send(:private, :a)
    changes = VisibilityChecker.visibility_changes(c)
    changes.size.must_equal 1
    change = changes.first
    change.method.must_equal :a
    change.defined_in.must_equal m
    change.overridden_by.must_equal m2
    change.original_visibility.must_equal :protected
    change.new_visibility.must_equal :private

    m2.send(:remove_method, :a)
    changes = VisibilityChecker.visibility_changes(c)
    changes.size.must_equal 1
    change = changes.first
    change.method.must_equal :a
    change.defined_in.must_equal m
    change.overridden_by.must_equal c
    change.original_visibility.must_equal :protected
    change.new_visibility.must_equal :private
  end

  it 'should respect stop_at keyword agument' do
    c = Class.new{def a; end}
    m = Module.new{private; def a; end}
    c.send(:include, m)
    VisibilityChecker.visibility_changes(c).wont_be_empty
    VisibilityChecker.visibility_changes(c, stop_at: m).must_be_empty
  end

  it 'should respect skip_owners keyword agument' do
    c = Class.new{def a; end}
    m = Module.new{private; def a; end}
    c.send(:include, m)
    VisibilityChecker.visibility_changes(c).wont_be_empty
    VisibilityChecker.visibility_changes(c, skip_owners: []).wont_be_empty
    VisibilityChecker.visibility_changes(c, skip_owners: [m]).must_be_empty

    c.send(:remove_method, :a)
    sc = Class.new(c){def a; end}
    VisibilityChecker.visibility_changes(sc).wont_be_empty
    VisibilityChecker.visibility_changes(sc, skip_owners: []).wont_be_empty
    VisibilityChecker.visibility_changes(sc, skip_owners: [m]).must_be_empty
  end

  it 'should be able to extend other classes and modules and use visibility_changes on them' do
    c = Class.new{def a; end}
    m = Module.new{private; def a; end}
    c.send(:include, m)
    c.extend(VisibilityChecker)
    changes = c.visibility_changes
    changes.size.must_equal 1
    change = changes.first
    change.method.must_equal :a
    change.defined_in.must_equal m
    change.overridden_by.must_equal c
    change.original_visibility.must_equal :private
    change.new_visibility.must_equal :public
  end
end
