require 'helper'

class TestArel < Test::Unit::TestCase
  def setup
    @postgres = init_postgres
    @sqlite3  = init_sqlite3
    @mysql    = init_mysql
  end

  def test_01_sql_construction

    assert_equal(
      @postgres[:foo].project(Arel.sql("*")).where(@postgres[:foo][:id].eq('stuff')).to_sql,
      %q[SELECT * FROM "foo"  WHERE "foo"."id" = E'stuff']
    )
  end

  def teardown
    [ @postgres, @sqlite3, @mysql ].each(&:disconnect)
  end
end
