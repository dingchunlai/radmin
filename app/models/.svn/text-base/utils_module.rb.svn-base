# To change this template, choose Tools | Templates
# and open the template in the editor.

module UtilsModule
     def self.updates(object,attributes, id)
      r = object.find(id)
      updates = []
      attributes.each_pair do |k, v|
          v = trim(v).gsub("'","‘")
          updates << "#{k} = '#{v}'" if r[k].to_s != v
      end
      0.step(updates.length-1,30) do |i|
          ups = updates[i..(i+29)]
          object.update_all(ups.join(", "), "id = #{id}")
      end
  end
end
