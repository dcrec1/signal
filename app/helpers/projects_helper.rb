module ProjectsHelper
  def build_date_for(project)
    date = project.last_builded_at
    date.nil? ? "" : ago(date)
  end

  def ago(time)
    "#{time_ago_in_words(time)} #{I18n.t(:ago)}"
  end
end
