require 'helper'

class TestArel < Test::Unit::TestCase
  def setup
    @pg_dbh = init_postgres
    @s3_dbh = init_sqlite3
    @my_dbh = init_mysql
  end

  def test_01_sql_construction
    assert true
  end

  def teardown
    [@pg_dbh, @s3_dbh, @my_dbh].each(&:disconnect)
  end
end
