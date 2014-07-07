namespace :apache do

	task :setup do
		invoke :'apache:vhost'
		invoke :'createlogs'
	end

	desc "Restarts the Apache service."
	task :restart do
		queue! %[echo "-----> Apache Restart"]
		queue! %[sudo service apache2 restart]
	end

	desc "Reload the Apache configuration files."
	task :reload do
		queue! %[echo "-----> Apache Reload"]
		queue! %[sudo service apache2 reload]
	end

	desc "Enable site, enables site and reloads apache"
	task :ensite do
		queue! %[echo "-----> Enabling #{app_name}"]
		
		# Enable site
		queue! %[sudo a2ensite #{app_name}]
		
		# Reload Apache
		invoke :'apache:reload' 
	end

	desc "Disable site, disables site and reloads apache"
	task :dissite do
		queue! %[echo "-----> Disabling #{app_name}"]
		queue! %[sudo a2dissite #{app_name}]
		invoke :'apache:reload' 
	end

	desc "Unlink vHost, disables and removes site, then reloads apache"
	task :unlink do
		queue! %[echo "-----> Unlinking #{app_name}"]

		# Disable site
		invoke :'apache:dissite'
		
		# Remove siteconf
		queue! %[sudo rm  /etc/apache2/sites-available/#{app_name}]
		
		# Reload Apache
		invoke :'apache:reload' 
	end

	desc "Link vHost"
	task :link do
		queue! %[echo "-----> Linking #{deploy_to}/shared/vhost to /etc/apache2/sites-available/#{app_name}"]
		
		# Symlink site's vhost to Apache
		queue! %[sudo ln -sf  "#{deploy_to}/shared/vhost" "/etc/apache2/sites-available/#{app_name}"]
		
		# Reload Apache
		invoke :'apache:reload' 
	end

	desc "Mina vHost Setup"
	task :vhost do
		queue! %[git clone "git@gist.github.com:/3d24ee9dd78e2dc7e95a.git" "#{deploy_to}/tmp/mina-vhost"]
		queue! %[rsync -aqu "#{deploy_to}/tmp/mina-vhost/mina-vhost" "#{deploy_to}/shared/mina-vhost"]
		queue! %[rsync -aqu "#{deploy_to}/shared/mina-vhost" "#{deploy_to}/shared/vhost"]
	end
	
end