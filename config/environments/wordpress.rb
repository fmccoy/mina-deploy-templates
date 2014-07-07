# Requires 'tasks/common.rb'

namespace :wp do

	# Manually create these paths in shared/ (eg: shared/config/database.yml) in your server.
	# They will be linked in the 'deploy:link_shared_paths' step.
	set :shared_paths, ['content/uploads']

	# Put any custom mkdir's in here for when `mina setup` is ran.
	# For Rails apps, we'll make some of the shared paths that are shared between
	# all releases.
	task :setup => :environment do
		# Bootstrap Directory
		invoke :'bootstrap'
		# Apache setup
		invoke :'apache:setup'
		# Wordpress setup
		invoke :'wp:setup'
	end

	desc "Deploys the current version to the server."
	task :deploy => :environment do
	  deploy do
	    # Put things that will set up an empty directory into a fully set-up
	    # instance of your project.
	    invoke :'git:clone'
	    invoke :'composer:install'
	    invoke :'deploy:link_shared_paths'
    
	    to :launch do
	      queue "touch #{deploy_to}/tmp/restart.txt"
	    end
	  end
	end

	task :activate do

		invoke :'wp:syncdb'
	  #invoke :'wp:activate'

		# SymLink the vhost to make available
	  invoke :'apache:link'
	  
	  # Enable Site in apache
	  invoke :'apache:ensite'

	end

	desc "Syncs the database credentials."
	task :syncdb do
		queue! %[echo "-----> Linking #{deploy_to}/shared/database.php to #{deploy_to}/current/local/config.php"]
		
		# Makes a copy of config-sample.php, if doesn't exist it creates database.php
		queue! %[rsync -aqu "#{deploy_to}/current/local/config-sample.php" "#{deploy_to}/shared/database.php"]

		# Symlinks database.php to config.php
		queue! %[sudo ln -sf  "#{deploy_to}/shared/database.php" "#{deploy_to}/current/local/config.php"]
	end

	task :setup do
			# Make the WordPress Uploads folder
		  queue! %[mkdir -p "#{deploy_to}/shared/content/uploads"]
		  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/content/uploads"]

	end

end