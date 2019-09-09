require_relative "../config/environment.rb"

class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]

  attr_accessor :name, :grade
  attr_reader :id

  def initialize(id=nil, name, grade)
      @id = id
      @name = name
      @grade = grade
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students (
          id INTEGER PRIMARY KEY,
          name TEXT,
          grade TEXT
        )
        SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
      sql = "DROP TABLE IF EXISTS students"
      DB[:conn].execute(sql)
  end

  def save

      if @id ==nil
          sql = <<-SQL
          INSERT INTO students (name, grade)
          VALUES (?, ?)
          SQL

          DB[:conn].execute(sql, self.name, self.grade)
          @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
      else
          sql = <<-SQL
          UPDATE students
          SET name = ?, grade = ?
          WHERE id = ?
          SQL

          DB[:conn].execute(sql, self.name, self.grade, self.id)
      end
  end

  def self.create(name, grade)
      student = Student.new
      student.name = name
      student.grade = grade
  end




end
