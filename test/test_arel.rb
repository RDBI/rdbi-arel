require 'helper'

class TestArel < Test::Unit::TestCase
  def setup
    @postgres = init_postgres
    @sqlite3  = init_sqlite3
    @mysql    = init_mysql
  end

  def test_01_sql_basic_select
    assert_equal(
      @sqlite3[:foo].project(Arel.sql("*")).where(@sqlite3[:foo][:id].eq('stuff')).to_sql,
      %q[SELECT * FROM "foo"  WHERE "foo"."id" = 'stuff']
    )

    assert_equal(
      @postgres[:foo].project(Arel.sql("*")).where(@postgres[:foo][:id].eq('stuff')).to_sql,
      %q[SELECT * FROM "foo"  WHERE "foo"."id" = E'stuff']
    )

    assert_equal(
      @mysql[:foo].project(Arel.sql("*")).where(@mysql[:foo][:id].eq('stuff')).to_sql,
      %q[SELECT * FROM "foo"  WHERE "foo"."id" = 'stuff']
    )
  end


  def test_02_join
    assert_equal(
      @sqlite3[:foo].project(Arel.sql("*")).join(@sqlite3[:bar]).on(@sqlite3[:bar][:id].eq(@sqlite3[:foo][:id])).to_sql,
      %q[SELECT * FROM "foo" INNER JOIN "bar" ON "bar"."id" = "foo"."id"]
    )
    
    assert_equal(
      @postgres[:foo].project(Arel.sql("*")).join(@postgres[:bar]).on(@postgres[:bar][:id].eq(@postgres[:foo][:id])).to_sql,
      %q[SELECT * FROM "foo" INNER JOIN "bar" ON "bar"."id" = "foo"."id"]
    )
    
    assert_equal(
      @mysql[:foo].project(Arel.sql("*")).join(@mysql[:bar]).on(@mysql[:bar][:id].eq(@mysql[:foo][:id])).to_sql,
      %q[SELECT * FROM "foo" INNER JOIN "bar" ON "bar"."id" = "foo"."id"]
    )
  end

  def teardown
    [ @postgres, @sqlite3, @mysql ].each(&:disconnect)
  end
end
