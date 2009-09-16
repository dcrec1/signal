class Build < ActiveRecord::Base
  belongs_to :project
  validates_presence_of :project, :log, :success
end
