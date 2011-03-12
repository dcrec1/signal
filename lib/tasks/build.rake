task :clean do
  system "rm rerun.txt"
end

task :build => ['db:migrate', :spec, :clean, :cucumber, 'metrics:all']
