# Requires 'tasks/common.rb'

namespace :composer do

	desc "Runs composer install command."
	task :install do
		queue %[echo "-----> Composer Install"]
		queue %[composer install]
	end

	desc "Runs composer validate command."
	task :validate do
		queue %[echo "-----> Composer Validate"]
		queue %[composer validate]
	end

	desc "Runs composer update command."
	task :update do
		queue %[echo "-----> Composer Update"]
		queue %[composer update]
	end

	desc "Runs composer self-update command."
	task :selfupdate do
		queue %[echo "-----> Composer Self Update"]
		queue %[composer self-update]
	end

end



