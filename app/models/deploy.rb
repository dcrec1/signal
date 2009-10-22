class Deploy < ActiveRecord::Base
  belongs_to :project
  validates_presence_of :project, :output, :success
end
