require "spec_helper"

describe Dashboard::TopicsController do

  describe "routing" do

    it "routes to #index" do
      expect(get("/dashboard/topics")).to route_to("dashboard/topics#index")
    end

    it "routes to #new" do
      expect(get("/dashboard/topics/new")).to route_to("dashboard/topics#new")
    end

    it "routes to #show" do
      expect(get("/dashboard/topics/1")).to route_to("dashboard/topics#show", :id => "1")
    end

    it "routes to #edit" do
      expect(get("/dashboard/topics/1/edit")).to route_to("dashboard/topics#edit", :id => "1")
    end

    it "routes to #create" do
      expect(post("/dashboard/topics")).to route_to("dashboard/topics#create")
    end

    it "routes to #update" do
      expect(put("/dashboard/topics/1")).to route_to("dashboard/topics#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(delete("/dashboard/topics/1")).to route_to("dashboard/topics#destroy", :id => "1")
    end

  end
end
