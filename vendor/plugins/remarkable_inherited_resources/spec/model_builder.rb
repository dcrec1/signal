# This is based on Remarkable based on Shoulda model builder for Test::Unit.
#
module ModelBuilder
  def self.included(base)
    return unless base.name =~ /^Spec/

    base.class_eval do
      after(:each) do
        if @defined_constants
          @defined_constants.each do |class_name| 
            Object.send(:remove_const, class_name)
          end
        end

        if @created_tables
          @created_tables.each do |table_name|
            ActiveRecord::Base.connection.execute("DROP TABLE IF EXISTS #{table_name}")
          end
        end
      end
    end

    base.extend ClassMethods
  end

  def create_table(table_name, &block)
    connection = ActiveRecord::Base.connection

    begin
      connection.execute("DROP TABLE IF EXISTS #{table_name}")
      connection.create_table(table_name, &block)
      @created_tables ||= []
      @created_tables << table_name
      connection
    rescue Exception => e
      connection.execute("DROP TABLE IF EXISTS #{table_name}")
      raise e
    end
  end

  def define_constant(class_name, base, &block)
    class_name = class_name.to_s.camelize

    klass = Class.new(base)
    Object.const_set(class_name, klass)

    klass.class_eval(&block) if block_given?

    @defined_constants ||= []
    @defined_constants << class_name

    klass
  end

  def define_model_class(class_name, &block)
    define_constant(class_name, ActiveRecord::Base, &block)
  end

  def define_model(name, columns = {}, &block)
    class_name = name.to_s.pluralize.classify
    table_name = class_name.tableize

    table = columns.delete(:table) || lambda {|table|
      columns.each do |name, type|
        table.column name, *type
      end
    }

    create_table(table_name, &table)

    klass    = define_model_class(class_name, &block)
    instance = klass.new

    self.class.subject { instance } if self.class.respond_to?(:subject)
    instance
  end

  module ClassMethods
    # This is a macro to run validations of boolean optionals such as :allow_nil
    # and :allow_blank. This macro tests all scenarios. The specs must have a
    # define_and_validate method defined.
    #
    def create_optional_boolean_specs(optional, base, options={})
      base.describe "with #{optional} option" do
        it { should define_and_validate(options.merge(optional => true)).send(optional)            }
        it { should define_and_validate(options.merge(optional => false)).send(optional, false)    }
        it { should_not define_and_validate(options.merge(optional => true)).send(optional, false) }
        it { should_not define_and_validate(options.merge(optional => false)).send(optional)       }
      end
    end

    def create_message_specs(base)
      base.describe "with message option" do
        it { should define_and_validate(:message => 'valid_message').message('valid_message') }
        it { should_not define_and_validate(:message => 'not_valid').message('valid_message') }
      end
    end
  end

end