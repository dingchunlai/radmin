class TestController < ApplicationController

  def ses
    #render :text => "#{cookies['ind_id'].inspect} - #{session['user:user:id'].inspect} | #{user_logged_in?.inspect}", :content_type => Mime::HTML
    render :inline => "Radmin:inline: <%= cookies['ind_id'].inspect %> - <%= session['user:user:id'].inspect %> | <%= user_logged_in?.inspect %>", :content_type => Mime::HTML
  end
  
end
