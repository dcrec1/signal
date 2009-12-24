module BuildsHelper
  def format_output(output)
    output.gsub("\n", "<br>").gsub("\e[0m", '</span>').gsub(/\e\[(\d+)m/, "<span class=\"color\\1\">")
  end
end
