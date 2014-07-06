task :projectdir do
	queue %[cd "#{deploy_to}/current"]
	queue %[echo "----> Moved into... " && pwd]
end

task :rollback => :environment do 
  queue %[echo "----> Start to rollback"]
  queue %[if [ $(ls #{deploy_to}/releases | wc -l) -gt 1 ]; then echo "---->Relink to previos release" && unlink #{deploy_to}/current && ln -s #{deploy_to}/releases/"$(ls #{deploy_to}/releases | tail -2 | head -1)" #{deploy_to}/current && echo "Remove old releases" && rm -rf #{deploy_to}/releases/"$(ls #{deploy_to}/releases | tail -1)" && echo "$(ls #{deploy_to}/releases | tail -1)" > #{deploy_to}/last_version && echo "Done. Rollback to v$(cat #{deploy_to}/last_version)" ; else echo "No more release to rollback" ; fi]
end

task :createlogs do
	queue! %[mkdir -p "#{deploy_to}/logs"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/logs"]
end