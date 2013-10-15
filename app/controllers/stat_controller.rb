class StatController < ApplicationController

  def visit
    sid =params[:sid] #统计编号
    if pp(sid)
      st = Stat.find :first, :select => "id, sid, forward", :conditions => "sid = #{sid}"
      if st.nil?
        render :text => "none"
      else
        sd = StatData.new
        sd.sid = sid
        sd.userip = request.remote_ip
        sd.vtime = getnow()
        sd.save
        redirect_to st.forward
      end 
    end
  end

end
