require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'test/unit'
require 'rdbi'
require 'rdbi-driver-postgresql'
require 'rdbi-driver-mysql'
require 'rdbi-driver-sqlite3'
require 'rdbi-dbrc'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rdbi-arel'

class Test::Unit::TestCase
  SQL =
  [
    'drop table if exists foo',
    'create table foo (id integer primary key, foo varchar(255))',
    'drop table if exists bar',
    'create table bar (id integer primary key, bar varchar(255))',
  ]
 
  def init_db(rc_string)
    arel = RDBI::DBRC.arel_connect(rc_string)
    SQL.each { |x| arel.dbh.execute_modification(x) }
    return arel 
  end

  def init_postgres
    return init_db(:postgresql_test)
  end

  def init_mysql
    return init_db(:mysql_test)
  end

  def init_sqlite3
    return init_db(:sqlite3_test)
  end
end
