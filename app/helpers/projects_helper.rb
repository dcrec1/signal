module ProjectsHelper
  def metrics_path(project)
    "/projects/#{project.name}/tmp/metric_fu/output/index.html"
  end
end
