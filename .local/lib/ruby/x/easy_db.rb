require 'delegate'
require 'pathname'
require 'sqlite3'

#
# # Usage
#
# - Run `EasyDB.init` to create db.sqlite3, db.schema.sql, and db.ops.sql.
# - Edit db.schema.sql and db.ops.sql as you like.
# - `db = EasyDB.open` opens the database.
# - `db.ops.${query_name}` executes the query of that name defined in db.ops.sql.
#

class EasyDB < SimpleDelegator
  class Ops < Data
    def self.from_sql(sql)
      matches = sql.to_enum(:scan, /^--\s*def\s+([0-9A-Za-z_?!]+)$/).map do |(name)|
        [name.to_sym, Regexp.last_match.offset(0)]
      end

      op_names = matches.map(&:first)
      op_sqls = (matches.map(&:last) << [nil, nil]).each_cons(2).map do |(_, match_end), (next_match_begin, _)|
        sql[match_end...next_match_begin]
      end

      define(*op_names).new(*op_sqls)
    end
  end

  def self.init(path = 'db.sqlite3')
    path = Pathname.new(path)

    unless (app_path = path.dirname / 'app.rb').exist?
      app_path.write(<<~'RUBY')
        require 'x/easy_db'

        db = EasyDB.open
        ops = db.ops

        db.execute(ops.insert_item, { name: 'apple' })
        p db.execute(ops.select_items)
      RUBY

      puts "Created #{app_path}"
    end

    unless (schema_path = path.sub_ext('.schema.sql')).exist?
      schema_path.write(<<~'SQL')
        CREATE TABLE IF NOT EXISTS items (name TEXT NOT NULL);
      SQL

      puts "Created #{schema_path}"
    end

    unless (ops_path = path.sub_ext('.ops.sql')).exist?
      ops_path.write(<<~'SQL')
        -- def insert_item

        INSERT INTO items (name) VALUES (:name);

        -- def select_items

        SELECT * FROM items;
      SQL

      puts "Created #{ops_path}"
    end
  end

  def self.open(path = 'db.sqlite3')
    aux_path = Pathname.new(path == ':memory:' ? '_memory_' : path)

    conn = SQLite3::Database.new(path)

    if (schema_path = aux_path.sub_ext('.schema.sql')).file?
      conn.execute_batch(schema_path.read)
    end

    ops = nil

    if (ops_path = aux_path.sub_ext('.ops.sql')).file?
      ops = Ops.from_sql(ops_path.read)
    end

    new(conn, ops)
  end

  attr_reader :ops

  def initialize(conn, ops)
    super(conn)
    @ops = ops
  end
end
