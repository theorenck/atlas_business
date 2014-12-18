Rails.application.configure do
	config.middleware.insert_before 0, "Rack::Cors" do
	  allow do
	    origins '*'
	    resource '*', :headers => :any, :methods => [:get, :post, :put, :patch, :delete, :options, :head]
	  end
	end
end