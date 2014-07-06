namespace :apache do

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

	desc "Enable site"
	task :ensite do
		queue! %[echo "-----> Enabling #{app_name}"]
		queue! %[sudo a2ensite #{app_name}]
		invoke :'apache:reload' 
	end

	desc "Disable site"
	task :dissite do
		queue! %[echo "-----> Disabling #{app_name}"]
		queue! %[sudo a2dissite #{app_name}]
		invoke :'apache:reload' 
	end

	desc "Unlink vHost"
	task :unlink do
		invoke :'apache:dissite'
		queue! %[echo "-----> Unlinking #{app_name}"]
		queue! %[sudo rm  /etc/apache2/sites-available/#{app_name}]
		invoke :'apache:reload' 
	end

	desc "Link vHost"
	task :link do
		queue! %[echo "-----> Linking #{deploy_to}/shared/mina-vhost to /etc/apache2/sites-available/#{app_name}"]
		queue! %[sudo ln -s  "#{deploy_to}/shared/mina-vhost" "/etc/apache2/sites-available/#{app_name}"]
		invoke :'apache:reload' 
	end

	desc "Mina vHost Setup"
	task :vhost do
		queue! %[cd "#{deploy_to}/shared/"]
		queue! %[wget "https://gist.githubusercontent.com/fmccoy/3d24ee9dd78e2dc7e95a/raw/5f3e88e353b6267d0dfa479cd309d04df016c9e5/mina-vhost"]
	end
	
end