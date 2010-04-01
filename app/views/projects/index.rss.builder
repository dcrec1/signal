xml.instruct!

xml.rss "version" => "2.0", "xmlns:dc" => "http://purl.org/dc/elements/1.1/" do
 xml.channel do

   xml.title       "Signal"
   xml.link        root_url
   xml.description "Signal projects status"

   @projects.each do |project|
     xml.item do
       xml.title       project.name
       xml.link        project_url(project)
       xml.guid        project_url(project)
       unless project.builds.last.nil?
         xml.description "#{project.status}: #{project.builds.last.comment}" 
         xml.author      project.builds.last.author
         xml.pubDate     project.builds.last.created_at
        end
     end
   end
 end
end
