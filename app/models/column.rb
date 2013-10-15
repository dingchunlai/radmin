# == Schema Information
#
# Table name: radmin_columns
#
#  id        :integer(11)     not null, primary key
#  formid    :integer(11)
#  cname     :string(255)
#  ctype     :integer(4)      default(1), not null
#  sn        :integer(4)
#  dvalue    :string(999)
#  ovalue    :string(999)
#  remark    :string(999)
#  mustfill  :boolean(1)      default(FALSE), not null
#  sep_type  :integer(11)
#  sep_value :string(255)
#

class Column < ActiveRecord::Base
  self.table_name = "radmin_columns"

  def self.column_new_save(cname, sn, ctype, ovalue, dvalue, remark, mustfill, f_id,sep_type,sep_value)
     begin
      c = Column.new
      c.formid = f_id
      c.cname = cname if pp(cname)
      c.sn = sn if pp(sn)
      c.ctype = ctype if pp(ctype)
      c.ovalue = ovalue
      c.dvalue = dvalue
      c.remark = remark
      c.mustfill = mustfill
      c.sep_type = sep_type
      c.sep_value = sep_value
      c.save
      return ""
    rescue Exception => e
      return get_error(e)
    end
  end

  def self.column_edit_save(cname, sn, ctype, ovalue, dvalue, remark, mustfill, c_id,sep_type,sep_value)
    begin
      c = Column.find(c_id)
      c.cname = cname if pp(cname)
      c.sn = sn if pp(sn)
      c.ctype = ctype if pp(ctype)
      c.ovalue = ovalue
      c.dvalue = dvalue
      c.remark = remark
      c.mustfill = mustfill
      c.sep_type = sep_type
      c.sep_value = sep_value
      c.save
      return ""
    rescue Exception => e
      return get_error(e)
    end
  end

end
