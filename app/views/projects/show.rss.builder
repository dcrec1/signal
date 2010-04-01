xml.instruct!

xml.rss "version" => "2.0", "xmlns:dc" => "http://purl.org/dc/elements/1.1/" do
 xml.channel do

   xml.title       "Signal::#{@project.name}"
   xml.link        project_url(@project) 
   xml.description "Signal status for #{@project.name}"

   @project.builds.reverse.each do |build|
     xml.item do
       xml.title       build.status 
       xml.link        project_build_url(@project, build)
       xml.guid        project_build_url(@project, build)
       xml.description build.comment
       xml.author      build.author
       xml.pubDate     build.created_at
     end
   end
 end
end
