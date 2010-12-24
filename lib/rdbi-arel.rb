require 'arel'
require 'rdbi'

class RDBI::Pool
  def with_connection
    yield RDBI::Arel::Connection.new(get_dbh)
  end
  
  def spec
    self
  end

  def config
    { :adapter => @connect_args[0].to_s.downcase }
  end
end

class RDBI::Arel
  def initialize(*connection_params)
    @pool = RDBI::Pool.new(:arel, connection_params, 1)
  end

  def table(table_name)
    Arel::Table.new(table_name, RDBI::Arel::TableEngine.new(@pool, table_name))
  end

  class Connection

    attr_reader :tables

    def initialize(dbh)
      @dbh = dbh
      @schema = @dbh.schema

      @primary_keys = { }
      @tables = []

      @schema.each_with_index do |table, i|
        column = @schema[i].columns.find(&:primary_key)
        if column
          @primary_keys[table.to_s] = column.name.to_s
        else
          @primary_keys[table.to_s] = nil
        end

        @tables.push(table.to_s)
      end
    end

    def primary_key(name)
      @primary_keys[name.to_s]
    end

    def table_exists?(name)
      !!@schema[name.to_s]
    end

    def columns(name, message = nil)
      # FIXME what is the message for?
      @schema[name.to_s]
    end

    def quote_table_name(name)
      "\"#{name.to_s}\""
    end

    def quote_column_name(name)
      "\"#{name.to_s}\""
    end

    def quote(thing, column = nil)
      @dbh.quote(thing)
    end
  end

  class TableEngine
    def initialize(pool, table_name)
      @pool = pool
      @dbh = @pool.get_dbh
    end

    def [](call)
      self.send(call)
    end

    def columns
      @dbh.table_schema(table_name)
    end

    def connection_pool
      @pool
    end
  end
end

__END__

arel = RDBI::Arel.new(:PostgreSQL, :database => 'rdbi_test')
ord = arel.table(:ordinals)
foo = arel.table(:pk_test)
puts ord.project(Arel.sql("*")).join(foo).on(ord[:id].eq(foo[:id])).where(ord[:id].eq('stuff')).to_sql
# SELECT * FROM "ordinals" INNER JOIN "pk_test" ON "ordinals"."id" = "pk_test"."id" WHERE "ordinals"."id" = E'stuff'
